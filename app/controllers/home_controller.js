jprApp.controller('HomeCtrl', ['$scope', 'Page', function($scope, Page) {
  Page.setLink('home');
  Page.clearTitle();
  Page.clearErrorMessage();

}]);