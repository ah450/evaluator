// RESTFUL services


var jprServices = angular.module('jprServices',
    ['ngResource', 'ipCookie']).constant('Host', {
    'base': 'http://127.0.0.1:8080'
  });


jprServices.factory('Course', ['$resource', 'Host',
      function ($resource, Host) {
        var url = [Host.base, ':dest', ':name', ':ep'].join('/');
        
        return $resource(url, {}, {
          query: {method: 'GET', params: {dest: 'courses'}, isArray: true, headers: {'X-Auth-Token': 'Replace Me'}},
          create: {method: 'POST', params: {dest: 'courses'}, headers: {'X-Auth-Token': 'Replace Me'}},
          get: {method: 'GET', params: {dest: 'course'}, headers: {'X-Auth-Token': 'Replace Me'}},
          update: {method: 'PUT', params: {dest: 'course'}, headers: {'X-Auth-Token': 'Replace Me'}},
          delete: {method: 'DELETE', params: {dest: 'course'}, headers: {'X-Auth-Token': 'Replace Me'}}
      });

}]);

jprServices.factory('User', ['$resource', 'Host', function($resource, Host){
    var url = [Host.base, ':dest', ':id'].join('/');
    return $resource(url, {}, {
      query: {method: 'GET', params: {dest: 'users'}, isArray: true, headers: {'X-Auth-Token': 'Replace Me'}},
      create: {method: 'POST', params: {dest: 'users'}, headers: {'X-Auth-Token': 'Replace Me'}}, 
      update: {method: 'PUT', params: {dest: 'user'}, headers: {'X-Auth-Token': 'Replace Me'}},
      delete: {method: 'DELETE', params: {dest: 'user'}, headers: {'X-Auth-Token': 'Replace Me'}},
      get: {method: 'GET', params: {dest: 'user'}, headers: {'X-Auth-Token': 'Replace Me'}}
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

jprServices.factory('Login', ['$q', '$http', 'Host', 'Auth', function($q, $http, Host, Auth){
  var login = {
    auth: Auth
  };
  // Login functions
  // Attempts to retrieve a token
  // returns a promise - reason/result is status code.
  // resolved only if status is 201.
  login.performLogin = function(email, password, remember) {
      var headVal = ["Basic", btoa([email, password].join(':'))].join(' ');
      var req = {
        method: 'POST',
        url: [Host.base, 'token'].join('/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': headVal
        }, 
        data: {remember: remember.toString()}
      };
      var response_status = $q.defer();
      
      $http(req).success(function (data, status, headers, config){
        
        if (status == 201){
          Auth.setToken(data.token, data.valid_for)
          Auth.setUser(data.user, data.valid_for);
          response_status.resolve(status);
        } else {
          Auth.clear();
          response_status.reject(status);
        }
        
      }).error(function (data, status, headers, config){
        Auth.clear();
        response_status.reject(status);
      });
      
      return response_status.promise;
    }
  return login;
}]);


jprServices.factory('Auth', ['ipCookie', function(ipCookie) {
    var TOKEN_COOKIE_KEY = 'X-AUTH-TOKEN';
    var USER_COOKIE_KEY = 'CURRENT_USER';
    var auth = {
    };
    
    auth.isLoggedIn = function() {
      return ipCookie(TOKEN_COOKIE_KEY) && true;
    };
    
    auth.getToken = function() {
      return ipCookie(TOKEN_COOKIE_KEY);
    };
    
    auth.setToken = function(token, duration) {
      ipCookie(TOKEN_COOKIE_KEY, token, {expires: duration, expirationUnit: 'seconds', secure: false } );
    };
    
    auth.setUser = function(user, duration) {
       ipCookie(USER_COOKIE_KEY, user, {expires: duration, expirationUnit: 'seconds', secure: false } );
    };
    
    auth.getUser = function() {
      return ipCookie(USER_COOKIE_KEY);
    };
    auth.clear = function() {
      ipCookie.remove(TOKEN_COOKIE_KEY);
      ipCookie.remove(USER_COOKIE_KEY);
    };
    

    
    return auth;
}]);

jprServices.factory('Validators', function() {
  var validators = {
    
  };
  validators.validateEmail = function(email) {
    return email &&  ( email.endsWith("@guc.edu.eg") || email.endsWith("@student.guc.edu.eg") );
  }
    
  validators.validateName = function(name) {
    return name && name.length >= 1;
  }

  validators.validatePassword = function(password) {
    return password && password.length >= 8;
  }

  validators.validateId = function(id_prefix, id_suffix){
    return id_suffix && id_prefix && !isNaN(id_prefix) && !isNaN(id_suffix);
  }
  return validators;
});