jprApp.controller('ProjectCtrl', ['$scope', '$routeParams', '$upload', '$location', 'Page', 'Auth', 'Project', function($scope, $routeParams, $upload, $location, Page, Auth, Project) {
    Page.setLink('');
    Page.clearTitle();
    if (!Auth.isLoggedIn()) {
        Page.setErrorFlash('Must be a course teacher or student to view projects.');
        $location.path('/403').replace();
    }
    $scope.isStudent = Auth.isLoggedIn() ? Auth.getUser().isStudent() : false;
    $scope.submissions = [];
    $scope.loaded = false;
    $scope.code = {
        file: null
    };
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



}]);
