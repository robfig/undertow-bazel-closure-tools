(function (window) {
  'use strict';
  var App = window.App || {};
  function RemoteDataStore(url) {
    if (!url) {
      throw new Error('No remote URL supplied.');
    }
    this.serverUrl = url;
  }
  App.RemoteDataStore = RemoteDataStore;
  window.App = App;
})(window);
