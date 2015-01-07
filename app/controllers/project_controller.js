jprApp.controller('ProjectCtrl', ['$scope', '$routeParams', '$upload', '$location', 'Page', 'Auth', 'Project', function($scope, $routeParams, $upload, $location, Page, Auth, Project) {
  Page.setLink('');
  Page.clearErrorMessage();
  Page.clearTitle();
  if (!Auth.isLoggedIn()) {
    Page.setErrorMessage('Must be a course teacher or student to view projects.');
    $location.path('/403').replace();
  }
  $scope.isStudent = Auth.isLoggedIn() ? Auth.getUser().isStudent() : false;
  $scope.submissions = [];
  $scope.loaded = false;
  $scope.alert = null;
  $scope.code = {
    file: null
  }

  Project.$get($routeParams.id)
    .then(projectLoadSuccessCallback, ProjectLoadFailureCallback);

  function projectLoadSuccessCallback(project) {
    $scope.project = project;
    Page.setSection($scope.project.name);
  }

  function projectLoadFailureCallback(httpResponse) {
    if (httpResponse.status == 403 || httpResponse.status == 401) {
      Page.setErrorMessage('Must be a course teacher or student to view projects.');
      $location.path('/403').replace();
    } else if (httpResponse.status == 404) {
      $location.path('/404').replace();
    }
  }

  function submissionSuccessCallback(submission) {
    $scope.alert = {
      message: 'Code Submitted!',
      type: 'alert-success'
    };
    $scope.submissions.push(submission);
  }

  function submissionFailureCallback(data, status, headers, config) {
    $scope.alert = {
      message: 'Something went horribly wrong!',
      type: 'alert-warning'
    };
  }

  $scope.submitCode = function() {
    $scope.project.submitCode($scope.code.file, submissionSuccessCallback, submissionFailureCallback);
  };

  $('body').on('click', '#projectAlertDismiss', function() {
    $scope.alert = null;
  });

}]);