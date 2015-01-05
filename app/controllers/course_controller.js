jprApp.controller('CourseCtrl', ['$scope', '$routeParams', 'Auth', 'Page', 'Course', function($scope, $routeParams, Auth, Page){
    Page.setSection($routeParams.courseName);
    Page.setLink('single-course');
    Page.clearErrorMessage();
    $scope.loaded = false;
    Course.$get($routeParams.courseName)
    .then(function(course){
        $scope.course = course;
        $scope.loaded = true;
    }, function(httpResponse){
        //error
    });
}])