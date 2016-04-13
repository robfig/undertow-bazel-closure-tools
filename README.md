## Initial setup log

### Bootstrap the BUILD / WORKSPACE

Like most Java libraries, Undertow supplies Maven artifacts. I converted that to
Bazel using the [generate_workspace command](http://bazel.io/docs/external.html):

 bazel run //src/tools/generate_workspace -- \
     -a io.undertow:undertow-core:1.2.11.Final \
     -a io.undertow:undertow-servlet:1.2.11.Final \
     -a io.undertow:undertow-websockets-jsr:1.2.11.Final


This didn't quite work for me (it's at 0.0.1)
https://github.com/bazelbuild/rules_closure/
