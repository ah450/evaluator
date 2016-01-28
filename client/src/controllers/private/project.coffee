angular.module 'evaluator'
  .controller 'ProjectController', ($scope, $stateParams, ProjectResource,
    UserAuth) ->

    $scope.isTeacher = UserAuth.user.teacher
    $scope.canAddSuite = $scope.isTeacher

    projectPromise = ProjectResource.get(
        id: $stateParams.id
      ).$promise

    $scope.loading = true
    projectPromise.then (project) ->
      $scope.project = project
      $scope.loading = false

    $scope.publish = ->
      $scope.loading = true
      $scope.project.published = true
      $scope.project.$update().then ->
        $scope.loading = false
