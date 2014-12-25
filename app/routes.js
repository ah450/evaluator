jprApp.config(['$routeProvider', 
              function($routeProvider){
                  $routeProvider.when('/home', {
                    templateUrl: '/app/partials/home.html',
                    controller: 'HomeCtrl'
                  }).when('/courses', {
                    templateUrl: '/app/partials/courses.html',
                    controller: 'CourseListCtrl'
                  }).when('/users', {
                    templateUrl: '/app/partials/users.html',
                    controller: 'UsersListCtrl'
                  }).when('/course/:courseName/projects', {
                    templateUrl: '/app/partials/course_projects.html',
                    controller: 'CourseProjectCtrl'
                  }).when('/course/:courseName', {
                    templateUrl: 'app/partials/course.html',
                    controller: 'CourseCtrl'
                  })
                  .when('/signup', {
                    templateUrl: '/app/partials/signup.html',
                    controller: 'SignupCtrl'
                  })
                  .otherwise({
                    redirectTo: '/home',
                  });
                  
              }]);