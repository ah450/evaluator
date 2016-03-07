angular.module 'evaluator'
  .controller 'PortalController', ($scope, ngDialog, NotificationDispatcher,
    Upload, $state, endpoints, configurations, UserAuth, CoursesResource,
    CourseProjectsResource, $http, FileSaver) ->
      $scope.teamData = {}
      $scope.bundleData = {}
      $scope.isAdmin = UserAuth.user.admin
      $scope.globalLoading = false
      $scope.downloadResultsData = {}

      resetResultData = ->
        $scope.downloadResultsData.loading = false
        $scope.downloadResultsData.error = ''
        $scope.downloadResultsData.selectedCourse = undefined
        $scope.downloadResultsData.courseSearchText = undefined
        $scope.downloadResultsData.selectedProject = undefined
        $scope.downloadResultsData.projectSearchText = undefined

      resetBundleData = ->
        $scope.bundleData.processing = false
        $scope.bundleData.error = ''
        $scope.bundleData.selectedCourse = undefined
        $scope.bundleData.courseSearchText = undefined
        $scope.bundleData.selectedProject = undefined
        $scope.bundleData.projectSearchText = undefined
        $scope.bundleData.waiting = false
        $scope.bundleData.ready = false
        $scope.bundleData.bundle = undefined

      resetTeamData = ->
        $scope.teamData.processing = false
        $scope.teamData.processedPercentage = 0
        $scope.teamData.processed = 0
        $scope.teamData.total = 0
        $scope.teamData.messages = []

      $scope.showSetTeamsDialog = ->
        return if $scope.setTeamDialog && ngDialog.isOpen($scope.setTeamDialog)
        resetTeamData()
        $scope.setTeamDialog = ngDialog.open
          template: 'private/teacher/set_team.html'
          scope: $scope


      $scope.processTeams = ->
        return if $scope.teamData.processing
        $scope.teamData.processing = true
        success = (response) ->
          NotificationDispatcher.subscribeTeamJob response.data, (e) ->
            configurations.then (config) ->
              if e.type is config.notification_event_types.team_job_status
                status = e.payload.status
                $scope.teamData.messages = status.messages
                $scope.teamData.processed = status.processed
                $scope.teamData.processedPercentage =
                  status.processed / status.total_rows *100
                $scope.teamData.total = status.total_rows


        failure = (response) ->
          $state.go 'private.internal_error'

        Upload.upload(
          url: endpoints.teamsJob.url
          data: {file: $scope.teamData.file}
        ).then(success, failure)

      $scope.showCreateBundleDialog = ->
        return if $scope.createBundleDialog &&
          ngDialog.isOpen($scope.createBundleDialog)
        resetBundleData()
        $scope.createBundleDialog = ngDialog.open
          template: 'private/teacher/bundle.html'
          scope: $scope

      $scope.showDownloadResultsDialog = ->
        return if $scope.downloadResultsDialog &&
        resetResultData()
        $scope.downloadResultsDialog = ngDialog.open
          template: 'private/teacher/download_results.html'
          scope: $scope

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

      $scope.createBundle = ->
        return if $scope.bundleData.processing
        $scope.bundleData.processing = true
        success = (response) ->
          $scope.bundleData.processing = false
          $scope.bundleData.waiting = true
          NotificationDispatcher
          .subscribeProject $scope.bundleData.selectedProject, (e) ->
            configurations.then (config) ->
              if (e.type is
                config.notification_event_types.project_bundle_ready)
                  if e.payload.bundle.id is response.data.id
                    $scope.bundleData.ready = true
                    $scope.bundleData.bundle = e.payload.bundle
        failure = (response) ->
          $scope.bundleData.processing = false
          if response.status is 422
            $scope.bundleData.error =
              ("#{key.split('_').join(' ').capitalize()} #{value}." for key, value of response.data)
              .join ' '
          else if response.status is 500
            $state.go '^.^.internal_error'
          else
            $scope.bundleData.error = response.data.message.capitalize

        $http.post(endpoints.project.bundle.resourceUrl, {
          project_id: $scope.bundleData.selectedProject.id
        }).then(success, failure)

      $scope.downloadResults = ->
        return if $scope.downloadResultsData.loading
        $scope.downloadResultsData.loading = true
        $http.get(endpoints.projectResults.csv.replace(':project_id',
        $scope.downloadResultsData.selectedProject.id),
        {responseType: 'blob'}
        ).then (response) ->
          $scope.downloadResultsData.loading = false
          try
            filename = response.headers('content-Disposition').split(';')[1].split("=")[1]
            filename = filename.substr(1, filename.length - 2)
          finally
            filename or= "results.csv"
          FileSaver.saveAs(response.data, filename)
        , (response) ->
          $scope.downloadResultsData.loading = false
          if response.status is 422
            $scope.downloadResultsData.error =
              ("#{key.split('_').join(' ').capitalize()} #{value}." for key, value of response.data)
              .join ' '
          else if response.status is 500
            $state.go '^.^.internal_error'
          else
            $scope.downloadResultsData = response.data.message.capitalize

      $scope.downloadTeams = ->
        return if $scope.globalLoading
        $scope.globalLoading = true
        $http.get(endpoints.teamsJob.url,
          {responseType: 'blob'}
          ).then (response) ->
            $scope.globalLoading = false
            try
              filename = response.headers('content-Disposition').split(';')[1].split("=")[1]
              filename = filename.substr(1, filename.length - 2)
            finally
              filename or= "students.csv"
            FileSaver.saveAs(response.data, filename)
