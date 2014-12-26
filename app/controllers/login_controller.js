jprApp.controller('LoginCtrl', ['$scope', 'Auth', 'Login', 'Validators', function($scope, Auth, Login, Validators){
  $scope.Auth = Auth;
  $scope.login_error = false;
  $scope.error_message = '';
  $scope.remember = false; // default value
  $scope.login = function(email, password, remember){
    if(Validators.validateEmail(email) && Validators.validatePassword(password)) {
      
      $scope.login_error = false;
      $scope.error_message = '';
      Login.performLogin(email, password, remember)
      .then(function(result){
        // success
        // Result is 201
        $scope.login_error = false;
        $scope.error_message = '';
      }, function(reason) {
        // error
        $scope.login_error = true;
         if (reason == 401) {
           $scope.error_message = 'Invalid email or password.';
         }else {
           $scope.error_message = 'Server unaivalble.';
         }
      });
    }else {
      $scope.login_error = true;
      $scope.error_message = 'Invalid email or password.'; 
    }
  };
}]);