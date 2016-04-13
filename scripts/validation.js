(function (window) {
    'use strict';
    var App = window.App || {};
    var $ = window.jQuery;

    var Validation = {
      isCompanyEmail: function(email) {
        return /yext\.com/.test(email);
      }
    }

    App.Validation = Validation;
    window.App = App;
  })(window);
