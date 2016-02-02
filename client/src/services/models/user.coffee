angular.module 'evaluator'
  .factory 'User', (UsersResource) ->
    class User
      constructor: (data) ->
        @resource = new UsersResource(data)
        _.assign @, @resource

      $update: (args...) ->
        @resource.$update(args...)

      @property 'id',
        get: ->
          @resource.id
      
      @property 'student',
        get: ->
          @resource.student

      @property 'teacher',
        get: ->
          !@resource.student

      @property 'name',
        get: ->
          @resource.name
        set: (value) ->
          @resource.name = value

      @property 'email',
        get: ->
          @resource.email

      @property 'guc_id',
        get: ->
          @resource.guc_id
        set: (value) ->
          @resource.guc_id = value

      @property 'guc_suffix',
        get: ->
          @resource.guc_suffix
        set: (value) ->
          @resource.guc_suffix = value

      @property 'guc_prefix',
        get: ->
          @resource.guc_prefix
        set: (value) ->
          @resource.guc_prefix = value

      @property 'team',
        get: ->
          @resource.team
        set: (value) ->
          @resource.team = value

      @property 'password',
        get: ->
          @resource.password
        set: (value) ->
          @resource.password = value

      @property 'major',
        get: ->
          @resource.major
        set: (value) ->
          @resource.major = value
