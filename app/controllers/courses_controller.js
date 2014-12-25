jprApp.controller('CourseListCtrl', ['$scope', '$document', 'Courses', 'Page', 
     
function ($scope, $document,Courses, Page) {
    $scope.courses = Courses.query();
    $document.title = "Hello"
    Page.setSection('Our Courses');
}]);