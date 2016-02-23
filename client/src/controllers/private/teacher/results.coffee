angular.module 'evaluator'
  .controller 'TeacherResultsController', ($scope, ProjectSubmissionsResource,
    CoursesResource, CourseProjectsResource, Pagination, Submission,
    defaultPageSize, deletedSubmissionIds) ->
      $scope.loadingSubmissions = false
      # Data used by the search form
      $scope.formData = {}

      # data used for searching for submissions
      $scope.submissionParams =
        project_id: null

      $scope.submissionClasses = ['submission-accent-one',
        'submission-accent-two', 'submission-accent-three']

      $scope.submissions = []

      deletedSubmissionCallback = (id) ->
        deletedSubmissionIds.push id
        _.remove $scope.submissions, (submission) ->
          submission.id is id

      $scope.courseSearch = (nameQuery) ->
        CoursesResource.query({
          name: nameQuery,
          page: 1,
          page_size: 100
        }).$promise.then (data) ->
          data.courses

      $scope.projectSearch = (nameQuery, course) ->
        CourseProjectsResource.query({
          course_id: course.id,
          page: 1,
          page_size: 100,
          name: nameQuery
        }).$promise.then (data) ->
          data.projects

      submissionFactory = (data) ->
        return new Submission data, deletedSubmissionCallback

      addSubmissionsCallback = (newSubmissions) ->
        submissions = _.filter newSubmissions, (s) ->
          s.id not in deletedSubmissionIds
        args = [0, $scope.submissions.length].concat submissions
        $scope.submissions.splice.apply $scope.submissions, args
      
      $scope.submissionsPagination =
        new Pagination ProjectSubmissionsResource, 'submissions',
          $scope.submissionParams,
          submissionFactory, defaultPageSize

      $scope.reload = ->
        return if $scope.loadingSubmissions
        $scope.loadingSubmissions = true
        $scope.submissionsPagination.reload().then (submissions) ->
          $scope.loadingSubmissions = false
          addSubmissionsCallback submissions

      loadSubmissionsPage = (page) ->
        $scope.loadingSubmissions = true
        $scope.submissionsPagination.page(page).then (submissions) ->
          $scope.loadingSubmissions = false
          $scope.currentPage = page
          addSubmissionsCallback submissions

      $scope.currentPage = 1

      $scope.selectProject = (project) ->
        if project
          $scope.currentPage = 1
          $scope.submissionParams.project_id = project.id
          $scope.reload()
        else
          $scope.submissionParams.project_id = null

      $scope.backDisabled = ->
        $scope.currentPage is 1

      $scope.nextDisabled = ->
        $scope.currentPage >= $scope.submissionsPagination.totalPages

      $scope.next = ->
        if not $scope.nextDisabled()
          loadSubmissionsPage($scope.currentPage + 1)

      $scope.back = ->
        if not $scope.backDisabled()
          loadSubmissionsPage($scope.currentPage - 1)


