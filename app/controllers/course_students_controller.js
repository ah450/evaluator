jprApp.controller('CourseStudentsCtrl', ['$scope', 'Page', 'Auth', 'Course',
  function($scope, Page, Auth, Course) {
  $scope.loaded = false; // we are still loading!
  $scope.students = [];
  $scope.course = $scope.$parent.course;
  if (Auth.isLoggedIn() ) {
    $scope.loggedIn = true;
  } else {
    $scope.loggedIn = false;
    $scope.loaded = true;
  }

  // Pagination variables
  $scope.StudentsPerPage = Course.studentsPerPage;
  $scope.totalStudents = 0;

  $scope.loadStudentsPage = function (newPageNumber) {
      $scope.loadingStudents = true;
      $scope.students = [];
      $scope.course.getStudentsPage(newPageNumber)
      .then(function(studentsPage) {
        $scope.loadingStudents = false;
        $scope.students = studentsPage.students;
        $scope.totalStudents = studentsPage.pages * $scope.studentsPerPage;
      }, function(data, status, headers, config) {
        $scope.loadingStudents = false;
        Page.addErrorMessage(data.message);
      });
  };
  // load the first page
  $scope.loadStudentsPage(1);
}]);