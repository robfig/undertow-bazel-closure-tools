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

java_binary(
    name = "stylesheets",
    jvm_flags = ["-client"],
    main_class = "com.google.common.css.compiler.commandline.ClosureCommandLineCompiler",
    runtime_deps = [
        "@args4j//jar",
        "@bazel_tools//third_party:gson",
        "@bazel_tools//third_party:guava",
        "@bazel_tools//third_party:jsr305",
        "@closure_stylesheets//jar",
    ],
)
