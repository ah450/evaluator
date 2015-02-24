jprApp.controller('LoginCtrl', ['$scope', 'Auth', 'Login', 'Validators', 'Host','Page', '$http', function($scope, Auth, Login, Validators, Host,Page, $http) {
    $scope.isLoggedIn = Auth.isLoggedIn;
    $scope.working = false;
    $scope.forgotpass = false;
    $scope.resendactivation = false;
    $scope.login_error = false;
    $scope.remember = true; // default value

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
                        $scope.resendactivation = true;
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

    $scope.toggleForgotPassword = function() {
        $scope.forgotpass = !$scope.forgotpass;
    };

    $scope.sendForgotPassword = function(email) {
        $scope.working = true;
        if (Validators.validateEmail(email)) {
            $http.post(Host.api_base + '/user/reset', {
                email: email
            }).success(function(data) {
                Page.addInfoMessage(data.message || "Password reset email sent to " + email);
                $scope.working = false;
            }).error(function(data) {
                Page.addErrorMessage(data.message);
                $scope.working = false;
            });
        } else {
            $scope.working = false;
            $scope.login_error = true;
            Page.addErrorMessage('Invalid email');
        }
    };

    $scope.sendActivation = function(email) {
        $scope.working = true;
        if (Validators.validateEmail(email)) {
            $http.post(Host.api_base + '/activate', {
                email: email
            }).success(function(data) {
                Page.addInfoMessage(data.message || "Activation email re-sent to " + email);
                $scope.working = false;
            }).error(function(data) {
                Page.addErrorMessage(data.message);
                $scope.working = false;
            });
        } else {
            $scope.working = false;
            $scope.login_error = true;
            Page.addErrorMessage('Invalid email');
        }
    };

}]);
