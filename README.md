This is a simple demo application that demonstrates the following stack working
together:

- Built with [Bazel](http://bazel.io) (0.2.2)
- Served with [Undertow](http://undertow.io/) (Java web server)
- Javascript compiled with Closure Compiler in **ADVANCED** mode built using the
  [Closure rules](https://github.com/bazelbuild/rules_closure/)
- Dependencies specified using ES6-style modules (`goog.require`, `goog.module`,
  `goog.defineClass`)
- [Closure templates](https://developers.google.com/closure/templates/), on the
  server (Java) and the client (compiled to Javascript)
- CSS built with
  [Closure Stylesheets](https://github.com/google/closure-stylesheets),
  minified and using class renaming

## Setting up a new project

These were a couple steps I had to take to get everything working.

### Bootstrap the BUILD / WORKSPACE

Like most Java libraries, Undertow supplies Maven artifacts. I converted that to
Bazel using the [generate_workspace command](http://bazel.io/docs/external.html):

	bazel run //src/tools/generate_workspace -- \
	     -a io.undertow:undertow-core:1.2.11.Final \
	     -a io.undertow:undertow-servlet:1.2.11.Final \
	     -a io.undertow:undertow-websockets-jsr:1.2.11.Final

Copy the resulting WORKSPACE and BUILD files into your project.
