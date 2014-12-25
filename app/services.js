// RESTFUL services


var jprServices = angular.module('jprServices',
    ['ngResource']).constant('Host', {
    'base': 'http://178.62.98.209:8080'
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
jprServices.factory('Auth', ['$http', 'Host', function($http, Host) {
    var auth = {
      isLoggedIn: false,
      token: '',
      email: ''
    }
    
    auth.login = function(email, password) {
      var headVal = ["Basic", Buffer([email, password].join(':')).toString('base64')].join(' ');
      var req = {
        method: 'POST',
        url: [Host.base, 'tokens'].join('/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': headVal
        }, 
        data: {}
      }
      var response_status;
      
      $http(req).succes(function (data, status, headers, config){
        
        if (status == 201){
          auth.isLoggedIn = true;
          auth.token = data.token;
          auth.email = email;
        }else {
          auth.isLoggedIn = false;
        }
        response_status = status;
      }).error(function (data, status, headers, config){
        auth.isLoggedIn = false;
        response_status = status;
      });
      
      return response_status;
    }
    
    return auth;
}]);