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

"""Rule for building JavaScript binaries with Closure Compiler.
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
  language_in = determine_js_language(ctx, normalize=True)
  language_out = ctx.attr.language
  args = [
      "--js_output_file=%s" % ctx.outputs.out.path,
      "--create_source_map=%s" % ctx.outputs.map.path,
      "--language_in=%s" % language_in,
      "--language_out=%s" % language_out,
      "--compilation_level=" + ctx.attr.compilation_level,
      "--warning_level=VERBOSE",
      "--new_type_inf",
      "--generate_exports",
  ]
  roots = set([ctx.outputs.out.root.path])
  for src in srcs:
    roots += [src.root.path]
  for root in roots:
    mapping = ""
    if not root:
      mapping += "/"
    args += ["--source_map_location_mapping=%s|%s" % (root, mapping)]
  args += JS_HIDE_WARNING_ARGS
  if ctx.attr.formatting:
    args += ["--formatting=" + ctx.attr.formatting]
  if ctx.attr.debug:
    args += ["--debug"]
  else:
    if is_using_closure_library(srcs):
      args += ["--define=goog.DEBUG=false"]
  if ctx.attr.main:
    args += [
        "--dependency_mode=STRICT",
        "--entry_point=goog:%s" % ctx.attr.main,
    ]
  else:
    args += ["--dependency_mode=LOOSE"]
  if ctx.attr.pedantic:
    args += JS_PEDANTIC_ARGS
    args += ["--use_types_for_optimization"]
  args += ctx.attr.defs
  args += ["--externs=%s" % extern.path for extern in externs]
  args += ["--js=%s" % src.path for src in srcs]
  ctx.action(
      inputs=list(srcs) + list(externs),
      outputs=[ctx.outputs.out, ctx.outputs.map],
      executable=ctx.executable._compiler,
      arguments=args,
      mnemonic="JSCompile",
      progress_message="Compiling %d JavaScript files to %s" % (
          len(srcs) + len(externs),
          ctx.outputs.out.short_path))
  return struct(files=set([ctx.outputs.out]))

closure_js_binary = rule(
    implementation=_impl,
    attrs={
        "deps": JS_DEPS_ATTR,
        "main": attr.string(),
        "compilation_level": attr.string(default="ADVANCED"),
        "pedantic": attr.bool(default=False),
        "debug": attr.bool(default=False),
        "formatting": attr.string(),
        "language": attr.string(default="ECMASCRIPT3"),
        "defs": attr.string_list(),
        "_compiler": attr.label(
            default=Label("//closure/compiler"),
            executable=True),
    },
    outputs={"out": "%{name}.js",
             "map": "%{name}.js.map"})
