jprApp.controller('ErrorCtrl', ['$scope', 'Page', function($scope, Page) {
  $scope.errorMessages = Page.getErrorMessages();
  $scope.removeMessage = function(index) {
    Page.removeErrorMessage(index);
  };

}]);