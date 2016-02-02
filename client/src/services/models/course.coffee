angular.module 'evaluator'
  .factory 'Course', (NotificationDispatcher, CoursesResource, configurations) ->
    class Course
      constructor: (@resource, @newProjectCallback=angular.noop,
        @publishedProjectCallback=angular.noop) ->
        NotificationDispatcher.subscribeCourse @, (e) =>
          configurations.then (config) =>
            if e.type is config.notification_event_types.course_published
              _.assign @resource, e.payload.course
            else if e.type is config.notification_event_types.project_created
              @newProjectCallback e.payload.project
            else if e.type is config.notification_event_types.project_published
              @publishedProjectCallback e.payload.project

      @property 'id',
        get: ->
          @resource.id

      @property 'name',
        get: ->
          @resource.name

      @property 'description',
        get: ->
          @resource.description

      @property 'published',
        get: ->
          @resource.published
        set: (value) ->
          @resource.published = value

      $update: (args...) ->
        @resource.$update(args)

      @fromData: (data) ->
        new Course(new CoursesResource(data))
