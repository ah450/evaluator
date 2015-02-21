jprApp.controller('CourseProjectsCtrl', ['$scope', 'Auth', 'Page', '$location', function($scope, Auth, Page, $location) {
  $scope.isTeacher = Auth.isLoggedIn() ? Auth.getUser().isTeacher() : false;
  $scope.loaded = false;
  $scope.creating = false;
  $scope.nameError = false;
  $scope.dateError = false;
  $scope.timeoutError = false;
  $scope.newProject = {
    name: '',
    language: 'J',
    tests: [],
    due_date: new Date(),
    published: true,
    test_timeout: 600,
    validate: function(){
      var allClear = true;
      if(this.name.length < 5 ) {
        Page.addErrorMessage('Project name must be at least five characters long.');
        $scope.nameError = true;
        allClear = false;
      }
      if(typeof this.due_date.toISOString !== 'function') {
        allClear = false;
        $scope.dateError = true;
      }
      if(this.test_timeout < 600 || this.test_timeout > 1800) {
        Page.addErrorMessage('Test Timout must be between 600 and 1800 inclusive.');
        $scope.timeoutError = true;
        allClear = false;
      }
      return allClear;
    }
  };
  $scope.showCreation = $scope.$parent.showCreation;
  $scope.projects = [];
  
  // handle success on loading projects
  function projectsSuccesCallback(projects) {
    $scope.projects = projects;
    $scope.loaded = true;
  }

  // Handle fail on loading projects
  function projectsFailureCallback(httpResponse) {
    $scope.loaded = true;
    if ($scope.$parent.redirect) {
      if (httpResponse.status == 403) {
        Page.setErrorFlash('Must be a course teacher or student to view projects.');
        $location.path('/403').replace();
      } else if (httpResponse.status == 404) {
        $location.path('/404').replace();
      } else if(httpResponse.status == 401) {
        Page.setErrorFlash('Must be logged in to view course projects.');
        $location.path('/home').replace();
      } else {
        Page.addErrorMessage('Internal server oopsie, please grab a programmer.');
      }
    } else {
      if (httpResponse.status == 403) {
        // Nothing!
      } else if (httpResponse.status == 404) {
        Page.addErrorMessage('Course not found.');
      } else if(httpResponse.status == 401) {
        Page.addErrorMessage('Must be logged in to view course projects.');
      } else {
        Page.addErrorMessage('Internal server oopsie, please grab a programmer.');
      }
    }
  };
  // load projects
  $scope.$parent.course.projects
    .then(projectsSuccesCallback, projectsFailureCallback);

  $scope.createProject = function() {
    Page.clearErrorMessages();
    $scope.nameError = false;
    $scope.dateError = false;
    $scope.timeoutError = false;
    if (!$scope.newProject.validate()) {
      return;
    }
    $scope.creating = true;
    var oldDate = $scope.newProject.due_date;
    var oldPublished = $scope.newProject.published;
    $scope.newProject.due_date = oldDate.toISOString();
    $scope.$parent.course.create_project($scope.newProject, function(project) {
      $scope.creating = false;
      $scope.projects.push(project);
      Page.addInfoMessage('Project Created!');
    }, function(httpResponse) {
      $scope.creating = false;
      $scope.newProject.due_date = oldDate;
      $scope.newProject.published = oldPublished;
      if (httpResponse.status == 403) {
        Page.addErrorMessage('Must be a course teacher to create a project.');
      }else  {
        Page.addErrorMessage(httpResponse.data.message);
      }
    });
  };

}]);