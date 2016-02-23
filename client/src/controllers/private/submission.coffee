angular.module 'evaluator'
  .controller 'SubmissionsController', ($scope, $stateParams, ProjectResource,
    ProjectSubmissionsResource, Pagination, defaultPageSize, Submission,
    ngDialog, Upload, endpoints, UserAuth) ->

      $scope.loading = true
      projectPromise = ProjectResource.get(
        id: $stateParams.project_id
        ).$promise
      projectPromise.then (project) ->
        $scope.project = project
        $scope.loading = false

      $scope.submissions = []
      $scope.submissionClasses = ['submission-accent-one',
        'submission-accent-two', 'submission-accent-three']

      deletedSubmissionCallback = (id) ->
        _.remove $scope.submissions, (submission) ->
          submission.id is id

      submissionFactory = (data) ->
        new Submission data, deletedSubmissionCallback

      submissionsPagination = new Pagination ProjectSubmissionsResource,
        'submissions',
        {project_id: $stateParams.project_id,
        submitter_id: UserAuth.user.id
        }, submissionFactory, defaultPageSize

      addSubmissionsCallback = (newSubmissions) ->
        args = [0, $scope.submissions.length].concat newSubmissions
        $scope.submissions.splice.apply $scope.submissions, args

      addNewSubmission = (submission) ->
        $scope.submissions.splice 0, 0, submission

      $scope.loadingSubmissions = true

      

      $scope.currentPage = 1

      loadSubmissionsPage = (page) ->
        submissionsPagination.page(page).then (submissions) ->
          $scope.loadingSubmissions = false
          $scope.currentPage = page
          addSubmissionsCallback submissions

      # Load first page
      loadSubmissionsPage $scope.currentPage

      $scope.backDisabled = ->
        $scope.currentPage == 1

      $scope.nextDisabled = ->
        $scope.currentPage >= submissionsPagination.totalPages


      $scope.next = ->
        if not $scope.nextDisabled()
          loadSubmissionsPage($scope.currentPage + 1)
      $scope.back = ->
        if not $scope.backDisabled()
          loadSubmissionsPage($scope.currentPage - 1)

      $scope.newSubmissionData = {}


      $scope.submit = ->
        return if $scope.processingSubmission
        $scope.processingSubmission = true
        failure = (response) ->
          if response.status is 422
            $scope.submissionCreateError =
              ("#{key.capitalize()} #{value}." for key, value of response.data)
              .join ' '
            $scope.processingSubmission = false
          else
            $scope.submissionCreateError = response.data.message.capitalize
            $scope.processingSubmission = false
          return response

        success = (response) ->
          submission = new Submission response.data
          $scope.newSubmissionDialog.close()
          $scope.processingSubmission = false
          addNewSubmission submission
        
        Upload.upload(
          url: endpoints.projectSubmissions.resourceUrl.replace(':project_id',
          $stateParams.project_id)
          data: $scope.newSubmissionData
        ).then(success, failure)


      $scope.showAddDialog = ->
        return if $scope.newSubmissionDialog &&
          ngDialog.isOpen($scope.newSubmissionDialog)
        $scope.newSubmissionData = {}
        $scope.submissionCreateError = ''
        $scope.newSubmissionDialog = ngDialog.open
          template: 'private/create/submission.html'
          scope: $scope





