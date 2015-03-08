jprApp.controller('QuizVeririficationModalCtrl', function($scope, close) {
    $scope.end = function(status) {
        status = status && ($scope.verification_code != undefined) && $scope.verification_code.length >= 1;
        close({
            status: status,
            verification_code: $scope.verification_code
        }, 200);
    };
});