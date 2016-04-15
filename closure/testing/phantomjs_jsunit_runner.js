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
 * @fileoverview PhantomJS test runner in-browser code. This file loads Closure
 *     testing libraries and then polls for test completion and then sends a
 *     message to PhantomJS letting it know it can exit.
 */

goog.require('goog.testing.asserts');
goog.require('goog.testing.jsunit');


(function() {
  window.setInterval(function() {
    if (window['G_testRunner'].isFinished()) {
      window['callPhantom'](window['G_testRunner'].isSuccess());
    }
  }, 200);
})();
