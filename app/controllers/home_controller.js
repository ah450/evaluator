jprApp.controller('HomeCtrl', ['$scope', 'Page', 'Auth', function($scope, Page, Auth) {
  Page.setLink('home');
  Page.clearTitle();
  $scope.isLoggedIn = Auth.isLoggedIn;

}]);