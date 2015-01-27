jprApp.controller('CourseListCtrl', ['$scope', 'Course', 'Page', 'Auth', function($scope, Course, Page, Auth) {
  
  $scope.courses = [];
  $scope.loading = true;
  $scope.creating = false;
  function handleCoursesLoad(courses) {
    $scope.courses = courses;
    $scope.loading = false;
  }
  Course.$all().then(handleCoursesLoad);
  
  $scope.isLoggedIn = Auth.isLoggedIn;
  $scope.current_user = Auth.getUser();
  Page.setSection('Our Courses');
  Page.setLink('courses');
  $scope.isStudent = $scope.isLoggedIn() ? $scope.current_user.isStudent() : false;

  $scope.$watch("isLoggedIn()", function() {
    $scope.loading = true;
    Course.$all().then(handleCoursesLoad);
    $scope.current_user = Auth.getUser();
    $scope.isStudent = $scope.isLoggedIn() ? $scope.current_user.isStudent() : false;
  });
  $scope.newCourse = {
    name: '',
    description: '',
  };

  $scope.createCourse = function() {
    Page.clearErrorMessages();
    $scope.creating = true;
    var course = new Course($scope.newCourse);
    course.save(function(newCourse) {
      // success callback
      $scope.newCourse = {
        name: '',
        description: ''
      };
      $scope.creating = false;
      $scope.courses.push(newCourse);
      Page.addInfoMessage('Course Created!')
    }, function(httpResponse) {
      $scope.creating = false;
      if (httpResponse.status == 403 || httpResponse.status == 401) {
        Page.addErrorMessage('Only teachers can create courses!')
      } else if (httpResponse.status == 422) {
        Page.addErrorMessage('Course already exists!');
      }
    });
  }

  $scope.join = function(course) {
    var joinErrorCallback = function(httpResponse) {
      if (httpResponse.status == 422) {
        Page.addErrorMessage('You are already a member of this course!');
      }
    };
    if ($scope.current_user.isStudent()) {
      // join as student
      course.add_student($scope.current_user,
        function(data) {
          // success callback
          Page.addInfoMessage('You are now enrolled in ' + course.name + '.');
        }, joinErrorCallback);
    } else {
      // join as teacher
      course.add_teacher( $scope.current_user,
        function(data) {
          // success callback
          Page.addInfoMessage('Welcome aboard!');
        }, joinErrorCallback);
    }
  };
}]);