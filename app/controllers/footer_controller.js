jprApp.controller('FooterCtrl', [ '$scope', 'Zen', function($scope, Zen) {
    $scope.zen = Zen.get();
    $scope.$on('$locationChangeSuccess', function() {
        $scope.zen = Zen.get();
    });
}]);