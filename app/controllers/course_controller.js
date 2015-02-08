jprApp.controller('CourseCtrl', ['$scope', '$routeParams', 'Auth', 'Page', 'Course', function($scope, $routeParams, Auth, Page, Course){
    Page.setSection($routeParams.courseName);
    Page.setLink('single-course');
    Page.showSpinner();
    $scope.loaded = false;
    $scope.redirect = false;
    $scope.showCreation = false;
    $scope.loggedIn = Auth.isLoggedIn();
    $scope.courseMember = false;
    $scope.current_user = Auth.getUser();
    $scope.isStudent = Auth.isLoggedIn() ? $scope.current_user.isStudent() : false;
    Course.$get($routeParams.courseName)
    .then(function(course){
        $scope.course = course;
        Page.hideSpinner();
        $scope.loaded = true;
    }, function(httpResponse){
        Page.hideSpinner();
        if(httpResponse.status == 404){
            $location.path('/404').replace();
        }else if (httpResponse.status == 401) {
            // Nothing....
        }else {
            Page.addErrorMessage('Internal server oopsie, please grab a programmer!');
        }
    });

    $scope.join = function(course) {
      var joinErrorCallback = function(httpResponse) {
        if (httpResponse.status == 422) {
          Page.addErrorMessage('You are already a member of this course!');
        }
      };
      var user = Auth.getUser();
      if (user.isStudent()) {
        // join as student
        course.add_student(user,
          function(data) {
            // success callback
            Page.addInfoMessage('You are now enrolled in ' + course.name + '.');
          }, joinErrorCallback);
      } else {
        // join as teacher
        course.add_teacher( user,
          function(data) {
            // success callback
            Page.addInfoMessage('Welcome aboard!');
          }, joinErrorCallback);
      }
    };
}])