jprApp.controller('CourseRelatedCtrl', ['$scope', '$routeParams', '$location', '$upload', 'Auth', 'Page', 'Project', 'Course', function($scope, $routeParams, $location, $upload, Auth, Page, Project, Course) {
  Page.setLink('course-related');
  $scope.isLoggedIn = Auth.isLoggedIn;
  $scope.loaded = false;
  $scope.redirect = true;
  $scope.ep = $routeParams.ep;
  $scope.showCreation = true;
  $scope.isStudent = $scope.isLoggedIn()? Auth.getUser().isStudent() : false;
  switch ($scope.ep) {
    case 'projects':
      $scope.sectionep = 'Projects';
      break;
    case 'tas':
      $scope.sectionep = 'Teachers';
      break;
    case 'students':
      $scope.sectionep = 'Students';
      break;
    default:
      Page.setErrorMessage('Unknown relation ' + $scope.ep);
      $location.path('/404').replace();
  };
  Page.setSection($routeParams.courseName + ' ' + $scope.sectionep);
  $scope.loaded = false;
  Course.$get($routeParams.courseName)
    .then(function(course) {
      $scope.course = course;
      $scope.loaded = true;
    });
}]);