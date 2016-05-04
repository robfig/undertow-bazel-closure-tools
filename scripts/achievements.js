goog.module('app.Achievements');

exports = goog.defineClass(null, {
  constructor: function(modalSelector) {
    this.winners = {};
    this.$modal = $(modalSelector);
    if (!this.$modal) {
      throw new Error('Modal not found');
    }
  },

  checkEligibility: function(data) {
    console.log('check eligibility');
    var winner = data.size == 'grande' &&
      data.flavor != '' &&
      data.strength == 100;
    if (winner) {
      console.log('winner!');
      this.recordWinner(data.email);
      this.congratulate();
    } else {
      console.log('not a winner');
    }
  },

  unlockPowerup: function(data) {
    if (data.email in this.winners) {
      console.log('show powerup');
    } else {
      console.log('hide powerup');
    }
  },

  recordWinner: function(email) {
    this.winners[email] = 1;
  },

  congratulate: function() {
    console.log('open modal');
    this.$modal.modal('show');
  }
});
