angular.module 'evaluator'
  .controller 'PortalController', ($scope, ngDialog, NotificationDispatcher,
    Upload, $state, endpoints, configurations, UserAuth, CoursesResource,
    CourseProjectsResource, $http, FileSaver) ->
      $scope.teamData = {}
      $scope.bundleData = {}
      $scope.isAdmin = UserAuth.user.admin
      $scope.globalLoading = false

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
              ("#{key.capitalize()} #{value}." for key, value of response.data)
              .join ' '
          else if response.status is 500
            $state.go '^.internal_error'
          else
            $scope.bundleData.error = response.data.message.capitalize

        $http.post(endpoints.project.bundle.resourceUrl, {
          project_id: $scope.bundleData.selectedProject.id
        }).then(success, failure)

      $scope.downloadTeams = ->
        return if $scope.globalLoading
        $scope.globalLoading = true
        $http.get(endpoints.teamsJob.url,
          {responseType: 'blob'}
          ).then (response) ->
            $scope.globalLoading = false
            filename = "students.csv"
            FileSaver.saveAs(response.data, filename)



