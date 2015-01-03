jprApp.controller('CourseRelatedCtrl', ['$scope', '$routeParams', '$location', '$upload', 'Auth', 'Page', 'Project', 'User', 'Course', function($scope, $routeParams, $location, $upload, Auth, Page, Project, User, Course) {
  Page.setSection('Projects');
  Page.setLink('course-projects');
  Page.clearErrorMessage();
  $scope.isLoggedIn = Auth.isLoggedIn;
  $scope.loaded = false;

  var projectCtrl = function() {

    var projectsSuccesCallback = function(projects) {
      $scope.loaded = true;
      projects.forEach(function(project) {
        project.submissions = [];
      })
    };

    var projectFailureCallback = function(httpResponse) {
      if (httpResponse.status == 403) {
        Page.setErrorMessage('Must be a course teacher or student to view projects.');
        $location.path('/403').replace();
      } else if (httpResponse.status == 404) {
        $location.path('/404').replace();
      }
    };

    $scope.projects = Project.query({
        courseName: $routeParams.courseName
      }, projectsSuccesCallback,
      projectFailureCallback);
  };
  $scope.isTeacher = Auth.getUser().email.endsWith('@guc.edu.eg');
  $scope.newProject = {
    name: '',
    language: 'J',
    tests: []
  };

  $scope.uploadProgress = {
    completed: 0,
    on: false
  };

  $scope.alert = null;

  $scope.createProject = function() {

    if ($scope.newProject.tests && $scope.newProject.tests.length == 0) {
      // A project without tests
      Project.create({
        courseName: $routeParams.courseName
      }, $scope.newProject, function(newProject) {
        $scope.newProject = {
          name: '',
          language: 'J'
        };
        $scope.projects.push(newProject);
      });
    } else {
      $scope.uploadProgress.completed = 0;
      $scope.uploadProgress.on = true;
      $upload.upload({
        url: 'http://api.evaluator.in' + window.decodeURIComponent($scope.course.projects_url),
        method: 'POST',
        headers: {
          'X-Auth-Token': 'Replace Me'
        },
        data: {
          name: $scope.newProject.name,
          language: $scope.newProject.language
        },
        file: $scope.newProject.tests
      }).progress(function(evt) {
        $scope.uploadProgress.completed = 100.0 * evt.loaded / evt.total;
      }).success(function(data, status, headers, config) {
        $scope.alert = {
          message: 'Project Created!',
          type: 'alert-success'
        };
        $scope.projects.push(data);
      }).error(function(data, status, headers, config) {
        $scope.alert = {
          message: 'Something went horribly wrong!',
          type: 'alert-warning'
        };
      });
    }
  }

  var teachersCtrl = function() {

    $scope.teachers = User.query_relation({
        ep: window.decodeURIComponent($scope.course.tas_url)
      },
      function(teachers) {
        $scope.loaded = true;
      },
      function(httpResponse) {
        if (httpResponse.status == 403) {
          Page.setErrorMessage('Must be logged in to view course members.');
          $location.path('/403').replace();
        } else if (httpResponse.status == 404) {
          $location.path('/404').replace();
        }
      });


  };

  var studentsCtrl = function() {
    $scope.students = User.query_relation({
      ep: window.decodeURIComponent($scope.course.students_url)
    }, function(students) {
      $scope.loaded = true;
    }, function(httpResponse) {
      if (httpResponse.status == 403) {
        Page.setErrorMessage('Must be logged in to view course members.');
        $location.path('/403').replace();
      } else if (httpResponse.status == 404) {
        $location.path('/404').replace();
      }
    });
  };

  var courseSuccessFactory = function(toCall) {
    // calls parameter when course is loaded.
    return function(course) {
      $scope.course = course;
      toCall();
    };
  };

  $scope.ep = $routeParams.ep;
  var helperCtrl = null;
  switch ($scope.ep) {
    case 'projects':
      helperCtrl = projectCtrl;
      break;
    case 'tas':
      helperCtrl = teachersCtrl;
      break;
    case 'students':
      helperCtrl = studentsCtrl;
      break;
    default:
      Page.setErrorMessage('Unknown relation ' + $routeParams.ep);
      $location.path('/404').replace();
  };

  $scope.course = Course.get({
    name: $routeParams.courseName
  }, courseSuccessFactory(helperCtrl));

  $('body').on('click', '#alertDismiss', function() {
    $scope.alert = null;
  });
}]);