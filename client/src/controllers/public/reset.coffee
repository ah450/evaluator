angular.module 'evaluator'
  .controller 'ResetController', ($scope, $stateParams, $timeout, $state, $http) ->
    $scope.processing = false
    $scope.done = false
    $scope.userData = {}

    
    $scope.resetPassword = ->
      return if $scope.processing
      $scope.processing = true
      $http.put("/api/users/#{$stateParams.id}/confirm_reset.json",
        {token: $stateParams.token, pass: $scope.userData.password}
      ).then ->
        $scope.processing = false
        $scope.done = true
        $timeout ->
          $state.go 'public.login'
        , 800
      .catch (response) ->
        if response.status is 404
          $scope.processing = false
          $scope.error = "User does not exist"
        else if response.status is 422
          $scope.processing = false
          $scope.error = response.data.message
        else
          $stage.go 'public.internal_error'
