jprApp.controller('CourseListCtrl', ['$scope', 'Course', 'Page', 'Auth', function($scope, Course, Page, Auth) {
  $scope.courses = Course.query();
  $scope.isLoggedIn = Auth.isLoggedIn;
  $scope.current_user = Auth.getUser();
  Page.setSection('Our Courses');
  Page.setLink('courses');
  Page.clearErrorMessage();

  $scope.$watch("isLoggedIn()", function() {
    $scope.courses = Course.query();
  });
  $scope.alert = null;

  $scope.newCourse = {
    name: '',
    description: '',
  };

  $scope.isStudent = Auth.getUser().email.endsWith('@student.guc.edu.eg');

  $scope.createCourse = function() {
    Course.create($scope.newCourse, function(newCourse) {
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
      if (httpResponse.status == 403) {
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
    if ($scope.current_user.email.endsWith('@student.guc.edu.eg')) {
      // join as student
      Course.add_student({
          name: course.name
        }, {
          id: $scope.current_user.id
        },
        function(data) {
          // success callback
          $scope.alert = {
            message: 'Welcome aboard!',
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
      Course.add_teacher({
          name: course.name
        }, {
          id: $scope.current_user.id
        },
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