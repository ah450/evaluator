angular.module 'evaluator'
  .factory 'configurations', (endpoints, $http) ->
    $http.get endpoints.configurations.index, {cache: true}