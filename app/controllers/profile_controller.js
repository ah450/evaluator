jprApp.controller('ProfileCtrl', ['$scope', '$routeParams', 'Page', 'User', 'Validators','Auth', function($scope, $routeParams, Page, User, Validators,Auth) {
    Page.setLink('');
    Page.clearTitle();
    $scope.loaded = false;
    $scope.profile = {confirmpass:""};
    User.$get($routeParams.id)
        .then(function(user) {
            $scope.user = user;
            Page.setLink(user.name);
            Page.setSection(user.name);
            $scope.loaded = true;
        }, function(httpResonse) {
            Page.addErrorMessage(httpResponse.message);
        });

    $scope.isOwner = function() {
        return $scope.user.id===Auth.getUser().id;
    };

    $scope.changePassword = function() {
        var user = $scope.user;
        if (Validators.validatePassword(user.password) && Validators.validateSamePassword(user.password, $scope.profile.confirmpass)) {
            user.save(function (user) {
                $scope.user = user;
                Page.addInfoMessage("Password changed");
                $scope.profile.confirmpass = "";
            }, function (httpResponse) {
                Page.addErrorMessage(httpResponse.message);
            });
        } else {
            Page.addErrorMessage('password less than 8 charachters or doesn\'t match');
        }
    };
}]);
