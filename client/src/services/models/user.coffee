angular.module 'evaluator'
  .factory 'User', (UsersResource) ->
    class Participant
      constructor: (data) ->
        @resource = new UsersResource(data)

      @property 'student',
        get: ->
          @resource.student

      @property 'teacher',
        get: ->
          !@resource.student