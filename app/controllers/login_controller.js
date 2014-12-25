jprApp.controller('LoginCtrl', ['$scope', 'Auth', function($scope, Auth){
  $scope.Auth = Auth;
  $scope.login_error = false;
  $scope.error_message = '';
  $scope.login = function(email, password){
    if(email && password) {
      var status = Auth.login(email, password);
      status.then(function(result){ 
        // Result is 201
        $scope.login_error = false;
        $scope.error_message = '';
      }, function(reason) {
        $scope.login_error = true;
         if (reason == 401) {
           $scope.error_message = 'Invalid email or password.';
         }else {
           $scope.error_message = 'Server unaivalble';
         }
      });
    }
  };
}]);