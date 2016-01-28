angular.module 'evaluator'
  .controller 'CourseController', ($scope, CoursesResource, $stateParams,
    UserAuth) ->

    $scope.canPublish = UserAuth.user.teacher

    coursePromise = CoursesResource.get(
      id: $stateParams.id
    ).$promise


    $scope.loading = true
    coursePromise.then (course) ->
      $scope.course = course
      $scope.loading = false

    $scope.publish = ->
      $scope.loading = true
      $scope.course.published = true
      $scope.course.$update().then ->
        $scope.loading = false

