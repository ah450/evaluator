jprApp.controller('ProfileCtrl', ['$scope', '$routeParams', 'Page', 'User', function($scope, $routeParams, Page, User){
    Page.clearErrorMessage();
    Page.setLink('');
    Page.clearTitle();
    $scope.loaded = false;
    User.$get($routeParams.id)
    .then(function(user){
        $scope.user = user;
        Page.setLink(user.name);
        Page.setSection(user.name);
        $scope.loaded = true;
    }, function(httpResonse) {

    });
}])