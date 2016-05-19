java_binary(
    name = "server",
    srcs = glob(["src/**/*.java"]),
    deps = [
        ":com_google_guava_guava",
        ":com_google_template_soy",
        ":io_undertow_undertow_websockets_jsr",
        ":io_undertow_undertow_core",
        ":io_undertow_undertow_servlet",
    ],
    resources = [
        ":coffeerun_bin",
        ":coffeerun_css_bin",
        "templates/index.soy",
    ],
    main_class = "com.robfig.Server",
)

##### 
# From https://github.com/bazelbuild/rules_closure/
#

load("@io_bazel_rules_closure//closure:defs.bzl", "closure_js_binary")
load("@io_bazel_rules_closure//closure:defs.bzl", "closure_js_library")
load("@io_bazel_rules_closure//closure:defs.bzl", "closure_css_binary")
load("@io_bazel_rules_closure//closure:defs.bzl", "closure_css_library")
load("@io_bazel_rules_closure//closure:defs.bzl", "closure_template_js_library")
load("@io_bazel_rules_closure//closure:defs.bzl", "closure_template_java_library")

closure_js_binary(
    name = "coffeerun_bin",
    entry_points = ["goog:app"],
    css = ":coffeerun_css_bin",
    formatting="PRETTY_PRINT",
    compilation_level="ADVANCED",
    debug=False,
    deps = [":coffeerun_lib"],
)

closure_js_library(
    name = "coffeerun_lib",
    srcs = glob(["scripts/*.js"]),
    language = "ECMASCRIPT5",
    deps = [
        "@io_bazel_rules_closure//closure/library",
        ":coffeerun_soy",
        ":jquery",
    ]
)

closure_js_library(
    name = "jquery",
    externs = ["externs/jquery-1.9.js"],
)

closure_css_binary(
    name = "coffeerun_css_bin",
    deps = [":coffeerun_css"],
    renaming = 1,
)

closure_css_library(
    name = "coffeerun_css",
    srcs = ["styles/coffeerun.gss"],
)

closure_template_js_library(
    name = "coffeerun_soy",
    srcs = glob(["templates/js.soy"]),
)

closure_template_java_library(
    name = "coffeerun_soy_java",
    srcs = ["templates/index.soy"], 
    java_package = "com.robfig",
)

# The following dependencies were calculated from:
# com.google.guava:guava:19.0

java_library(
    name = "com_google_guava_guava",
    visibility = ["//visibility:public"],
    exports = [
        "@com_google_guava_guava//jar",
    ],
)

# The following dependencies were calculated from:
# com.google.template:soy:2016-01-12

java_library(
    name = "com_google_code_findbugs_jsr305",
    visibility = ["//visibility:public"],
    exports = [
        "@com_google_code_findbugs_jsr305//jar",
    ],
)

java_library(
    name = "aopalliance_aopalliance",
    visibility = ["//visibility:public"],
    exports = [
        "@aopalliance_aopalliance//jar",
    ],
)

java_library(
    name = "org_ow2_asm_asm_util",
    visibility = ["//visibility:public"],
    exports = [
        "@org_ow2_asm_asm_util//jar",
        "@org_ow2_asm_asm_tree//jar",
    ],
)

java_library(
    name = "org_sonatype_sisu_inject_cglib",
    visibility = ["//visibility:public"],
    exports = [
        "@org_sonatype_sisu_inject_cglib//jar",
        "@asm_asm//jar",
    ],
)

java_library(
    name = "com_google_template_soy",
    visibility = ["//visibility:public"],
    exports = [
        "@com_google_template_soy//jar",
        "@aopalliance_aopalliance//jar",
        "@args4j_args4j//jar",
        "@asm_asm//jar",
        "@com_google_code_findbugs_jsr305//jar",
        "@com_google_guava_guava//jar",
        "@com_google_inject_extensions_guice_assistedinject//jar",
        "@com_google_inject_extensions_guice_multibindings//jar",
        "@com_google_inject_guice//jar",
        "@com_ibm_icu_icu4j//jar",
        "@javax_inject_javax_inject//jar",
        "@org_ow2_asm_asm//jar",
        "@org_ow2_asm_asm_analysis//jar",
        "@org_ow2_asm_asm_commons//jar",
        "@org_ow2_asm_asm_tree//jar",
        "@org_ow2_asm_asm_util//jar",
        "@org_sonatype_sisu_inject_cglib//jar",
    ],
)

java_library(
    name = "javax_inject_javax_inject",
    visibility = ["//visibility:public"],
    exports = [
        "@javax_inject_javax_inject//jar",
    ],
)

java_library(
    name = "org_ow2_asm_asm",
    visibility = ["//visibility:public"],
    exports = [
        "@org_ow2_asm_asm//jar",
    ],
)

java_library(
    name = "args4j_args4j",
    visibility = ["//visibility:public"],
    exports = [
        "@args4j_args4j//jar",
    ],
)

java_library(
    name = "org_ow2_asm_asm_tree",
    visibility = ["//visibility:public"],
    exports = [
        "@org_ow2_asm_asm_tree//jar",
        "@org_ow2_asm_asm//jar",
    ],
)

java_library(
    name = "org_ow2_asm_asm_commons",
    visibility = ["//visibility:public"],
    exports = [
        "@org_ow2_asm_asm_commons//jar",
        "@org_ow2_asm_asm//jar",
        "@org_ow2_asm_asm_tree//jar",
    ],
)

java_library(
    name = "asm_asm",
    visibility = ["//visibility:public"],
    exports = [
        "@asm_asm//jar",
    ],
)

java_library(
    name = "org_ow2_asm_asm_analysis",
    visibility = ["//visibility:public"],
    exports = [
        "@org_ow2_asm_asm_analysis//jar",
        "@org_ow2_asm_asm_tree//jar",
    ],
)

java_library(
    name = "com_google_inject_extensions_guice_assistedinject",
    visibility = ["//visibility:public"],
    exports = [
        "@com_google_inject_extensions_guice_assistedinject//jar",
        "@com_google_inject_guice//jar",
    ],
)

java_library(
    name = "com_google_inject_extensions_guice_multibindings",
    visibility = ["//visibility:public"],
    exports = [
        "@com_google_inject_extensions_guice_multibindings//jar",
        "@com_google_inject_guice//jar",
    ],
)

java_library(
    name = "com_google_inject_guice",
    visibility = ["//visibility:public"],
    exports = [
        "@com_google_inject_guice//jar",
        "@aopalliance_aopalliance//jar",
        "@asm_asm//jar",
        "@javax_inject_javax_inject//jar",
        "@org_sonatype_sisu_inject_cglib//jar",
    ],
)

java_library(
    name = "com_ibm_icu_icu4j",
    visibility = ["//visibility:public"],
    exports = [
        "@com_ibm_icu_icu4j//jar",
    ],
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
