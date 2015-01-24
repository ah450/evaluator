jprApp.controller('CourseTeachersCtrl', ['$scope', 'Page', function($scope, Page) {
  $scope.teachers = [];
  $scope.loaded = false;
  $scope.$parent.course.teachers
    .then(function(teachers) {
      $scope.teachers = teachers;
      $scope.loaded = true;
    }, function(httpResponse) {
      $scope.loaded = true;
      if ($scope.$parent.redirect) {
        if (httpResponse.status == 403 || httpResponse.status == 401) {
          Page.setErrorFlash('Must be logged in to view course teachers.');
          $location.path('/403').replace();
        } else if (httpResponse.status == 404) {
          $location.path('/404').replace();
        }
      } else {
        if (httpResponse.status == 403 || httpResponse.status == 401) {
          Page.addErrorMessage('Must be logged in to view course teachers.');
        }
      }
    });
}]);