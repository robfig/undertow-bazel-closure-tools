goog.module("app");

exports.main = function(window) {
  var FORM_SELECTOR = '[data-coffee-order="form"]';
  var ACHIEVEMENTS_SELECTOR = '[data-coffee-order="form"]';
  var MODAL_SELECTOR = '#myModal';
  var CHECKLIST_SELECTOR = '[data-coffee-order="checklist"]';
  var SERVER_URL = 'http://coffeerun201509.herokuapp.com/api/coffeeorders';

  var App = window.App;
  var Truck = App.Truck;
  var DataStore = App.DataStore;
  var FormHandler = App.FormHandler;
  var Achievements = App.Achievements;
  var CheckList = App.CheckList;
  var Validation = App.Validation;

  var myTruck = new Truck('ncc-1701', new DataStore());
  window.myTruck = myTruck;

  var checkList = new CheckList(CHECKLIST_SELECTOR);
  checkList.addClickHandler(myTruck.deliverOrder.bind(myTruck));

  var formHandler = new FormHandler(FORM_SELECTOR);
  formHandler.addSubmitHandler(myTruck.createOrder.bind(myTruck));
  formHandler.addSubmitHandler(checkList.addRow.bind(checkList));

  var achievements = new Achievements(MODAL_SELECTOR);
  formHandler.addSubmitHandler(achievements.checkEligibility.bind(achievements));

  formHandler.addInputHandler(Validation.isCompanyEmail);
};

goog.exportSymbol('app.main', exports.main);
