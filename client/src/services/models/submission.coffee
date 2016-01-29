angular.module 'evaluator'
  .factory 'Submission', (SubmissionResource, endpoints, Result) ->
    class Submission
      constructor: (data) ->
        @resource = new SubmissionResource data

      @property 'downloadUrl',
        get: ->
          endpoints.submission.downloadUrl.replace(':id', @id)

      @property 'id',
        get: ->
          @resource.id

      @property 'done',
        get: ->
          @resource.results.length > 0

      @property 'compiled',
        get: ->
          _.every @resource.results, 'compiled'

      @property 'status',
        get: ->
          if @compiled
            if @grade == @max_grade
              @SUCCESS_STATE
            else
              @PARTIAL_STATE
          else
            @COMPILE_ERROR_STATE

      @property 'grade',
        get: ->
          @resource.results.reduce (accum, result) ->
            accum + result.grade
          , 0


      @property 'max_grade',
        get: ->
          @resource.results.reduce (accum, result) ->
            accum + result.max_grade
          , 0

      @property 'results',
        get: ->
          factory = (result) ->
            return new Result result
          @resultsObjects ||= _.map @resource.results, factory

      @PARTIAL_STATE: 'PARTIAL_STATE'
      @SUCCESS_STATE: 'SUCCESS_STATE'
      @COMPILE_ERROR_STATE: 'COMPILE_ERROR_STATE'
      
    