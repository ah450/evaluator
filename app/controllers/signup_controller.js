jprApp.controller('SignupCtrl', ['$scope', '$location', 'User', 'Page', 'Validators', 'Login', function($scope, $location, User, Page, Validators, Login) {

  Page.setSection('Registration');
  Page.setLink('signup');
  Page.clearErrorMessage();

  if (Login.auth.isLoggedIn()) {
    $location.path('/home').replace();
  }

  $scope.isStudent = function() {
    return $scope.email && $scope.email.endsWith('@student.guc.edu.eg');
  }

  $scope.errorMessages = [];

  $scope.createAccount = function() {
    $scope.errorMessages = [];
    if (!Validators.validateName($scope.name)) {
      $scope.errorMessages.push('Please enter your name.');
    }
    if (!Validators.validateEmail($scope.email)) {
      $scope.errorMessages.push('Please enter a valid GUC email.');
    }
    if (!Validators.validatePassword($scope.password)) {
      $scope.errorMessages.push('Password must be atleast 8 characters long.');
    }
    if ($scope.isStudent()) {
      if (!Validators.validateId($scope.dash_prefix, $scope.dash_suffix)) {
        $scope.errorMessages.push('Please enter a valid GUC id (hint look at your id card).');
      }
    }

    if ($scope.errorMessages.length == 0) {
      // signup
      var data = {
        name: $scope.name,
        guc_id: [$scope.dash_prefix, $scope.dash_suffix].join('-'),
        email: $scope.email,
        password: $scope.password
      }

      var user = new User(data);
      user.$create(function(user, responseHeaders) {
        // Log in with the new user
        Login.performLogin(user.email, $scope.password, false)
          .then(function(result) {
            // redirect to home
            $location.path('/home').replace();
          });
      }, function(failResponse) {
        if (failResponse.status == 422) {
          $scope.errorMessages.push('Email already in use.');
        }
      });

    }
  }
}]);