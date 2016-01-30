angular.module 'evaluator'
  .factory 'User', (UsersResource) ->
    class User
      constructor: (data) ->
        @resource = new UsersResource(data)
        _.assign @, @resource

      @property 'id',
        get: ->
          @resource.id
      
      @property 'student',
        get: ->
          @resource.student

      @property 'teacher',
        get: ->
          !@resource.student