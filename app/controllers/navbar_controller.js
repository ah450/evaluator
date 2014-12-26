jprApp.controller('NavbarCtrl', ['$scope', 'Auth', 'Page', function($scope, Auth, Page) {
  $scope.Auth = Auth;
  $scope.currentLink = Page.currentLink;
}]);