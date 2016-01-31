angular.module 'evaluator'
  .directive 'user', ->
    directive =
      restrict: 'AE'
      templateUrl: 'directives/user.html'
      scope:
        user: '=data'