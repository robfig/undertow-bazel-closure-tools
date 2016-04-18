package(default_visibility = ["//visibility:public"])

load("//closure/compiler:closure_js_library.bzl", "closure_js_library")
load("//closure/linter:closure_js_lint_test.bzl", "closure_js_lint_test")
load("//closure/testing:closure_js_check_test.bzl", "closure_js_check_test")

exports_files(["phantomjs_runner.js"])

closure_js_library(
    name = "phantomjs_jsunit_runner_lib",
    testonly = True,
    srcs = ["phantomjs_jsunit_runner.js"],
    language = "ECMASCRIPT5_STRICT",
    deps = [
        "//closure/library",
        "//closure/library:testing",
    ],
)

closure_js_library(
    name = "phantomjs_runner_lib",
    testonly = True,
    srcs = ["phantomjs_runner.js"],
    language = "ECMASCRIPT5_STRICT",
    visibility = ["//visibility:private"],
    deps = ["//closure/testing/externs:phantom_lib"],
)

closure_js_check_test(
    name = "phantomjs_jsunit_runner_check",
    pedantic = True,
    visibility = ["//visibility:private"],
    deps = [":phantomjs_jsunit_runner_lib"],
)

closure_js_check_test(
    name = "phantomjs_runner_check",
    pedantic = True,
    visibility = ["//visibility:private"],
    deps = [":phantomjs_runner_lib"],
)

closure_js_lint_test(
    name = "lint",
    srcs = [
        "phantomjs_jsunit_runner.js",
        "phantomjs_runner.js",
    ],
    visibility = ["//visibility:private"],
)
