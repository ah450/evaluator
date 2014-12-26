// Controller for page header
jprApp.controller('HeadCtrl', ['$scope', 'Page', function ($scope, Page) {
  $scope.title = Page.title;
}]);