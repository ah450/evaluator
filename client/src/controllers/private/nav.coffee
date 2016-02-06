angular.module 'evaluator'
  .controller 'PrivateNavController', ($scope, $state, UserAuth) ->
    $scope.isTeacher = UserAuth.user.teacher
    $scope.logout = ->
      UserAuth.logout()
      $state.go 'public.login'
