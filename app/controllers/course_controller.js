jprApp.controller('CourseCtrl', ['$scope', '$routeParams', 'Auth', 'Page', function($scope, $routeParams, Auth, Page){
    Page.setSection($routeParams.courseName);
    Page.setLink('signle-course');
    Page.clearErrorMessage();
}])