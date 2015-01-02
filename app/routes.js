jprApp.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.when('/home', {
        templateUrl: 'partials/home.html',
        controller: 'HomeCtrl'
      }).when('/courses', {
        templateUrl: 'partials/courses.html',
        controller: 'CourseListCtrl'
      }).when('/users', {
        templateUrl: 'partials/users.html',
        controller: 'UsersListCtrl',
      }).when('/user/:userId', {
        templateUrl: 'partials/profile.html',
        controller: 'ProfileCtrl'
      })
      .when('/course/:courseName/:ep', {
        templateUrl: 'partials/course_related.html',
        controller: 'CourseRelatedCtrl'
      }).when('/course/:courseName', {
        templateUrl: 'partials/course.html',
        controller: 'CourseCtrl'
      })
      .when('/signup', {
        templateUrl: 'partials/signup.html',
        controller: 'SignupCtrl'
      })
      .when('/project/:id', {
        templateUrl: 'partials/project.html',
        controller: 'ProjectCtrl'
      })
      .when('/', {
        redirectTo: '/home'
      })
      .when('/403', {
        templateUrl: 'partials/403.html',
        controller: 'ErrorCtrl'
      })
      .when('/404', {
        templateUrl: 'partials/404.html',
        controller: 'ErrorCtrl'
      })
      .otherwise({
        redirectTo: '/404',
      });

  }
]);