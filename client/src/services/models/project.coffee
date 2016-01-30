angular.module 'evaluator'
  .factory 'Project', (moment, ProjectResource) ->
    class Project
      constructor: (@resource) ->

      @property 'due_date',
        get: ->
          moment(@resource.due_date).format("MMMM Do YYYY, h:mm:ss a")

      @property 'start_date',
        get: ->
          moment(@resource.start_date).format("MMMM Do YYYY, h:mm:ss a")

      @property 'published',
        get: ->
          @resource.published
        set: (value) ->
          @resource.published = value

      @property 'name',
        get: ->
          @resource.name

      @property 'quiz',
        get: ->
          @resource.quiz

      @property 'id',
        get: ->
          @resource.id

      $update: (args...) ->
        @resource.$update(args)

      @fromData: (data) ->
        new Project(new ProjectResource(data))
