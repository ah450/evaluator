angular.module 'evaluator'
  .controller 'ContactController', ($scope, ContactsResource) ->

    $scope.send = ->
      