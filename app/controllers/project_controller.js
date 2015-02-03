jprApp.controller('ProjectCtrl', ['$scope', '$routeParams', '$upload', '$location', 'Page', 'Auth', 'Project', 'Host', function($scope, $routeParams, $upload, $location, Page, Auth, Project, Host) {
    Page.setLink('');
    Page.clearTitle();
    $scope.Host = Host;
    if (!Auth.isLoggedIn()) {
        Page.setErrorFlash('Must be a course teacher or student to view projects.');
        $location.path('/403').replace();
    }
    $scope.isStudent = Auth.isLoggedIn() ? Auth.getUser().isStudent() : false;
    $scope.isTeacher = Auth.isLoggedIn() ? Auth.getUser().isTeacher() : false;
    $scope.submissions = [];
    $scope.loaded = false;
    $scope.updating = false;
    $scope.due_date = new Date();
    $scope.code = {
        file: null
    };
    $scope.downloadHandler = Page.downloadHandler;
    Page.showSpinner();
    Project.$get($routeParams.id)
        .then(projectLoadSuccessCallback, projectLoadFailureCallback);

    function projectLoadSuccessCallback(project) {
        project.submissions.then(function(submissions) {
            Page.hideSpinner();
            $scope.loaded = true;
            $scope.submissions = submissions;
        }, projectLoadFailureCallback);

        $scope.project = project;
        // $scope.due_date = project.due_date;
        Page.setSection($scope.project.name);
    }

    function projectLoadFailureCallback(httpResponse) {
        Page.hideSpinner();
        if (httpResponse.status == 403 || httpResponse.status == 401) {
            Page.setErrorFlash('Must be a course teacher or student to view projects.');
            $location.path('/403').replace();
        } else if (httpResponse.status == 404) {
            $location.path('/404').replace();
        }
    }

    function submissionSuccessCallback(submission) {
        Page.addInfoMessage('Code Submitted!');
        $scope.submissions.push(submission);
    }

    function submissionFailureCallback(data, status, headers, config) {
        var msg = '';
        switch (status) {
            case 403:
                msg = 'You need to be a student';
                break;
            case 401:
                msg = 'You need to loggin';
                break;
            case 498:
                msg = 'You passed the Due-date deadline';
                break;
            default:
                msg = 'Server woopsy, please grab a programmer';
        }
        $scope.addErrorMessage(msg);
    }

    $scope.submitCode = function() {
        $scope.project.submitCode($scope.code.file, submissionSuccessCallback, submissionFailureCallback);
    };


    $scope.updateProject = function() {
    Page.clearErrorMessages();

    $scope.updating = true;
    $scope.project.due_date = $scope.due_date;
    $scope.project.update_project($scope.project, function(project) {
      $scope.updating = false;
      $scope.project = project;
      Page.addInfoMessage('Project Updated!');
    }, function(httpResponse) {
      $scope.creating = false;
      if (httpResponse.status == 403) {
        Page.addErrorMessage('Must be a course teacher to update a project.');
      } else  {
        Page.addErrorMessage(httpResponse.data.message);
      }
    });
  };



}]);
