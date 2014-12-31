jprApp.controller('ErrorCtrl', ['$scope', 'Page', function($scope, Page) {
  Page.clearTitle();
  Page.setSection('Oopsie');
  $scope.message = Page.getErrorMessage();
  $scope.has_message = Page.hasErrorMessage();
}]);