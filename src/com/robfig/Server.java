package com.robfig;

import io.undertow.*;
import io.undertow.server.*;
import io.undertow.util.*;

/**
 * Simple server to demonstrate closure tool stack.
 *
 * @author Rob Figueiredo (robfig@yext.com)
 */
public class Server {
    public static void main(final String[] args) {
        Undertow server = Undertow.builder()
                .addHttpListener(8080, "localhost")
                .setHandler(new HttpHandler() {
                    @Override
                    public void handleRequest(final HttpServerExchange exchange) throws Exception {
                        exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain");
                        exchange.getResponseSender().send("Hello World");
                    }
                }).build();
        server.start();
    }    
}

