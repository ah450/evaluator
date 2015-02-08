jprApp.controller('CourseStudentsCtrl', ['$scope', 'Page', 'Auth', function($scope, Page, Auth) {
  $scope.students = [];
  $scope.loaded = false;
  $scope.$parent.course.students
    .then(function(students) {
      $scope.students = students;
      $scope.loaded = true;
      var user = Auth.getUser()
      $scope.students.forEach(function (value) {
          if (value.id == user.id) {
            $scope.$parent.courseMember = true;
          }
        });

    }, function(httpResponse) {
      $scope.loaded = true;
      if ($scope.$parent.redirect) {
        if (httpResponse.status == 403 || httpResponse.status == 401) {
          Page.setErrorFlash('Must be logged in to view course students.');
          $location.path('/403').replace();
        } else if (httpResponse.status == 404) {
          $location.path('/404').replace();
        }
      } else {
        if (httpResponse.status == 403 || httpResponse.status == 401) {
          Page.addErrorMessage('Must be logged in to view course students.');
        }
      }
    });
}]);