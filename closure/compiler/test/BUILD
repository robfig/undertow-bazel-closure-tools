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

load("//closure/compiler:closure_js_binary.bzl", "closure_js_binary")
load("//closure/compiler:closure_js_deps.bzl", "closure_js_deps")
load("//closure/compiler:closure_js_library.bzl", "closure_js_library")
load("//closure/private:test_rules.bzl", "file_test")

closure_js_library(
    name = "hello_lib",
    srcs = ["hello.js"],
    language = "ECMASCRIPT6_STRICT",
)

closure_js_binary(
    name = "hello_bin",
    language = "ECMASCRIPT3",
    deps = [":hello_lib"],
)

file_test(
    name = "minification",
    content = "console.log(\"hello world\");\n",
    file = "hello_bin.js",
)

file_test(
    name = "sourcemap_doesntContainWeirdBazelDirectories",
    content = ("{\n" +
               "\"version\":3,\n" +
               "\"file\":\"/closure/compiler/test/hello_bin.js\",\n" +
               "\"lineCount\":1,\n" +
               "\"mappings\":\"AAgBAA,OAAAC,IAAA,CAAgB,aAAhB;\",\n" +
               "\"sources\":[\"/closure/compiler/test/hello.js\"],\n" +
               "\"names\":[\"console\",\"log\"]\n" +
               "}\n"),
    file = "hello_bin.js.map",
)

closure_js_binary(
    name = "hello_es5strict_bin",
    language = "ECMASCRIPT5_STRICT",
    deps = [":hello_lib"],
)

file_test(
    name = "strictOutputLanguage_addsUseStrict",
    content = "'use strict';console.log(\"hello world\");\n",
    file = "hello_es5strict_bin.js",
)

closure_js_library(
    name = "unstrict_lib",
    srcs = ["empty.js"],
    language = "ECMASCRIPT3",
)

closure_js_library(
    name = "hello_decay_lib",
    srcs = ["hello.js"],
    language = "ECMASCRIPT6_STRICT",
    deps = [":unstrict_lib"],
)

closure_js_binary(
    name = "hello_decay_bin",
    deps = [":hello_decay_lib"],
)

file_test(
    name = "es6strictWithEs3Dep_isAllowed",
    content = "console.log(\"hello world\");\n",
    file = "hello_decay_bin.js",
)

closure_js_library(
    name = "es6const_lib",
    srcs = ["es6const.js"],
    language = "ECMASCRIPT6_STRICT",
)

closure_js_binary(
    name = "es6const_bin",
    compilation_level = "WHITESPACE_ONLY",
    language = "ECMASCRIPT5",
    deps = [":es6const_lib"],
)

file_test(
    name = "es6WithConstKeyword_getsRemoved",
    content = "var hello=\"hello world\";console.log(hello);\n",
    file = "es6const_bin.js",
)

closure_js_library(
    name = "es6arrow_lib",
    srcs = ["es6arrow.js"],
    language = "ECMASCRIPT6_STRICT",
)

closure_js_binary(
    name = "es6arrow_bin",
    compilation_level = "WHITESPACE_ONLY",
    language = "ECMASCRIPT5",
    deps = [":es6arrow_lib"],
)

file_test(
    name = "es6WithArrowFunction_getsExpanded",
    content = "var hello=function(e){return e+\" world\"};console.log(hello(\"hello\"));\n",
    file = "es6arrow_bin.js",
)

closure_js_library(
    name = "es6typed_lib",
    srcs = ["es6typed.js"],
    language = "ECMASCRIPT6_TYPED",
)

closure_js_binary(
    name = "es6typed_bin",
    compilation_level = "WHITESPACE_ONLY",
    language = "ECMASCRIPT3",
    deps = [":es6typed_lib"],
)

file_test(
    name = "es6typed_works",
    content = "var hello=\"hello world\";console.log(hello);\n",
    file = "es6typed_bin.js",
)
