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

"""Testing utilities for Closure Rules."""

def _file_test_impl(ctx):
  """check that a file has a given content."""
  exe = ctx.outputs.executable
  file_ = ctx.file.file
  content = ctx.attr.content
  regexp = ctx.attr.regexp
  matches = ctx.attr.matches
  if bool(content) == bool(regexp):
    fail("Must specify one and only one of content or regexp")
  if content and matches != -1:
    fail("matches only makes sense with regexp")
  if content:
    dat = ctx.new_file(ctx.configuration.genfiles_dir, exe, ".dat")
    ctx.file_action(
        output=dat,
        content=content)
    ctx.file_action(
        output=exe,
        content="diff -u %s %s" % (dat.short_path, file_.short_path),
        executable=True)
    return struct(runfiles=ctx.runfiles([exe, dat, file_]))
  if matches != -1:
    script = "[ %s == $(grep -c %s %s) ]" % (
        matches, repr(regexp), file_.short_path)
  else:
    script = "grep %s %s" % (repr(regexp), file_.short_path)
  ctx.file_action(
      output=exe,
      content=script,
      executable=True)
  return struct(runfiles=ctx.runfiles([exe, file_]))

file_test = rule(
    attrs = {
        "file": attr.label(
            mandatory = True,
            allow_files = True,
            single_file = True,
        ),
        "content": attr.string(default = ""),
        "regexp": attr.string(default = ""),
        "matches": attr.int(default = -1),
    },
    executable = True,
    test = True,
    implementation = _file_test_impl,
)
