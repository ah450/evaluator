angular.module 'evaluator'
  .factory 'Bundle', (NotificationDispatcher, BundlesResource,
    configurations, moment) ->
      class Bundle
        constructor: (@resource) ->
          NotificationDispatcher.subscribeProject {id: @project_id}, (e) ->
            configurations.then (config) =>
              if (e.type is
                config.notification_event_types.project_bundle_ready)
                  if e.payload.bundle.id is @id
                    @ready = true


        @property 'ready',
          get: ->
            @resource.ready
          set: (value) ->
            @resource.ready = value

        @property 'project_id',
          get: ->
            @resource.project_id

        @property 'project_name',
          get: ->
            @resource.project_name

        @property 'created_at',
          get: ->
            moment(@resource.created_at).format("MMMM Do YYYY, h:mm:ss a")

        @property 'id',
          get: ->
            @resource.id

        @fromData: (data, args...) ->
          new Bundle(new ProjectResource(data), args...)