angular.module 'evaluator'
  .controller 'BundleDownloadController', ($scope, FileSaver, $http,
    $stateParams, endpoints) ->
      $scope.processing = true
      $http.get(endpoints.project.bundle.downloadUrl.replace(':id',
        $stateParams.id),
        {responseType: 'blob'}
        ).then (response) ->
          $scope.processing = false
          filename = "bundle_#{$stateParams.id}.tar.gz"
          FileSaver.saveAs(response.data, filename)

