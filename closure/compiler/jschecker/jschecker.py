#!/usr/bin/python2
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

"""Sanity checker for closure_js_library() targets.

This script enforces many of the correctness guarantees promised in the
README.md file.

For starters, this script enforces that all `closure_js_library()` targets
conform to "strict dependencies." It does this by inspecting the `srcs` in each
target to verify that all `goog.require()` statements are provided by the
`srcs` in the libraries specified in `deps`. It does not perform this check
transitively, i.e. it only scans one level deep. However there is one exception
to this rule. If one of those dependent libraries uses the `exports` attribute,
then we treat whatever is listed there as a direct dependency.

This whole process happens incrementally. We do this by having each library
rule generate a text file containing the list of things it provides. This
way parent rules don't have to re-scan those sources.

We also do other little things, like checking to make sure `srcs` don't have
`@externs` comments. We also try to spot some obvious errors, like if
goog.testOnly() is in a library without testonly = True, or if CommonJS or ES6
module directives are being used when the `depmode = "CLOSURE"`.

"""

import codecs
import optparse
import os
import re
import sys

from external.closure_library.closure.bin.build import source
from external.closure_library.closure.bin.build import treescan


def _get_options_parser():
  parser = optparse.OptionParser(__doc__)
  parser.add_option('--output_file',
                    dest='output_file',
                    action='store',
                    help='Incremental -provides.txt report output filename.')
  parser.add_option('--src',
                    dest='srcs',
                    default=[],
                    action='append',
                    help=('A .js file specified under srcs. This flag may be '
                          'specified multiple times.'))
  parser.add_option('--extern',
                    dest='externs',
                    default=[],
                    action='append',
                    help=('A .js file specified under externs. This flag may '
                          'be specified multiple times.'))
  parser.add_option('--dep',
                    dest='deps',
                    default=[],
                    action='append',
                    help=('A -provides.txt file from a deps target. This flag '
                          'may be specified multiple times.'))
  parser.add_option('--label',
                    dest='label',
                    action='store',
                    help='Name of rule being compiled.')
  parser.add_option('--testonly',
                    dest='testonly',
                    action='store_true',
                    help='Indicates a testonly rule is being compiled.')
  return parser


def _trim_results(results, count=20):
  results = list(results)
  results.sort()
  if len(results) > count:
    cut = '[%d results omitted]' % (len(results) - count)
    results = results[:count] + [cut]
  return results


def main():
  options, args = _get_options_parser().parse_args()
  if args:
    raise Exception('No arguments expected')
  required_by = {}
  provides = set()
  requires = set()
  evil_test_files = set()
  for src in options.srcs:
    content = source.GetFileContents(src)
    if not options.testonly and 'goog.setTestOnly(' in content:
      evil_test_files.add(src)
    sauce = source.Source(content)
    provides.update(sauce.provides)
    requires.update(sauce.requires)
    for require in sauce.requires:
      if require not in required_by:
        required_by[require] = set()
      required_by[require].add(src)
  if evil_test_files:
    sys.stderr.write(
        ('\n'
         '\033[31;1mJavaScript sanity checking failed D:\033[0m\n'
         '\n'
         'These source files contain goog.setTestOnly():\n'
         '\n'
         '\t%s\n'
         '\n'
         'But \033[35;1m%s\033[0m does not have `testonly = True`.\n'
         '\n') % ('\n\t'.join(_trim_results(evil_test_files)),
                  options.label))
    sys.exit(1)
  provided = set()
  for dep in options.deps:
    provided.update(source.GetFileContents(dep).split())
  missing = requires - provides - provided
  if missing:
    files = set()
    for require in missing:
      files.update(required_by[require])
      sys.stderr.write(
        ('\n'
         '\033[31;1mJavaScript strict dependency checking failed D:\033[0m\n'
         '\n'
         'These namespaces were required by \033[35;1m%s\033[0m\n'
         '\n'
         '\t%s\n'
         '\n'
         'In the following files:\n'
         '\n'
         '\t%s\n'
         '\n'
         'But none of the JavaScript libraries listed in `deps` have `srcs`\n'
         'that provide these namepaces. Please note that we only check one\n'
         'level down; we do not check transitive dependencies; this is by\n'
         'design. Please update your `deps` to include a direct reference to\n'
         'whatever library target provides these namespaces.\n'
         '\n') % (options.label,
                  '\n\t'.join(_trim_results(missing)),
                  '\n\t'.join(_trim_results(files))))
    sys.exit(1)
  with codecs.open(options.output_file, 'w', encoding='utf-8') as f:
    f.write('\n'.join(sorted(provides)))
    if provides:
      f.write('\n')


if __name__ == '__main__':
  main()
