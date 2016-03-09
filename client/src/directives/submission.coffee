angular.module 'evaluator'
  .directive 'submission', ->
    directive =
      restrict: 'AE'
      templateUrl: 'directives/submission.html'
      scope:
        submission: '=data'
        includeSubmitter: '@?'
      controller: ['$scope', 'FileSaver', '$http',
        ($scope, FileSaver, $http) ->
          $scope.download = ->
            $http.get($scope.submission.downloadUrl.replace(':id',
              $scope.submission.id),
              {responseType: 'blob'})
              .then (response) ->
                try
                  filename = response.headers('content-Disposition').split(';')[1].split("=")[1]
                  filename = filename.substr(1, filename.length - 2)
                finally
                  filename or= "submission_#{$scope.submission.id}.zip"
                  FileSaver.saveAs(response.data, filename)
        ]
