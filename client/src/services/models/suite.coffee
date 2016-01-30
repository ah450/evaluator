angular.module 'evaluator'
  .factory 'Suite', (SuiteResource, NotificationDispatcher, configurations) ->
    class Suite
      constructor: (data) ->
        @resource = new SuiteResource data
        NotificationDispatcher.subscribeSuite @, (e) =>
          configurations.then (config) =>
            if e.type is config.notification_event_types.test_suite_processed
              _.assign @resource, e.payload.test_suite


      @property 'suite_cases',
        get: ->
          @resource.suite_cases

      @property 'id',
        get: ->
          @resource.id

      @property 'hidden',
        get: ->
          @resource.hidden

      @property 'ready',
        get: ->
          @resource.ready

      @property 'max_grade',
        get: ->
          @resource.max_grade

      @property 'timout',
        get: ->
          @resource.timout

      @property 'name',
        get: ->
          @resource.name

      
    