goog.module('app.FormHandler');

var formData = function(form) {
  return {
    coffee: form.elements.coffee.value,
    email: form.elements.emailAddress.value,
    size: form.elements.size.value,
    flavor: form.elements.flavor.value,
    strength: form.elements.strength.value
  };
};

exports = goog.defineClass({
  constructor: function(selector) {
    if (!selector) {
      throw new Error('No selector provided');
    }
    this.$formElement = $(selector);
    if (this.$formElement.length === 0) {
      throw new Error('Could not find element with selector: ' + selector);
    }
    this.submitHandlers = [];
    this.bindSlider();
    this.bindSubmitHandler();
  },

  bindSubmitHandler: function() {
    var self = this;
    this.$formElement.on('submit', function(event) {
      console.log(event);
      event.preventDefault();
      var data = formData(this);
      console.log(data);
      for (var i = 0; i < self.submitHandlers.length; i++) {
        self.submitHandlers[i](data);
      }
      this.reset();
      this.elements[0].focus();
    });
  },

  addSubmitHandler: function(fn) {
    this.submitHandlers.push(fn);
  },

  addInputHandler: function(fn) {
    console.log('Setting input handler for form');
    this.$formElement.on('input', '[name="emailAddress"]', function(event) {
      var emailAddress = event.target.value;
      if (fn(emailAddress)) {
        event.target.setCustomValidity('');
      } else {
        event.target.setCustomValidity(emailAddress + ' is not an authorized email address!');
      }
    });
  },

  bindSlider: function() {
    var $reading = this.$formElement.find('.js-coffee-strength');
    if (!$reading) {
      throw new Error('No coffee reading');
    }
    this.$formElement.on('input', '[name=strength]', function(event) {
      $reading.text(this.value);
    });
  }

});
