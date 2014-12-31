jprApp.controller('ProjectCtrl', ['$scope', '$routeParams', '$upload', '$location', 'Page', 'Auth', 'Project', function($scope, $routeParams, $upload, $location, Page, Auth, Project) {
  Page.setLink('');
  Page.clearErrorMessage();
  Page.clearTitle();
  if (!Auth.isLoggedIn()) {
    Page.setErrorMessage('Must be a course teacher or student to view projects.');
    $location.path('/403').replace();
  }
  $scope.isStudent = Auth.getUser().email.endsWith('@student.guc.edu.eg');
  $scope.loaded = false;
  $scope.alert = null;
  $scope.project = Project.get({
      id: $routeParams.id
    }, function(data) {
      data.created_at = moment(data.created_at).format("dddd, MMMM Do YYYY, h:mm:ss a");
      $scope.project = data;
      Page.setSection($scope.project.name);
      Project.get_submissions(
        {
          courseName: $scope.project.course.name,
          projectName: $scope.project.name

        }, function(submissions){
          submissions.forEach(function(subm) {
            subm.created_at = moment(subm.created_at).format("dddd, MMMM Do YYYY, h:mm:ss a");
          });
          $scope.project.submissions = submissions;
          $scope.loaded = true;
        }, function(httpResponse){
          $scope.alert = {
            message: 'Something went horribly wrong!',
            type: 'alert-warning'
          };
        });
      },
    function(httpResponse) {
      // Project fail
      if (httpResponse == 403 || httpResponse == 401) {
        Page.setErrorMessage('Must be a course teacher or student to view projects.');
        $location.path('/403').replace();
      }
    });
    
    $scope.uploadProgress = {
      completed: 0,
      on: false
    };
    $scope.code = {
      file: null
    }
    $scope.submitCode = function() {
      $scope.uploadProgress.completed = 0;
      $scope.uploadProgress.on = true;
      $upload.upload({
        url: 'http://178.62.98.209:8080' + window.decodeURIComponent($scope.project.submissions_url),
        method: 'POST',
        headers: {
          'X-Auth-Token': 'Replace Me'
        },
        file: $scope.code.file
      }).progress(function(evt){
        $scope.uploadProgress.completed = 100.0 * evt.loaded / evt.total;
      }).success(function(data, status, headers, config){
        $scope.alert = {
          message: 'Code Submitted!',
          type: 'alert-success'
        };
        data.created_at = moment(data.created_at).format("dddd, MMMM Do YYYY, h:mm:ss a");
        $scope.project.submissions.push(data)
      }).error(function(data, status, headers, config){
        $scope.alert = {
          message: 'Something went horribly wrong!',
          type: 'alert-warning'
        };
      });
    };


}]);