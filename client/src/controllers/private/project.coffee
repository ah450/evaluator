angular.module 'evaluator'
  .controller 'ProjectController', ($scope, $stateParams, ProjectResource,
    UserAuth, ProjectSuitesResource, defaultPageSize, Pagination, ngDialog,
    Upload, endpoints, Project, Suite) ->

    $scope.isTeacher = UserAuth.user.teacher
    $scope.canAddSuite = $scope.isTeacher

    projectPromise = ProjectResource.get(
        id: $stateParams.id
      ).$promise

    $scope.loading = true
    projectPromise.then (project) ->
      $scope.project = new Project project
      $scope.canAddSuite &= !$scope.project.published
      $scope.loading = false

    $scope.publish = ->
      $scope.loading = true
      $scope.project.published = true
      $scope.project.$update().then ->
        $scope.loading = false

    $scope.unpublish = ->
      $scope.loading = true
      $scope.project.published = false
      $scope.project.$update().then ->
        $scope.loading = false

    suiteFactory = (data) ->
      new Suite data

    suitesPagination = new Pagination ProjectSuitesResource, 'test_suites',
    {project_id: $stateParams.id}, suiteFactory, defaultPageSize

    ids = []
    $scope.suites = []
    $scope.suiteClasses = ['suite-accent-one', 'suite-accent-two',
    'suite-accent-three']

    addSuitesCallback = (newSuites, begin) ->
      suites = _.filter newSuites, (suite) ->
        suite.id not in ids
      Array::push.apply ids, _.map suites, 'id'
      args = [begin, 0].concat suites
      $scope.suites.splice.apply $scope.suites, args

    $scope.loadingSuites = true

    # Load first page
    suitesPagination.page(1).then (data) ->
      $scope.loadingSuites = false
      addSuitesCallback data, $scope.suites.length

    # Callback for infinite scroll
    $scope.loadMore = ->
      $scope.scrollDisabled = true
      $scope.loadingSuites = true
      page = if suitesPagination.pageSize < defaultPageSize then \
        suitesPagination.currentPage else suitesPagination.currentPage + 1
      suitesPagination.page(page)
        .then (suites) ->
          $scope.loadingSuites = false
          addSuitesCallback suites, $scope.suites.length
          $scope.scrollDisabled = false


    $scope.newSuiteData = {}

    $scope.showAddDialog = ->
      return if $scope.newSuiteDialog && ngDialog.isOpen($scope.newSuiteDialog.id)
      $scope.newSuiteData = {}
      $scope.suiteCreateError = ''
      $scope.newSuiteDialog = ngDialog.open
        template: 'private/create/suite.html'
        scope: $scope

    $scope.submit = ->
      return if $scope.processingSuite
      $scope.processingSuite = true
      
      success = (response) ->
        $scope.newSuiteDialog.close()
        $scope.processingSuite = false
        suite = new Suite response.data
        addSuitesCallback [suite], 0
      failure = (response) ->
        if response.status is 422
          $scope.suiteCreateError = ("#{key.capitalize()} #{value}." for key, value of response.data)
            .join ' '
          $scope.processingSuite = false
        else
          $scope.suiteCreateError = response.data.message.capitalize
          $scope.processingSuite = false
      Upload.upload(
        url: endpoints.projectSuites.resourceUrl.replace(':project_id', $stateParams.id)
        data: $scope.newSuiteData
      ).then(success, failure)

