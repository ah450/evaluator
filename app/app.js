var jprApp = angular.module('jprApp', ['ngRoute', 'jprServices', 'LocalStorageModule', 'angularFileUpload', 'jpr-templates']);
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
});

jprApp.config(['localStorageServiceProvider', function(localStorageServiceProvider){
  localStorageServiceProvider.setPrefix('jprApp');
}]);

jprApp.config(['$httpProvider', function($httpProvider) {
  $httpProvider.interceptors.push('tokenInjector');
}]);