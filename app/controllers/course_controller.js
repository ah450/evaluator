jprApp.controller('CourseCtrl', ['$scope', '$routeParams', 'Auth', 'Page', 'Course', function($scope, $routeParams, Auth, Page, Course){
    Page.setSection($routeParams.courseName);
    Page.setLink('single-course');
    Page.showSpinner();
    $scope.loaded = false;
    $scope.redirect = false;
    $scope.showCreation = false;
    Course.$get($routeParams.courseName)
    .then(function(course){
        $scope.course = course;
        Page.hideSpinner();
        $scope.loaded = true;
    }, function(httpResponse){
        Page.hideSpinner();
        if(httpResponse.status == 404){
            $location.path('/404').replace();
        }else {
            Page.addErrorMessage('Internal server oopsie, please grab a programmer!');
        }
    });
}])