jprApp.controller('DashboardCtrl', ['$scope', '$http', '$location', 'Auth', 'Page', 'Course', function ($scope, $http, $location, Auth, Page, Course) {
    $scope.loading_courses = true;
    $scope.loading_projects = true;
    $scope.loading_teamgrades = true;
    $scope.projects = [];
    $scope.courses = [];
    $scope.teamGrades = [];
    $scope.quizGrades = [];
    $scope.milstoneGrades = [];
    $scope.isLoggedIn = Auth.isLoggedIn;
    $scope.user = Auth.getUser();



    function loadGrades(){
        $scope.user.grades().then(function (grades) {
            $scope.loading_teamgrades = false;
            $scope.teamGrades = grades.team_grades;
            $scope.quizeGrades = grades.quiz_grades;
            $scope.milestoneGrades = grades.milestone_grades;
        }, function(httpResponse) {
            $scope.loading_teamgrades = false;
            Page.addErrorMessage(httpResponse.data.message);
        });
    }
    loadGrades();

    function myCoursesSuccessCallback(courses) {
        $scope.loading_courses = false;

        $scope.courses = courses.map(function (course) {
            return new Course(course, true);
        });
        loadProjects();
    }

    function loadProjects() {
        if($scope.courses.length == 0){
            $scope.loading_projects = false;
        }else {
            $scope.courses.forEach(function (course, index, array) {
                var successCallback = function(projects){
                    projects.forEach(function(project) {
                        $scope.projects.push(project);
                    });
                    if(index == (array.length - 1)){
                        $scope.loading_projects = false;
                    }
                }
                course.projects
                .then(successCallback, function(httpResponse) {
                    Page.addErrorMessage('Failed to load projects for ' + course.name);
                });
            });
        }
    }

    function myCoursesFailureCallback(httpResponse) {
        $scope.loading_courses = false;
        $scope.loading_projects = false;
        Page.addErrorMessage('Server oopsie, please grab a programmer.');
    }

    function loadCourses(){
        Page.clearErrorMessages();
        $scope.user.courses().then(myCoursesSuccessCallback, myCoursesFailureCallback);
    }
    loadCourses();

    $scope.$watch("isLoggedIn()", function(newValue, oldValue) {
        if(newValue) {
            $scope.user = Auth.getUser();
            $scope.loading_courses = true;
            $scope.loading_projects = true;
            $scope.courses = [];
        }else {
            $location.path('/home').replace();
        }
    });


}]);