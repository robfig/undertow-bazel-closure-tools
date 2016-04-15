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

"""Build definitions for Closure JavaScript libraries.
"""

load("//closure/private:defs.bzl",
     "JS_LANGUAGE_DEFAULT",
     "JS_DEPS_ATTR",
     "JS_FILE_TYPE",
     "collect_js_srcs",
     "determine_js_language")

def _impl(ctx):
  srcs, externs = collect_js_srcs(ctx)
  if ctx.files.exports:
    for forbid in ['srcs', 'externs', 'deps']:
      if getattr(ctx.files, forbid):
        fail("'exports' may not be specified when '%s' is set" % forbid)
  else:
    if not ctx.files.srcs and not ctx.files.externs:
      fail("Either 'srcs' or 'externs' must be specified")
    if ctx.files.srcs and ctx.files.externs:
      fail("'srcs' may not be specified when 'externs' is set")
  inputs = []
  args = ["--output_file=%s" % ctx.outputs.provided.path,
          "--label=%s" % ctx.label]
  if ctx.attr.testonly:
    args += ["--testonly"]
  for direct_src in JS_FILE_TYPE.filter(ctx.files.srcs):
    args += ["--src=%s" % direct_src.path]
    inputs.append(direct_src)
  for direct_extern in JS_FILE_TYPE.filter(ctx.files.externs):
    args += ["--extern=%s" % direct_extern.path]
    inputs.append(direct_extern)
  for direct_dep in ctx.attr.deps:
    args += ["--dep=%s" % direct_dep.js_provided.path]
    inputs.append(direct_dep.js_provided)
  ctx.action(
      inputs=inputs,
      outputs=[ctx.outputs.provided],
      executable=ctx.executable._jschecker,
      arguments=args,
      mnemonic="JSChecker",
      progress_message="Sanity checking %d JS files in %s" % (
          len(srcs) + len(externs), ctx.label))
  return struct(files=set(ctx.files.srcs),
                js_language=determine_js_language(ctx),
                js_exports=ctx.files.exports,
                js_provided=ctx.outputs.provided,
                transitive_js_srcs=srcs,
                transitive_js_externs=externs,
                runfiles=ctx.runfiles(files=[ctx.outputs.provided]))

closure_js_library = rule(
    implementation=_impl,
    attrs={
        "srcs": attr.label_list(allow_files=JS_FILE_TYPE),
        "externs": attr.label_list(allow_files=JS_FILE_TYPE),
        "deps": JS_DEPS_ATTR,
        "exports": JS_DEPS_ATTR,
        "language": attr.string(default=JS_LANGUAGE_DEFAULT),
        "_jschecker": attr.label(
            default=Label("//closure/compiler/jschecker"),
            executable=True),
    },
    outputs={"provided": "%{name}-provided.txt"})
