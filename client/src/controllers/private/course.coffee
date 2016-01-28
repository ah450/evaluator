angular.module 'evaluator'
  .controller 'CourseController', ($scope, CoursesResource, $stateParams,
    UserAuth, CourseProjectsResource, defaultPageSize, Pagination, ngDialog) ->

    $scope.isTeacher = UserAuth.user.teacher
    $scope.canAddProject = $scope.isTeacher

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


    projectsPagination = new Pagination CourseProjectsResource, 'projects',
    {course_id: $stateParams.id}, _.identity, defaultPageSize

    ids = []
    $scope.projects = []
    $scope.projectClasses = ['project-accent-one', 'project-accent-two',
    'project-accent-three']

    # Add projects to $scope.projects at begin (index)
    addProjectsCallback = (newProjects, begin) ->
      projects = _.filter newProjects, (project) ->
        project.id not in ids
      Array::push.apply ids, _.map projects, 'id'
      args = [begin, 0].concat projects
      $scope.projects.splice.apply $scope.projects, args

    $scope.loadingProjects = true
    # Load first page
    projectsPagination.page(1).then (data) ->
      $scope.loadingProjects = false
      addProjectsCallback data, $scope.projects.length

    # Callback for infinite scroll
    $scope.loadMore = ->
      $scope.scrollDisabled = true
      $scope.loadingProjects = true
      page = if projectsPagination.pageSize < defaultPageSize then \
        projectsPagination.currentPage else projectsPagination.currentPage + 1
      projectsPagination.page(page)
        .then (projects) ->
          $scope.loadingProjects = false
          addProjectsCallback projects, $scope.projects.length
          $scope.scrollDisabled = false


    $scope.newProjectData = {}

    $scope.showAddDialog = ->
      return if $scope.newProjectDialog && ngDialog.isOpen($scope.newProjectDialog.id)
      $scope.newProjectData = {}
      $scope.projectCreateError = ''
      $scope.newProjectDialog = ngDialog.open
        template: 'private/create/project.html'
        scope: $scope

    $scope.submit = ->
      return if $scope.processingProject
      $scope.processingProject = true
      project = new CourseProjectsResource $scope.newProjectData
      project.course_id = $stateParams.id
      success = (project) ->
        $scope.newProjectDialog.close()
        $scope.processingProject = false
        addProjectsCallback [project], 0
      failure = (response) ->
        if response.status is 422
          $scope.projectCreateError = ("#{key.capitalize()} #{value}." for key, value of response.data)
            .join ' '
          $scope.processingProject = false
        else
          $scope.projectCreateError = response.data.message.capitalize
          $scope.processingProject = false
      project.$save success, failure



