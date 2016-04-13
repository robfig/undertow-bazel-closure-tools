java_binary(
    name = "server",
    srcs = glob(["src/**/*.java"]),
    deps = [
        ":io_undertow_undertow_websockets_jsr",
        ":io_undertow_undertow_core",
        ":io_undertow_undertow_servlet",
    ],
    main_class = "com.robfig.Server",
)


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
