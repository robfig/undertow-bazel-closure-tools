package com.robfig;

import com.google.common.io.Resources;

import com.google.template.soy.*;
import com.google.template.soy.tofu.*;

import io.undertow.*;
import io.undertow.server.*;
import io.undertow.server.handlers.resource.*;
import io.undertow.util.*;

import static io.undertow.Handlers.path;
import static io.undertow.Handlers.resource;

/**
 * Simple server to demonstrate closure tool stack.
 *
 * @author Rob Figueiredo (robfig@yext.com)
 */
public class Server {
    public static void main(final String[] args) {
        SoyTofu tofu = new SoyFileSet.Builder()
            .add(Resources.getResource("templates/index.soy"))
            .build()
            .compileToTofu();
        Undertow server = Undertow.builder()
            .addHttpListener(8080, "localhost")
            .setHandler(
                path()
                .addPrefixPath("/public/", resource(new ClassPathResourceManager(Server.class.getClassLoader())))
                .addPrefixPath("/", new HttpHandler() {
                    @Override
                    public void handleRequest(final HttpServerExchange exchange) throws Exception {
                        String html = tofu.newRenderer("coffeerun.main")
                            .render();
                        exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/html");
                        exchange.getResponseSender().send(html);
                    }
                })).build();
        server.start();
    }    
}

