goog.module('app.Validation');

exports.Validation = {
  isCompanyEmail: function(email) {
    return /yext\.com/.test(email);
  }
};
