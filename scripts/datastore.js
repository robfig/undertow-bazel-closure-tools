goog.module('app.DataStore');

exports = goog.defineClass({
  constructor: function() {
    console.log('running');
    this.data = {};
  },

  add: function(key, val) {
    this.data[key] = val;
  },

  get: function(key) {
    return this.data[key];
  },

  getAll: function() {
    return this.data;
  },

  remove: function(key) {
    delete this.data[key];
  }
});
