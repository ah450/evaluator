jprApp.controller('CourseListCtrl', ['$scope', 'Course', 'Page', function ($scope, Course, Page) {
    $scope.courses = Course.query();
    Page.setSection('Our Courses');
}]);