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

"""Test rule for linting JavaScript files in both Google and Closure style.

See: https://google.github.io/styleguide/javascriptguide.xml
     https://developers.google.com/closure/compiler/docs/js-for-compiler
"""

load("//closure/private:defs.bzl",
     "JS_DEPS_ATTR",
     "JS_FILE_TYPE",
     "collect_js_srcs")

def _impl(ctx):
  srcs = JS_FILE_TYPE.filter(ctx.files.srcs)
  args = ["external/closure_linter/gjslint",
          "--jslint_error=%s" % ",".join(ctx.attr.errors)]
  args += ctx.attr.defs
  args += [src.short_path for src in srcs]
  script = (
      "#!/bin/bash\n" +
      " \\\n  ".join(args) + " \\\n" +
      "  | cat\n" +  # TODO(jart): sed here
      "exit ${PIPESTATUS[0]}")
  ctx.file_action(
      executable=True,
      output=ctx.outputs.executable,
      content=script)
  return struct(files=set([ctx.outputs.executable]),
                runfiles=ctx.runfiles(
                    files=srcs,
                    transitive_files=ctx.attr._linter.data_runfiles.files,
                    collect_data=True))

closure_js_lint_test = rule(
    test=True,
    implementation=_impl,
    attrs={
        "srcs": attr.label_list(allow_files=JS_FILE_TYPE),
        "errors": attr.string_list(default=["all"]),
        "defs": attr.string_list(),
        "_linter": attr.label(
            default=Label("@closure_linter//:gjslint"),
            executable=True),
    })
