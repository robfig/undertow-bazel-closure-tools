goog.module("app");

var Achievements = goog.require('app.Achievements');
var CheckList = goog.require('app.CheckList');
var DataStore = goog.require('app.DataStore');
var FormHandler = goog.require('app.FormHandler');
var Truck = goog.require('app.Truck');
var Validation = goog.require('app.Validation');

var soy = goog.require('soy');

var tmpl = goog.require('coffeerun.js');

/** main */
var main = function() {
  var FORM_SELECTOR = '[data-coffee-order="form"]';
  var ACHIEVEMENTS_SELECTOR = '[data-coffee-order="form"]';
  var MODAL_SELECTOR = '#myModal';
  var CHECKLIST_SELECTOR = '[data-coffee-order="checklist"]';
  var SERVER_URL = 'http://coffeerun201509.herokuapp.com/api/coffeeorders';

  console.log('css class: ' + goog.getCssName('my-renamed-class'));
  soy.renderElement(
    document.getElementById("target"),
    tmpl.test,
    {foo: "foo", bar: "bar"});

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

goog.exportSymbol('app.main', main);
