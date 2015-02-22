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
    $scope.currentPage = 1;
    $scope.due_date = new Date();
    $scope.code = {
        file: null
    };

    //Pagination variables
    $scope.submissionsPerPage = Project.submissionsPerPage;
    $scope.totalSubmissions = 0;


    Project.$get($routeParams.id)
        .then(projectLoadSuccessCallback, projectLoadFailureCallback);

    $scope.loadSubmissionsPage = function(page) {
        $scope.loadingSubmissions = true;
        $scope.submissions = []; // clear
        $scope.project.getSubmissionsPage(page).then(function(submissionPage) {
            $scope.loadingSubmissions = false;
            $scope.submissions = submissionPage.submissions;
            $scope.totalSubmissions = submissionPage.pages * $scope.submissionsPerPage;
        }, function(data, status, headers, config) {
            $scope.loadingSubmissions = false;
            Page.addErrorMessage(data.message);
        });
    };

    function projectLoadSuccessCallback(project) {
        $scope.project = project;
        $scope.loaded = true;
        Page.hideSpinner();
        $scope.loadSubmissionsPage(1);
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
        $scope.loadingSubmissions = false;
        Page.clearInfoMessages();
        Page.addInfoMessage('Code Submitted!');
        $scope.submissions.unshift(submission);
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
            case 400:
                msg = data.message;
                break;
            default:
                msg = 'Server woopsy, please grab a programmer';
        }
        Page.addErrorMessage(msg);
    }

    $scope.submitCode = function() {
        var file = $scope.code.file;
        $scope.code = {
            file: null
        };
        $scope.project.submitCode(file, submissionSuccessCallback, submissionFailureCallback);

    };

    $scope.updateDate = function(newDate, oldDate) {
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

    $scope.countPassed = function(cases) {
        return cases.reduce(function(c, tcase) {
            return (tcase.passed) ? c + 1 : c;
        }, 0);
    };



}]);
