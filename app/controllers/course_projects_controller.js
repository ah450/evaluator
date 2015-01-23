jprApp.controller('CourseProjectsCtrl', ['$scope', '$upload', 'Auth', 'Page', function($scope, $upload, Auth, Page) {
  $scope.isTeacher = Auth.isLoggedIn() ? Auth.getUser().isTeacher() : false;
  $scope.loaded = false;
  $scope.creating = false;
  $scope.newProject = {
    name: '',
    language: 'J',
    tests: [],
    due_date: Date.now();
  };
  $scope.showCreation = $scope.$parent.showCreation;
  $scope.projects = [];
  var projectsSuccesCallback = function(projects) {
    $scope.projects = projects;
    $scope.loaded = true;
  };

  var projectsFailureCallback = function(httpResponse) {
    $scope.loaded = true;
    if ($scope.$parent.redirect) {
      if (httpResponse.status == 403) {
        Page.setErrorFlash('Must be a course teacher or student to view projects.');
        $location.path('/403').replace();
      } else if (httpResponse.status == 404) {
        $location.path('/404').replace();
      } else {
        Page.addErrorMessage('Internal server oopsie, please grab a programmer.');
      }
    } else {
      if (httpResponse.status == 403) {
        Page.addErrorMessage('Must be a course teacher or student to view projects.');
      } else if (httpResponse.status == 404) {
        Page.addErrorMessage('Course not found.');
      } else {
        Page.addErrorMessage('Internal server oopsie, please grab a programmer.');
      }
    }
  };
  $scope.$parent.course.projects
    .then(projectsSuccesCallback, projectsFailureCallback);
  $scope.createProject = function() {
    $scope.creating = true;
    $scope.$parent.course.create_project($scope.newProject, function(project) {
      $scope.creating = false;
      $scope.projects.push(project);
      Page.addInfoMessage('Project Created!');
    }, function(httpResponse) {
      $scope.creating = false;
      if (httpResponse.status == 403) {
        Page.addErrorMessage('Must be a course teacher to create a project.');
      }else  {
        Page.addErrorMessage(httpResponse.data.message);
      }
    });
  };

}]);