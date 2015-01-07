jprApp.controller('FlashCtrl', ['$scope', 'Page', function($scope, Page){
    $scope.hasFLash = Page.hasFLash;
    $scope.getFlash = Page.getFlash;
}])