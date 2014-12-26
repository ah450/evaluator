jprApp.controller('CourseListCtrl', ['$scope', 'Course', 'Page', 'Auth', function ($scope, Course, Page, Auth) {
    $scope.courses = Course.query();
    $scope.isLoggedIn = Auth.isLoggedIn;
    $scope.current_user = Auth.getUser;
    Page.setSection('Our Courses');
    $scope.$watch("isLoggedIn()", function() {
      $scope.courses = Course.query();
    });
}]);