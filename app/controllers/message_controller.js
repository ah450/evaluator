jprApp.controller('MessageCtrl', ['$scope', 'Page', function($scope, Page) {
  $scope.errorMessages = Page.getErrorMessages();
  $scope.removeErrorMessage = Page.removeErrorMessage;
  $scope.infoMessages = Page.getInfoMessages();
  $scope.removeInfoMessage = Page.removeInfoMessage;
}]);