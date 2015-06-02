"use strict";

angular.module('jpr', ['ui.router', 'jpr-templates']);


angular.module('jpr').config(function() {
  Array.prototype.remove = function(element) {
    var index = this.indexOf(element);
    if (index > -1) {
      this.splice(index, 1);
    }
  };
});