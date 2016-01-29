angular.module 'evaluator'
  .controller 'VerifyController', ($scope, $stateParams, $timeout,
    $state, $http, configurations,
    UserAuth, $auth, localStorageService, User) ->

    $scope.done = false
    $scope.message = "Account verified! Please wait you will be redirected soon."
    $scope.success = false
    # Make request
    $http.put("/api/users/#{$stateParams.id}/verify.json",
      {token: $stateParams.token}
    ).then (response)->
      $scope.success = true
      $scope.done = true
      $timeout ->
        # $state.go 'public.login'
        data = response.data.data
        $auth.setToken(data.token)
        localStorageService.set 'currentUser', data.user
        UserAuth.currentUserData = data
        UserAuth.currentUser = new User data
        $state.go 'private.courses'
      , 4000
    .catch (response) ->
      $scope.success = false
      if response.status is 422
        configurations.then (config) ->
          $scope.message = "Incorrect token. Please note tokens expire after #{config.verification_expiration / 60 / 60} hours."
          $scope.done = true
      else
        $state.go 'internal_error'