angular.module 'evaluator'
  .controller 'VerifyController', ($scope, $stateParams, $timeout,
    $state, $http, configurations) ->

    $scope.done = false
    $scope.message = "Account verified!"
    $scope.success = false
    # Make request
    $http.put("/api/users/#{$stateParams.id}/verify.json",
      {token: $stateParams.token}
    ).then ->
      $scope.success = true
      $scope.done = true
      $timeout ->
        $state.go 'public.login'
      , 800
    .catch (response) ->
      $scope.success = false
      if response.status is 422
        configurations.then (config) ->
          $scope.message = "Incorrect token. Please note tokens expire after #{config.verification_expiration / 60 / 60} hours."
          $scope.done = true
      else
        $state.go 'internal_error'