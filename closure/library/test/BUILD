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

load("//closure/linter:closure_js_lint_test.bzl", "closure_js_lint_test")
load("//closure/testing:closure_js_test.bzl", "closure_js_test")

closure_js_test(
    name = "dom_test",
    srcs = ["dom_test.js"],
    language = "ECMASCRIPT5_STRICT",
    deps = [
        "//closure/library",
        "//closure/library:testing",
    ],
)

closure_js_lint_test(
    name = "lint",
    srcs = ["dom_test.js"],
    visibility = ["//visibility:private"],
)
