jprApp.controller('CourseStudentsCtrl', ['$scope', 'Page', function($scope, Page) {
  $scope.students = [];
  $scope.loaded = false;
  $scope.$parent.course.students
    .then(function(students) {
      $scope.students = students;
      $scope.loaded = true;
    }, function(httpResponse) {
      $scope.loaded = true;
      if ($scope.$parent.redirect) {
        if (httpResponse.status == 403 || httpResponse.status == 401) {
          Page.setErrorMessage('Must be logged in to view course members.');
          $location.path('/403').replace();
        } else if (httpResponse.status == 404) {
          $location.path('/404').replace();
        }
      }
    });
}]);