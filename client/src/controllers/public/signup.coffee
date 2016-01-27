angular.module 'evaluator'
  .controller 'SignupController', ($scope) ->
    STUDENT_EMAIL_REGEX = /^[a-zA-Z\.\-]+@student.guc.edu.eg$/
    $scope.processing = false
    $scope.userData = {}
    $scope.isStudent = ->
      STUDENT_EMAIL_REGEX.test $scope.userData.email

    $scope.submit = ->
      return if $scope.processing
      $scope.processing = true
      UserAuth.signup $scope.userData
        .then ->
          $state.go 'public.welcome'
        .catch (response) ->
          if response.status is 422
            $scope.processing = false
            $scope.error = ("#{key.capitalize()} #{value}." for key, value of response.data)
              .join ' '
          else
            $state.go 'public.internal_error'