jprApp.controller('LoginCtrl', ['$scope', 'Auth', 'Login', 'Validators', 'Page', function($scope, Auth, Login, Validators, Page) {
  $scope.isLoggedIn = Auth.isLoggedIn;
  $scope.working = false;
  $scope.login_error = false;
  $scope.remember = false; // default value

  $scope.login = function(email, password, remember) {
    Page.clearErrorMessages()
    $scope.login_error = false;
    $scope.working = true;
    if (Validators.validateEmail(email) && Validators.validatePassword(password)) {
      Login.performLogin(email, password, remember)
        .then(function(result) {
          // success
          $scope.working = false;
        }, function(reason) {
          // error
          $scope.working = false;
          $scope.login_error = true;
          $scope.password = password;
          $scope.email = email;
          if (reason == 401) {
            Page.addErrorMessage('Invalid email or password.');
          } else if (reason == 422) {
            Page.addErrorMessage('Account Inactive, please check your spam folder.');
          } else {
            Page.addErrorMessage('Server unavailable.');
          }
        });
    } else {
      $scope.working = false;
      $scope.login_error = true;
      Page.addErrorMessage('Invalid email or password.');
    }
  };
}]);