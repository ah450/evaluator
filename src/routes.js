"use strict";
angular.module('jpr')
.config(function($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise("/");
});