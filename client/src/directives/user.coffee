angular.module 'evaluator'
  .directive 'user', ->
    directive =
      restrict: 'AE'
      templateUrl: 'directives/user.html'
      scope:
        user: '=data'
      controller: ['$scope', 'UserAuth', ($scope, UserAuth) ->
        $scope.canEdit = UserAuth.user.admin
      ]