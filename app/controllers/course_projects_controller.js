jprApp.controller('CourseProjectsCtrl', ['$scope', '$upload', 'Auth', 'Page', function($scope, $upload, Auth, Page) {
  $scope.isTeacher = Auth.isLoggedIn() ? Auth.getUser().isTeacher() : false;
  $scope.loaded = false;
  $scope.newProject = {
    name: '',
    language: 'J',
    tests: []
  };
  $scope.alert = null;
  $scope.showCreation = $scope.$parent.showCreation;
  $scope.projects = [];
  var projectsSuccesCallback = function(projects) {
    $scope.projects = projects;
    $scope.loaded = true;
  };

  var projectFailureCallback = function(httpResponse) {
    $scope.$parent.loaded = true;
    $scope.loaded = true;
    if ($scope.$parent.redirect) {
      if (httpResponse.status == 403) {
        Page.setErrorMessage('Must be a course teacher or student to view projects.');
        $location.path('/403').replace();
      } else if (httpResponse.status == 404) {
        $location.path('/404').replace();
      }
    }
  };
  $scope.$parent.course.projects
    .then(projectsSuccesCallback, projectFailureCallback);
  $scope.createProject = function() {
    if ($scope.newProject.tests) {
      $scope.$parent.course.create_project($scope.newProject, function(project) {
        $scope.projects.push(project);
        $scope.alert = {
          message: 'Project Created!',
          type: 'alert-success'
        };
      }, function(httpResponse) {
        $scope.alert = {
          message: 'Something went horribly wrong!',
          type: 'alert-warning'
        };
      });
    }
  }
  $('body').on('click', '#alertDismiss', function() {
    $scope.alert = null;
  });
}]);