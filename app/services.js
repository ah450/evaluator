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