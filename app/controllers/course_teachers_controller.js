jprApp.controller('CourseTeachersCtrl', ['$scope', 'Page', 'Course', 
  function($scope, Page, Course) {
  $scope.teachers = [];
  $scope.course = $scope.$parent.course;
  $scope.teachersPerPage = Course.teachersPerPage;
  $scope.totalTeachers = 0;

  $scope.loadTeachersPage = function(newPageNumber){
    $scope.loadingTeachers = true;
    $scope.teachers = [];
    $scope.course.getTeachersPage(newPageNumber)
    .then(function(teachersPage){
      $scope.loadingTeachers = false;
      $scope.teachers = teachersPage.teachers;
      $scope.totalTeachers = teachersPage.pages * $scope.teachersPerPage;
    }, function(data, status, headers, config){
      $scope.loadingTeachers = false;
      Page.addErrorMessage(data.message);
    });
  };

  $scope.loadTeachersPage(1);
}]);