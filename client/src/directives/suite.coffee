angular.module 'evaluator'
  .directive 'suite', (endpoints, UserAuth, FileSaver, $http) ->
    directive =
      restrict: 'AE'
      templateUrl: 'directives/suite.html'
      scope:
        suite: '=data'
      link: (scope) ->
        
        scope.canDownload = UserAuth.user.teacher || !scope.suite.hidden
        scope.download = ->
          download_url = endpoints.suite.downloadUrl.replace(':id',
            scope.suite.id)
          $http.get(download_url, {responseType: "blob"})
            .then (response) ->
              filename = "#{scope.suite.name}.zip"
              FileSaver.saveAs(response.data, filename)

