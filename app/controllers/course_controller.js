jprApp.controller('CourseCtrl', ['$scope', '$routeParams', 'Auth', 'Page', 'Course', function($scope, $routeParams, Auth, Page, Course){
    Page.setSection($routeParams.courseName);
    Page.setLink('single-course');
    Page.clearErrorMessage();
    $scope.loaded = false;
    $scope.redirect = false;
    $scope.showCreation = false;
    Course.$get($routeParams.courseName)
    .then(function(course){
        $scope.course = course;
        $scope.loaded = true;
    }, function(httpResponse){
        if(httpResponse.status == 404){
            $location.path('/404').replace();
        }
    });
}])