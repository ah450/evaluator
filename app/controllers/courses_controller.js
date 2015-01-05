jprApp.controller('CourseListCtrl', ['$scope', 'Course', 'Page', 'Auth', function($scope, Course, Page, Auth) {
  $scope.courses = [];

  Course.$all().then(function(courses){
    $scope.courses = courses;
  });
  $scope.isLoggedIn = Auth.isLoggedIn;
  $scope.current_user = Auth.getUser();
  Page.setSection('Our Courses');
  Page.setLink('courses');
  Page.clearErrorMessage();
  $scope.isStudent = $scope.isLoggedIn() ? $scope.current_user.isStudent() : false;

  $scope.$watch("isLoggedIn()", function() {
    Course.$all().then(function(courses){
      $scope.courses = courses;
    });
    $scope.current_user = Auth.getUser();
    $scope.isStudent = $scope.isLoggedIn() ? $scope.current_user.isStudent() : false;
  });
  $scope.alert = null;

  $scope.newCourse = {
    name: '',
    description: '',
  };

  $scope.createCourse = function() {

    course = new Course($scope.newCourse);

    course.save(function(newCourse) {
      // success callback
      $scope.newCourse = {
        name: '',
        description: ''
      };
      $scope.courses.push(newCourse);
      $scope.alert = {
        message: 'Course Created!',
        type: 'alert-success'
      }
    }, function(httpResponse) {
      if (httpResponse.status == 403 || httpResponse.status == 401) {
        $scope.alert = {
          message: 'Only teachers can create courses!',
          type: 'alert-warning'
        };
      } else if (httpResponse.status == 422) {
        $scope.alert = {
          message: 'Course already exists!',
          type: 'alert-warning'
        };
      }
    });
  }

  $scope.join = function(course) {
    if ($scope.current_user.isStudent()) {
      // join as student
      course.add_student($scope.current_user,
        function(data) {
          // success callback
          $scope.alert = {
            message: 'You are now enrolled in ' + course.name + '.',
            type: 'alert-success'
          };
        },
        function(httpResponse) {
          //failure callback
          if (httpResponse.status == 422) {
            $scope.alert = {
              message: 'You are already a member of this course!',
              type: 'alert-warning'
            };
          }
        }
      );
    } else {
      // join as teacher
      course.add_teacher( $scope.current_user,
        function(data) {
          // success callback
          $scope.alert = {
            message: 'Welcome aboard!',
            type: 'alert-success'
          };
        },
        function(httpResponse) {
          /// failure callback
          if (httpResponse.status == 422) {
            $scope.alert = {
              message: 'You are already a member of this course!',
              type: 'alert-warning'
            };
          }
        }
      );
    }
  };

  $('body').on('click', '#alertDismiss', function() {
    $scope.alert = null;
  });

  $('body').on('click', '#newCourseExpandButton', function() {
      $(this).toggleClass("glyphicon-plus glyphicon glyphicon-minus");  
    });


}]);