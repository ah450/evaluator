angular.module 'evaluator'
  .factory 'Project', (moment, ProjectResource,
    NotificationDispatcher, configurations) ->
    class Project
      constructor: (@resource, @unpublishedCallback=angular.noop,
        @newSuiteCallback=angular.noop,
        @processedSuiteCallback=angular.noop) ->
        NotificationDispatcher.subscribeProject @, (e) =>
          configurations.then (config) =>
            if e.type in config.notification_event_types.project_published
              _.assign @resource, e.payload.project
            else if e.type is config.notification_event_types.project_unpublished
              _.assign @resource, e.payload.project
              @unpublishedCallback e.payload.project
            else if e.type is config.notification_event_types.suite_created
              @newSuiteCallback e.payload.test_suite
            else if e.type is config.notification_event_types.test_suite_processed
              @processedSuiteCallback e.payload.test_suite


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
