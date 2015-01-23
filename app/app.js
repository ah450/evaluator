var jprApp = angular.module('jprApp', ['ui.bootstrap.datetimepicker', 'ngRoute', 'jprServices', 'LocalStorageModule', 'angularFileUpload', 'jpr-templates']);
var jprServices = angular.module('jprServices', ['ngResource', 'ipCookie']).constant('Host', {
  'base': 'https://api.evaluator.in'
});
jprApp.factory('tokenInjector', ['AuthBase', function(Auth) {

  var token_injector = {
    request: function(config) {
      if ('X-Auth-Token' in config.headers) {
        if (config.headers['X-Auth-Token'] == 'Replace Me') {
          if (Auth.isLoggedIn()) {
            config.headers['X-Auth-Token'] = Auth.getToken();
          } else {
            // If not logged in remove header
            delete config.headers['X-Auth-Token'];
          }
        }
      }
      return config;
    }
  };
  return token_injector;
}]);



jprApp.config(function() {
  if (typeof String.prototype.endsWith !== 'function') {
    String.prototype.endsWith = function(suffix) {
      return this.indexOf(suffix, this.length - suffix.length) !== -1;
    };
  }
  if(typeof Array.prototype.clear !== 'function'){
    Array.prototype.clear = function() {
        while(this.length){this.pop();}
    }
  }
  if (!Date.prototype.toISOString) {
    (function() {

      function pad(number) {
        if (number < 10) {
          return '0' + number;
        }
        return number;
      }

      Date.prototype.toISOString = function() {
        return this.getUTCFullYear() +
          '-' + pad(this.getUTCMonth() + 1) +
          '-' + pad(this.getUTCDate()) +
          'T' + pad(this.getUTCHours()) +
          ':' + pad(this.getUTCMinutes()) +
          ':' + pad(this.getUTCSeconds()) +
          '.' + (this.getUTCMilliseconds() / 1000).toFixed(3).slice(2, 5) +
          'Z';
      };

    }());
  }
});

jprApp.config(['localStorageServiceProvider', function(localStorageServiceProvider){
  localStorageServiceProvider.setPrefix('jprApp');
}]);

jprApp.config(['$httpProvider', function($httpProvider) {
  $httpProvider.interceptors.push('tokenInjector');
}]);

