angular.module 'evaluator'
  .controller 'PortalController', ($scope, ngDialog, NotificationDispatcher,
    Upload, $state, endpoints, configurations) ->
    $scope.teamData = {}
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
              $scope.teamData.processedPercentage = status.processed / status.total_rows *100
              $scope.teamData.total = status.total_rows


      failure = (response) ->
        $state.go 'private.internal_error'
      
      Upload.upload(
        url: endpoints.teamsJob.url
        data: {file: $scope.teamData.file}
      ).then(success, failure)