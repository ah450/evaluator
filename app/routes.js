jprApp.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.when('/home', {
        templateUrl: '/app/partials/home.html',
        controller: 'HomeCtrl'
      }).when('/courses', {
        templateUrl: '/app/partials/courses.html',
        controller: 'CourseListCtrl'
      }).when('/users', {
        templateUrl: '/app/partials/users.html',
        controller: 'UsersListCtrl',
      }).when('/user/:userId', {
        templateUrl: '/app/profile.html',
        controller: 'ProfileCtrl'
      })
      .when('/course/:courseName/:ep', {
        templateUrl: '/app/partials/course_related.html',
        controller: 'CourseRelatedCtrl'
      }).when('/course/:courseName', {
        templateUrl: 'app/partials/course.html',
        controller: 'CourseCtrl'
      })
      .when('/signup', {
        templateUrl: '/app/partials/signup.html',
        controller: 'SignupCtrl'
      })
      .when('/project/:id', {
        templateUrl: '/app/partials/project.html',
        controller: 'ProjectCtrl'
      })
      .when('/', {
        redirectTo: '/home'
      })
      .when('/403', {
        templateUrl: '/app/partials/403.html',
        controller: 'ErrorCtrl'
      })
      .when('/404', {
        templateUrl: 'app/partials/404.html',
        controller: 'ErrorCtrl'
      })
      .otherwise({
        redirectTo: '/404',
      });

  }
]);