goog.module('app.Truck');

exports = goog.defineClass({
  constructor: function(truckId, db) {
    this.truckId = truckId;
    this.db = db;
  },

  createOrder: function(order) {
    console.log('Adding order for ' + order.email);
    this.db.add(order.email, order);
  },

  deliverOrder: function(customerId) {
    console.log('Delivering order for ' + customerId);
    this.db.remove(customerId);
  },

  printOrders: function() {
    var customerIdArray = Object.keys(this.db.getAll());
    console.log('Truck #' + this.truckId + ' has pending orders:');
    customerIdArray.forEach(function(id) {
      console.log(this.db.get(id));
    }.bind(this));
  },
});
