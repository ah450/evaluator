angular.module 'evaluator'
  .controller 'CoursesController', ($scope, $state, Pagination,
    ngDialog, CoursesResource, UserAuth, defaultPageSize) ->
    $scope.courses = []

    $scope.courseClasses = ['course-accent-one', 'course-accent-two',
    'course-accent-three']

    $scope.scrollDisabled = false
    $scope.loading = true
    $scope.newCourseData = {}
    $scope.courseCreateError = ''

    courseFactory = (data) ->
      new CoursesResource data

    coursesPagination = new Pagination CoursesResource, 'courses', {},
    courseFactory, defaultPageSize

    ids = []

    $scope.canAddCourses = UserAuth.user.teacher
    # Add courses to $scope.courses at begin (index)
    addCoursesCallback = (newCourses, begin) ->
      courses = _.filter newCourses, (course) ->
        course.id not in ids
      Array::push.apply ids, _.map courses, 'id'
      args = [begin, 0].concat courses
      $scope.courses.splice.apply $scope.courses, args

    # Load first page
    coursesPagination.page(1).then (data) ->
      $scope.loading = false
      addCoursesCallback data, $scope.courses.length

    # Callback for infinite scroll
    $scope.loadMore = ->
      $scope.scrollDisabled = true
      page = if coursesPagination.pageSize < defaultPageSize then \
        coursesPagination.currentPage else coursesPagination.currentPage + 1
      coursesPagination.page(page)
        .then (courses) ->
          addCoursesCallback courses, $scope.courses.length
          $scope.scrollDisabled = false

    $scope.showAddDialog = ->
      return if $scope.newCourseDialog && ngDialog.isOpen($scope.newCourseDialog.id)
      $scope.newCourseData = {}
      $scope.courseCreateError = ''

      $scope.newCourseDialog = ngDialog.open
        template: 'private/create/course.html'
        scope: $scope

    $scope.submit = ->
      return if $scope.processingCourse
      $scope.processingCourse = true
      course = new CoursesResource $scope.newCourseData
      success = (course) ->
        $scope.newCourseDialog.close()
        $scope.processingCourse = false
        addCoursesCallback [course], $scope.courses.length
      failure = (response) ->
        if response.status is 422
          $scope.courseCreateError = ("#{key.capitalize()} #{value}." for key, value of response.data)
            .join ' '
          $scope.processingCourse = false
        else
          $scope.roomCreateError = response.data.message.capitalize
          $scope.processingCourse = false
      course.$save success, failure
