angular.module 'evaluator'
  .factory 'User', (UsersResource) ->
    class Participant
      constructor: (data) ->
        @resource = new UsersResource(data)