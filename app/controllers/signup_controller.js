jprApp.controller('SignupCtrl', ['$scope', '$location', 'User', 'Page', 'Validators', 'Login', function($scope, $location, User, Page, Validators, Login) {
  Page.clearErrorMessages();
  $scope.email = '';
  $scope.name_error = false;
  $scope.email_error = false;
  $scope.pass_error = false;
  $scope.dash_error = false;
  $scope.working = false;

  $scope.isStudent = function(email) {
    return email && email.endsWith('@student.guc.edu.eg');
  }

  $scope.createAccount = function() {
    $scope.working = true;
    $scope.name_error = false;
    $scope.email_error = false;
    $scope.pass_error = false;
    $scope.dash_error = false;
    Page.clearErrorMessages()
    if (!Validators.validateName($scope.name)) {
      Page.addErrorMessage('Please enter your name.');
      $scope.name_error = true;
    }
    if (!Validators.validateEmail($scope.email)) {
      Page.addErrorMessage('Please enter a valid GUC email.');
      $scope.email_error = true;
    }
    if (!Validators.validatePassword($scope.password)) {
      Page.addErrorMessage('Password must be at least 8 characters long.');
      $scope.pass_error = true;
    }
    if ($scope.isStudent($scope.email)) {
      if (!Validators.validateId($scope.dash_prefix, $scope.dash_suffix)) {
        Page.addErrorMessage('Please enter a valid GUC id (hint look at your id card).');
        $scope.dash_error = true;
      }
    }

    if (!Page.hasErrorMessages()) {
      // signup
      var data = {
        name: $scope.name,
        guc_id: [$scope.dash_prefix, $scope.dash_suffix].join('-'),
        email: $scope.email,
        password: $scope.password
      }

      var user = new User(data, false);
      user.save(function(user, responseHeaders) {
        Page.setFlash('Activation email sent.');
        $scope.working = false;
      }, function(failResponse) {
        $scope.working = false;
        if (failResponse.status == 422) {
          Page.addErrorMessage('Email already in use.');
        }
      });

    } else {
      $scope.working = false;
    }
  }
}]);