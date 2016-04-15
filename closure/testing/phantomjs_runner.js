// Copyright 2016 The Bazel Authors. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * @fileoverview PhantomJS headless browser container for Closure unit tests.
 *     This program runs inside PhantomJS but not inside the browser itself. It
 *     starts an HTTP server that serves runfiles. It loads the generated test
 *     runner HTML file inside an ethereal browser. Once the page is loaded,
 *     this program communicates with the page to collect log data and monitor
 *     whether or not the tests succeeded.
 */

'use strict';

var /** !phantomjs.WebPage */ webpage = require('webpage');
var /** !phantomjs.FileSystem */ fs = require('fs');
var /** !phantomjs.WebServer */ webserver = require('webserver');
var /** !phantomjs.System */ system = require('system');


/**
 * Location of virtual test page.
 * @type {string}
 * @const
 */
var VIRTUAL_PAGE = '/index.html';


/**
 * Path under which runfiles are served.
 * @type {string}
 * @const
 */
var RUNFILES_PREFIX = '/filez/';


/**
 * Full URL of virtual page.
 * @type {string}
 */
var url;


/**
 * HTML for virtual test page, hosted under {@code index.html}.
 * @type {string}
 */
var virtualPageHtml;


/**
 * Path of JS file to load.
 * @type {string}
 */
var js;


/**
 * PhantomJS page object.
 * @type {!phantomjs.Page}
 */
var page = webpage.create();


/**
 * Guesses Content-Type header for {@code path}
 * @param {string} path
 * @return {string}
 */
function guessContentType(path) {
  switch (path.substr(path.lastIndexOf('.') + 1)) {
    case 'js':
      return 'application/javascript;charset=utf-8';
    case 'html':
      return 'text/html;charset=utf-8';
    case 'css':
      return 'text/css;charset=utf-8';
    case 'txt':
      return 'text/plain;charset=utf-8';
    case 'xml':
      return 'application/xml;charset=utf-8';
    case 'gif':
      return 'image/gif';
    case 'png':
      return 'image/png';
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    default:
      return 'application/octet-stream';
  }
}


/**
 * Handles request from web browser.
 * @param {!phantomjs.Server.Request} request
 * @param {!phantomjs.Server.Response} response
 */
function onRequest(request, response) {
  var path = request.url;
  system.stderr.writeLine('Serving ' + path);
  if (path == VIRTUAL_PAGE) {
    response.writeHead(200, {
      'Cache': 'no-cache',
      'Content-Type': 'text/html;charset=utf-8'
    });
    response.write(virtualPageHtml);
    response.closeGracefully();
  } else if (path.indexOf(RUNFILES_PREFIX) == 0) {
    path = path.substr(RUNFILES_PREFIX.length);
    if (!fs.exists(path)) {
      send404(request, response);
      return;
    }
    var contentType = guessContentType(path);
    if (contentType.indexOf('charset') != -1) {
      response.setEncoding('binary');
    }
    response.writeHead(200, {
      'Cache': 'no-cache',
      'Content-Type': contentType
    });
    response.write(fs.read(path));
    response.closeGracefully();
  } else {
    send404(request, response);
  }
}


/**
 * Sends a 404 Not Found response.
 * @param {!phantomjs.Server.Request} request
 * @param {!phantomjs.Server.Response} response
 */
function send404(request, response) {
  system.stderr.writeLine('NOT FOUND ' + request.url);
  response.writeHead(404, {
    'Cache': 'no-cache',
    'Content-Type': 'text/plain;charset=utf-8'
  });
  response.write('Not Found');
  response.closeGracefully();
}


/**
 * Extracts text from inside page.
 * @return {string}
 */
function extractText() {
  var element = document.getElementById('blah');
  if (element != null) {
    return element.innerText;
  } else {
    return '';
  }
}


/**
 * Callback when log entries are emitted inside the browser.
 * @param {string} message
 * @param {?string} line
 * @param {?string} source
 */
function onConsoleMessage(message, line, source) {
  message = message.replace(/\r?\n/, '\n-> ');
  if (line && source) {
    system.stderr.writeLine('-> ' + source + ':' + line + '] ' + message);
  } else {
    system.stderr.writeLine('-> ' + message);
  }
}


/**
 * Callback when headless web page is loaded.
 * @param {string} status
 */
function onLoadFinished(status) {
  if (status != 'success') {
    system.stderr.writeLine('Load Failed');
    phantom.exit(1);
    return;
  }
}


/**
 * Callback when webpage shows an alert dialog.
 * @param {string} message
 */
function onAlert(message) {
  system.stderr.writeLine('Alert: ' + message);
}


/**
 * Callback when headless web page throws an error.
 * @param {string} message
 * @param {!Array<{file: string,
 *                 line: number,
 *                 function: string}>} trace
 */
function onError(message, trace) {
  system.stderr.writeLine(message);
  trace.forEach(function(t) {
    var msg = '> ';
    if (t.function != '') {
      msg += t.function + ' at ';
    }
    msg += t.file + ':' + t.line;
    system.stderr.writeLine(msg);
  });
  page.close();
  phantom.exit(1);
}


/**
 * Callback when JavaScript inside page sends us a message.
 * @param {boolean} succeeded
 */
function onCallback(succeeded) {
  page.close();
  if (succeeded) {
    phantom.exit();
  } else {
    phantom.exit(1);
  }
}


/**
 * Runs a single pending test.
 */
function run() {
  virtualPageHtml =
      '<!doctype html>\n' +
      '<meta charset="utf-8">' +
      '<body>\n' +
      '</body>\n' +
      // These definitions are only necessary because we're compiling in
      // WHITESPACE_ONLY mode.
      '<script>\n' +
      '  var CLOSURE_NO_DEPS = true;\n' +
      '  var CLOSURE_UNCOMPILED_DEFINES = {\n' +
      '    "goog.ENABLE_DEBUG_LOADER": false\n' +
      '  };\n' +
      '</script>\n' +
      '<script src="' + RUNFILES_PREFIX + js + '"></script>\n';
  page.onAlert = onAlert;
  page.onCallback = onCallback;
  page.onConsoleMessage = onConsoleMessage;
  page.onError = onError;
  page.onLoadFinished = onLoadFinished;
  // XXX: If PhantomJS croaks, fail sooner rather than later.
  //      https://github.com/ariya/phantomjs/issues/10652
  page.settings.resourceTimeout = 2000;
  page.open(url);
}


(function() {
  js = system.args[1];
  var port = Math.floor(Math.random() * (60000 - 32768)) + 32768;
  var server = webserver.create();
  server.listen(port, onRequest);
  url = 'http://localhost:' + port + VIRTUAL_PAGE;
  system.stderr.writeLine('Listening ' + url);
  run();
})();
