jprApp.controller('ProjectCtrl', ['$scope', '$routeParams', '$upload', '$location', 'Page', 'Auth', 'Project', 'Host', function($scope, $routeParams, $upload, $location, Page, Auth, Project, Host) {

    if (!Auth.isLoggedIn()) {
        // Not on my watch!
        Page.setErrorFlash('Must be a course teacher or student to view projects.');
        $location.path('/403').replace();
    } else {
        $scope.user = Auth.getUser();
        $scope.isStudent = $scope.user.isStudent();
        // because lots of ! look silly
        $scope.isTeacher = !$scope.isStudent;
    }
    Page.setLink('');
    Page.clearTitle();
    // Function that shows save file dialog for a link
    // does an AJAX request for the download
    $scope.downloadHandler = Page.downloadHandler;
    // Loading....
    Page.showSpinner();
    $scope.loaded = false;
    // Variable used to show spinner for course edit
    $scope.updating = false;

    $scope.due_date = new Date();
    $scope.code = {
        file: null
    };

    //Pagination variables
    $scope.submissionsPerPage = Project.submissionsPerPage;
    $scope.totalSubmissions = 0;


    Project.$get($routeParams.id)
        .then(projectLoadSuccessCallback, projectLoadFailureCallback);

    function loadSubmissionsPage(page){
        $scope.project.getSubmissionsPage(1).then(function(submissionPage) {
            Page.hideSpinner();
            $scope.loaded = true;
            $scope.submissions = submissionPage.submissions;
            $scope.totalSubmissions = submissionPage.pages * $scope.submissionsPerPage;
        }, submissionFailureCallback);
    }

    function projectLoadSuccessCallback(project) {
        $scope.project = project;
        loadSubmissionsPage(1);
        $scope.due_date = project.due_date;
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

    $scope.updateDate = function (newDate, oldDate) {
        $scope.project.due_date = newDate;
    };

    $scope.updateProject = function() {
        Page.clearErrorMessages();

        $scope.updating = true;
        $scope.project.update_project($scope.project, function(project) {
            $scope.updating = false;
            $scope.project = project;
            Page.addInfoMessage('Project Updated!');
        }, function(httpResponse) {
            $scope.creating = false;
            if (httpResponse.status == 403) {
                Page.addErrorMessage('Must be a course teacher to update a project.');
            } else {
                Page.addErrorMessage(httpResponse.data.message);
            }
        });
    };



}]);
