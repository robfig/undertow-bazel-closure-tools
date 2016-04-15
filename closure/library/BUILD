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

package(default_visibility = ["//visibility:public"])

load("//closure/compiler:closure_js_library.bzl", "closure_js_library")
load("//closure/stylesheets:closure_css_library.bzl", "closure_css_library")

closure_js_library(
    name = "library",
    srcs = ["@closure_library//:js_files"],
    language = "ECMASCRIPT5_STRICT",
    deps = [":base"],
)

closure_js_library(
    name = "testing",
    testonly = True,
    srcs = ["@closure_library//:js_testing_files"],
    language = "ECMASCRIPT5_STRICT",
    deps = [":library"],
)

closure_css_library(
    name = "css",
    srcs = ["@closure_library//:css_files"],
)

# This file doesn't goog.provide() any namespaces, so it won't break strict
# dependency checking if you only link against :library, which is recommended
# for Closure Library users. This target exists so it can be added as a
# lightweight dependency when source code uses things like ES6 modules. This is
# because the Closure Compiler generates synthetic code with goog.provide()
# statements.
closure_js_library(
    name = "base",
    srcs = ["@closure_library//:closure/goog/base.js"],
    language = "ECMASCRIPT5_STRICT",
)
