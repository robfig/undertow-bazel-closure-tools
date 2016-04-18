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

"""Common build definitions for Closure Compiler build definitions.
"""

JS_LANGUAGE_DEFAULT = "ECMASCRIPT5_STRICT"
JS_FILE_TYPE = FileType([".js"])
JS_TEST_FILE_TYPE = FileType(["_test.js"])
_CLOSURE_ROOT = "external/closure_library/closure/goog"
_CLOSURE_REL = "../../../.."

JS_LANGUAGES = set([
    "ANY",
    "ECMASCRIPT3",
    "ECMASCRIPT5",
    "ECMASCRIPT5_STRICT",
    "ECMASCRIPT6",
    "ECMASCRIPT6_STRICT",
    "ECMASCRIPT6_TYPED",
])

JS_PEDANTIC_ARGS = [
    "--jscomp_error=*",
    "--jscomp_warning=deprecated",
    "--jscomp_warning=unnecessaryCasts",
]

JS_HIDE_WARNING_ARGS = [
    "--hide_warnings_for=.soy.js",
    "--hide_warnings_for=external/closure_library/",
    "--hide_warnings_for=external/soyutils_usegoog/",
]

JS_DEPS_ATTR = attr.label_list(
    allow_files=False,
    providers=["js_language",
               "js_exports",
               "js_provided",
               "transitive_js_srcs",
               "transitive_js_externs"])

def collect_js_srcs(ctx):
  srcs = set(order="compile")
  externs = set(order="compile")
  for dep in ctx.attr.deps:
    srcs += dep.js_exports
    srcs += dep.transitive_js_srcs
    externs += dep.transitive_js_externs
  if hasattr(ctx.files, 'srcs'):
    srcs += JS_FILE_TYPE.filter(ctx.files.srcs)
  if hasattr(ctx.files, 'externs'):
    externs += JS_FILE_TYPE.filter(ctx.files.externs)
  return srcs, externs

def determine_js_language(ctx, normalize=False):
  language = "ANY"
  if hasattr(ctx.attr, "language") and not hasattr(ctx.attr, "main"):
    language = _check_js_language(ctx.attr.language)
  for dep in ctx.attr.deps:
    language = _mix_js_languages(ctx, language, dep.js_language)
  if hasattr(ctx.attr, "exports"):
    for dep in ctx.attr.exports:
      language = _mix_js_languages(ctx, language, dep.js_language)
  if normalize and language == "ANY":
    language = JS_LANGUAGE_DEFAULT
  return language

def make_js_deps_runfiles(ctx, srcs):
  ctx.action(
      inputs=list(srcs),
      outputs=[ctx.outputs.runfiles],
      arguments=(["--output_file=%s" % ctx.outputs.runfiles.path] +
                 ["--root_with_prefix=%s %s" % (r, _make_prefix(p))
                  for r, p in _find_roots(
                      [(src.dirname, src.short_path) for src in srcs])]),
      executable=ctx.executable._depswriter,
      progress_message="Calculating %d JavaScript runfile deps to %s" % (
          len(srcs), ctx.outputs.runfiles.short_path))

def is_using_closure_library(srcs):
  return _contains_file(srcs, "external/closure_library/closure/goog/base.js")

# Maps (current, dependent) -> (compatible, is_decay)
_JS_LANGUAGE_COMBINATIONS = {
    ("ECMASCRIPT3", "ECMASCRIPT5"): ("ECMASCRIPT5", False),
    ("ECMASCRIPT3", "ECMASCRIPT5_STRICT"): ("ECMASCRIPT5", False),
    ("ECMASCRIPT3", "ECMASCRIPT6_STRICT"): ("ECMASCRIPT6", False),
    ("ECMASCRIPT5", "ECMASCRIPT3"): ("ECMASCRIPT5", False),
    ("ECMASCRIPT5", "ECMASCRIPT5_STRICT"): ("ECMASCRIPT5", False),
    ("ECMASCRIPT5", "ECMASCRIPT6_STRICT"): ("ECMASCRIPT6", False),
    ("ECMASCRIPT6", "ECMASCRIPT3"): ("ECMASCRIPT6", False),
    ("ECMASCRIPT6", "ECMASCRIPT5"): ("ECMASCRIPT6", False),
    ("ECMASCRIPT6", "ECMASCRIPT5_STRICT"): ("ECMASCRIPT6", False),
    ("ECMASCRIPT6", "ECMASCRIPT6_STRICT"): ("ECMASCRIPT6", False),
    ("ECMASCRIPT5_STRICT", "ECMASCRIPT3"): ("ECMASCRIPT5", True),
    ("ECMASCRIPT5_STRICT", "ECMASCRIPT5"): ("ECMASCRIPT5", True),
    ("ECMASCRIPT5_STRICT", "ECMASCRIPT6_STRICT"): ("ECMASCRIPT6_STRICT", False),
    ("ECMASCRIPT5_STRICT", "ECMASCRIPT6_TYPED"): ("ECMASCRIPT6_TYPED", False),
    ("ECMASCRIPT6_STRICT", "ECMASCRIPT3"): ("ECMASCRIPT6", True),
    ("ECMASCRIPT6_STRICT", "ECMASCRIPT5"): ("ECMASCRIPT6", True),
    ("ECMASCRIPT6_STRICT", "ECMASCRIPT6"): ("ECMASCRIPT6", True),
    ("ECMASCRIPT6_STRICT", "ECMASCRIPT5_STRICT"): ("ECMASCRIPT6_STRICT", False),
    ("ECMASCRIPT6_STRICT", "ECMASCRIPT6_TYPED"): ("ECMASCRIPT6_TYPED", False),
    ("ECMASCRIPT6_TYPED", "ECMASCRIPT5_STRICT"): ("ECMASCRIPT6_TYPED", False),
    ("ECMASCRIPT6_TYPED", "ECMASCRIPT6_STRICT"): ("ECMASCRIPT6_TYPED", False),
}

def _check_js_language(language):
  if language not in JS_LANGUAGES:
    fail("Invalid JS language '%s', expected one of %s" % (
        language, ", ".join(list(JS_LANGUAGES))))
  return language

def _mix_js_languages(ctx, current, dependent):
  if current == dependent:
    return current
  if current == "ANY":
    return dependent
  if dependent == "ANY":
    return current
  if (current, dependent) in _JS_LANGUAGE_COMBINATIONS:
    compatible, is_decay = _JS_LANGUAGE_COMBINATIONS[(current, dependent)]
    if is_decay:
      print(("%s dependency on %s library caused JS language strictness to " +
             "decay from %s to %s") % (
                 ctx.label.name, dependent, current, compatible))
    return compatible
  fail("Can not link an %s library against an %s one." % (dependent, current))

def _find_roots(dirs):
  roots = {}
  for _, d, p in sorted([(len(d.split("/")), d, p) for d, p in dirs]):
    parts = d.split("/")
    want = True
    for i in range(len(parts)):
      if "/".join(parts[:i + 1]) in roots:
        want = False
        break
    if want:
      roots[d] = p
  return roots.items()

def _make_prefix(prefix):
  prefix = "/".join(prefix.split("/")[:-1])
  if not prefix:
    return _CLOSURE_REL
  elif prefix == _CLOSURE_ROOT:
    return "."
  elif prefix.startswith(_CLOSURE_ROOT + "/"):
    return prefix[len(_CLOSURE_ROOT) + 1:]
  else:
    return _CLOSURE_REL + "/" + prefix

def _contains_file(srcs, path):
  for src in srcs:
    if src.short_path == path:
      return True
  return False
