angular.module 'evaluator'
  .directive 'submission', ->
    directive =
      restrict: 'AE'
      templateUrl: 'directives/submission.html'
      scope:
        submission: '=data'
      controller: ($scope, FileSaver, $http) ->
        $scope.download = ->
          $http.get($scope.submission.downloadUrl, {responseType: 'blob'})
            .then (response) ->
              filename = "submission_#{$scope.submission.id}.zip"
              FileSaver.saveAs(response.data, filename)
