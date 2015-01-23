jprApp.controller('SignupCtrl', ['$scope', '$location', 'User', 'Page', 'Validators', 'Login', function($scope, $location, User, Page, Validators, Login) {
  $scope.newUserData = {
    email: '',
    password: '',
    dash_prefix: '',
    dash_suffix: '',
    validate: function() {
      valid = true;
      if (!Validators.validateName(this.name)) {
        Page.addErrorMessage('Please enter your name.');
        $scope.name_error = true;
        valid = false;
      }
      if (!Validators.validateEmail(this.email)) {
        Page.addErrorMessage('Please enter a valid GUC email.');
        $scope.email_error = true;
        valid = false;
      }
      if (!Validators.validatePassword(this.password)) {
        Page.addErrorMessage('Password must be at least 8 characters long.');
        $scope.pass_error = true;
        valid = false;

      }
      if ($scope.isStudent(this.email)) {
        if (!Validators.validateId(this.dash_prefix, this.dash_suffix)) {
          Page.addErrorMessage('Please enter a valid GUC id (hint look at your id card).');
          $scope.dash_error = true;
          valid = false;
        }
      }
      return valid;
    },
    getPostData: function() {
      var data = {
        name: this.name,
        guc_id: [this.dash_prefix, this.dash_suffix].join('-'),
        email: this.email,
        password: this.password
      }
      return data;
    }
  };
  $scope.name_error = false;
  $scope.email_error = false;
  $scope.pass_error = false;
  $scope.dash_error = false;
  $scope.working = false;

  $scope.isStudent = function(email) {
    return email && email.endsWith('@student.guc.edu.eg');
  };
  $scope.createAccount = function() {
    $scope.working = true;
    $scope.name_error = false;
    $scope.email_error = false;
    $scope.pass_error = false;
    $scope.dash_error = false;
    Page.clearErrorMessages()
    

    if ($scope.newUserData.validate()) {
      // signup
      var user = new User($scope.newUserData.getPostData(), false);
      user.save(function(user, responseHeaders) {
        Page.addInfoMessage('Activation email sent.');
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