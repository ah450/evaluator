// RESTFUL services


var jprServices = angular.module('jprServices',
    ['ngResource']).constant('Host', {
    'base': 'http://127.0.0.1:8080'
  });


jprServices.factory('Courses', ['$resource', 'Host',
      function ($resource, Host) {
        var url = [Host.base, ':dest', ':name', ':ep'].join('/');
        
        return $resource(url, {}, {
          query: {method: 'GET', params: {dest: 'courses'}, isArray: true},
          create: {method: 'POST', params: {dest: 'courses'}},
          update: {method: 'PUT', params: {dest: 'course'}},
          delete: {method: 'DELETE', params: {dest: 'course'}}
      });

}]);


// Utility services
jprServices.factory('Page', function() {
  var title = 'JPR';
  return {
    title: function() { return title;},
    setTitle: function(newTitle){ title = newTitle;},
    setSection: function(section){ title = "JPR| " + section; }
  };
});


// Authentication
jprServices.factory('Auth', ['$http', '$q', 'Host', function($http, $q, Host) {
    var auth = {
      isLoggedIn: false,
      token: ''
    }
    
    // Login functions
    // Attempts to retrieve a token
    // returns a promise - reason/result is status code.
    // resolved only if status is 201.
    auth.login = function(email, password) {
      var headVal = ["Basic", btoa([email, password].join(':'))].join(' ');
      var req = {
        method: 'POST',
        url: [Host.base, 'token'].join('/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': headVal
        }, 
        data: {}
      }
      var response_status = $q.defer();
      
      $http(req).success(function (data, status, headers, config){
        
        if (status == 201){
          auth.isLoggedIn = true;
          auth.token = data.token;
          auth.auth.user = data.user;
          response_status.resolve(status);
        } else {
          auth.isLoggedIn = false;
          response_status.reject(status);
        }
        
      }).error(function (data, status, headers, config){
        auth.isLoggedIn = false;
        response_status.reject(status);
      });
      
      return response_status.promise;
    }
    
    return auth;
}]);