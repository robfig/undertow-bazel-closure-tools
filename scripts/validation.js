goog.module('app.Validation');

exports.Validation = {
  /**
   * @param {string} email to test
   * @return {boolean} if it's a company email
   */
  isCompanyEmail: function(email) {
    return /yext\.com/.test(email);
  }
};
