# -*- mode: python; -*-
#
# Copyright 2016 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Test rule for validating JavaScript types but not producing a compiled file.
"""

load("//closure/private:defs.bzl",
     "JS_DEPS_ATTR",
     "JS_LANGUAGE_DEFAULT",
     "JS_PEDANTIC_ARGS",
     "JS_HIDE_WARNING_ARGS",
     "collect_js_srcs",
     "determine_js_language",
     "is_using_closure_library")

def _impl(ctx):
  srcs, externs = collect_js_srcs(ctx)
  args = [
      "closure/compiler/compiler",
      "--checks-only",
      "--language_in=%s" % determine_js_language(ctx, normalize=True),
      "--compilation_level=ADVANCED",
      "--warning_level=VERBOSE",
      "--new_type_inf",
  ]
  if is_using_closure_library(srcs):
    args += ["--dependency_mode=LOOSE"]
  if ctx.attr.pedantic:
    args += JS_PEDANTIC_ARGS
  args += JS_HIDE_WARNING_ARGS
  args += ctx.attr.defs
  args += ["--externs='%s'" % extern.path for extern in externs]
  args += ["--js='%s'" % src.path for src in srcs]
  ctx.file_action(
      executable=True,
      output=ctx.outputs.executable,
      content="#!/bin/sh\nexec " + " \\\n  ".join(args) + "\n")
  return struct(files=set([ctx.outputs.executable]),
                runfiles=ctx.runfiles(
                    files=list(srcs) + list(externs),
                    transitive_files=ctx.attr._compiler.data_runfiles.files,
                    collect_data=True))

closure_js_check_test = rule(
    test=True,
    implementation=_impl,
    attrs={
        "deps": JS_DEPS_ATTR,
        "defs": attr.string_list(),
        "pedantic": attr.bool(default=False),
        "_compiler": attr.label(
            default=Label("//closure/compiler"),
            executable=True),
    })
