java_binary(
    name = "server",
    srcs = glob(["src/**/*.java"]),
    deps = [
        ":io_undertow_undertow_websockets_jsr",
        ":io_undertow_undertow_core",
        ":io_undertow_undertow_servlet",
        ":coffeerun",
    ],
    main_class = "com.robfig.Server",
)

##### 
# From https://github.com/bazelbuild/rules_closure/
#
# load("@io_bazel_rules_closure//closure:defs.bzl", "closure_js_binary")
# load("@io_bazel_rules_closure//closure:defs.bzl", "closure_js_library")
# load("@io_bazel_rules_closure//closure:defs.bzl", "closure_css_binary")
# load("@io_bazel_rules_closure//closure:defs.bzl", "closure_css_library")
#
# closure_js_binary(
#     name = "coffeerun",
#     main = "coffeerun",
#     deps = [":coffeerun_lib"],
# )
#
# closure_js_library(
#     name = "coffeerun_lib",
#     srcs = glob(["scripts/*.js"]),
# #    language = "ECMASCRIPT6_TYPED",
# #    depmode = "ES6MODULES",
#     deps = [
#         "@closure_library//:closure_library",
#         "@closure_templates//:closure_templates_js",
#         ":coffeerun_css",
#         "//templates:coffeerun_soy",
#     ]
# )
#
# closure_css_binary(
#     name = "coffeerun_css_bin",
#     deps = [":coffeerun_css"],
# )
#
# closure_css_library(
#     name = "coffeerun_css",
#     srcs = ["coffeerun.gss"],
#     deps = ["@closure_library//:closure_library_css"],
# )

##### 
# From https://github.com/bazelbuild/bazel/tree/master/tools/build_rules/closure

load("@bazel_tools//tools/build_rules/closure:closure_js_binary.bzl", "closure_js_binary")
load("@bazel_tools//tools/build_rules/closure:closure_js_library.bzl", "closure_js_library")
load("@bazel_tools//tools/build_rules/closure:closure_stylesheet_library.bzl", "closure_stylesheet_library")
load("@bazel_tools//tools/build_rules/closure:closure_template_library.bzl", "closure_template_library")

closure_js_binary(
    name = "coffeerun_js",
    language_in = "es6_typed",
#    externs = ["externs/jquery-1.9.js"],
    main = "app.main",
    deps = [":coffeerun_lib"],
)

closure_js_library(
    name = "coffeerun_lib",
    srcs = glob(["scripts/*.js"]),
    deps = [
        "@closure_library//:closure_library",
        "@closure_templates//:closure_templates_js",
        ":coffeerun_css",
        ":coffeerun_soy",
    ]
)

closure_stylesheet_library(
    name = "coffeerun_css",
    srcs = glob(["styles/*.gss"]),
    deps = ["@closure_library//:closure_library_css"],
)

closure_template_library(
    name = "coffeerun_soy",
    srcs = glob(["templates/*.soy"]),
)


#####
# The below lines were generated from the generate_workspace tool:
#
# bazel run //src/tools/generate_workspace -- \
#     -a io.undertow:undertow-core:1.2.11.Final \
#     -a io.undertow:undertow-servlet:1.2.11.Final \
#     -a io.undertow:undertow-websockets-jsr:1.2.11.Final

# The following dependencies were calculated from:
# io.undertow:undertow-core:1.2.11.Final
# io.undertow:undertow-servlet:1.2.11.Final
# io.undertow:undertow-websockets-jsr:1.2.11.Final


java_library(
    name = "org_jboss_spec_javax_annotation_jboss_annotations_api_1_2_spec",
    visibility = ["//visibility:public"],
    exports = [
        "@org_jboss_spec_javax_annotation_jboss_annotations_api_1_2_spec//jar",
    ],
)

java_library(
    name = "io_undertow_undertow_websockets_jsr",
    visibility = ["//visibility:public"],
    exports = [
        "@io_undertow_undertow_websockets_jsr//jar",
        "@io_undertow_undertow_core//jar",
        "@io_undertow_undertow_servlet//jar",
        "@org_jboss_spec_javax_websocket_jboss_websocket_api_1_1_spec//jar",
    ],
)

java_library(
    name = "org_jboss_xnio_xnio_api",
    visibility = ["//visibility:public"],
    exports = [
        "@org_jboss_xnio_xnio_api//jar",
    ],
)

java_library(
    name = "org_jboss_xnio_xnio_nio",
    visibility = ["//visibility:public"],
    exports = [
        "@org_jboss_xnio_xnio_nio//jar",
    ],
)

java_library(
    name = "io_undertow_undertow_core",
    visibility = ["//visibility:public"],
    exports = [
        "@io_undertow_undertow_core//jar",
        "@org_jboss_logging_jboss_logging//jar",
        "@org_jboss_xnio_xnio_api//jar",
        "@org_jboss_xnio_xnio_nio//jar",
    ],
)

java_library(
    name = "org_jboss_spec_javax_websocket_jboss_websocket_api_1_1_spec",
    visibility = ["//visibility:public"],
    exports = [
        "@org_jboss_spec_javax_websocket_jboss_websocket_api_1_1_spec//jar",
    ],
)

java_library(
    name = "org_jboss_logging_jboss_logging",
    visibility = ["//visibility:public"],
    exports = [
        "@org_jboss_logging_jboss_logging//jar",
    ],
)

java_library(
    name = "io_undertow_undertow_servlet",
    visibility = ["//visibility:public"],
    exports = [
        "@io_undertow_undertow_servlet//jar",
        "@io_undertow_undertow_core//jar",
        "@org_jboss_spec_javax_annotation_jboss_annotations_api_1_2_spec//jar",
        "@org_jboss_spec_javax_servlet_jboss_servlet_api_3_1_spec//jar",
    ],
)

java_library(
    name = "org_jboss_spec_javax_servlet_jboss_servlet_api_3_1_spec",
    visibility = ["//visibility:public"],
    exports = [
        "@org_jboss_spec_javax_servlet_jboss_servlet_api_3_1_spec//jar",
    ],
)
