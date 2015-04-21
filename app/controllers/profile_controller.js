jprApp.controller('ProfileCtrl', ['$scope', '$routeParams', 'Page', 'User', 'Validators', 'Auth', 'Submission','Host','$http', function($scope, $routeParams, Page, User, Validators, Auth, Submission, Host,$http) {
    Page.setLink('');
    Page.clearTitle();
    $scope.profile = {
        confirmpass: ""
    };
    $scope.currentUser = Auth.getUser();

    // Function that shows save file dialog for a link
    // does an AJAX request for the download
    $scope.downloadHandler = Page.downloadHandler;
    $scope.loaded = false;


    User.$get($routeParams.id)
        .then(function(user) {
            $scope.user = user;
            Page.setLink(user.name);
            Page.setSection(user.name);
            $scope.loaded = true;
            $scope.loadSubmissions();
        }, function(httpResponse) {
            Page.addErrorMessage(httpResponse.message);
        });

    $scope.isOwner = function() {
        return $scope.user.id === Auth.getUser().id;
    };

    $scope.changePassword = function() {
        var user = $scope.user;
        if (Validators.validatePassword(user.password) && Validators.validateSamePassword(user.password, $scope.profile.confirmpass)) {
            user.save(function(user) {
                $scope.user = user;
                Page.addInfoMessage("Password changed");
                $scope.profile.confirmpass = "";
            }, function(httpResponse) {
                Page.addErrorMessage(httpResponse.message);
            });
        } else {
            Page.addErrorMessage('password less than 8 characters or doesn\'t match');
        }
    };

    /**
     * Load Submissions for user id paginated
     * @param  {[type]} id   [description]
     * @return {[type]}      [description]
     */
    $scope.loadSubmissions = function() {
        $scope.loadingSubmissions = true;
        $scope.submissions = []; // clear
        $scope.user.getSubmissions().then(function(submissions) {
            $scope.loadingSubmissions = false;
            $scope.submissions = submissions.map(function(element) {
                return new Submission(element, true);
            });
        }, function(data, status, headers, config) {
            $scope.loadingSubmissions = false;
            Page.addErrorMessage(data.message);
        });
    };

    $scope.runSubmission = function(submission) {
        var url =  [Host.api_base, 'submission', submission.id, 'run'].join('/');
        var req = {
            method: 'GET',
            url: url,
            headers: {
                'X-Auth-Token': 'Replace Me'
            },
        };
        $http(req)
            .success(function(data) {
                console.log(data);
                submission.data = data;
            }).error(function (data) {
                Page.addErrorMessage(data.message);
            });
    };


}]);
