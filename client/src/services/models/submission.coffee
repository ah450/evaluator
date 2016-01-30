angular.module 'evaluator'
  .factory 'Submission', (SubmissionResource, endpoints, Result,
    ResultsResource, Pagination) ->
    class Submission
      constructor: (data) ->
        @resource = new SubmissionResource data
        @results = []
        resultFactory = (data) ->
          new Result data
        @resultsPagination = new Pagination ResultsResource, 'results',
          {submission_id: @id}, resultFactory, 10000
        @resultsPagination.page(1).then (results) ->
          @results.push.apply @results, results
      @property 'downloadUrl',
        get: ->
          endpoints.submission.downloadUrl.replace(':id', @id)

      @property 'id',
        get: ->
          @resource.id

      @property 'done',
        get: ->
          @results.length > 0

      @property 'compiled',
        get: ->
          _.every @results, 'compiled'

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
          @results.reduce (accum, result) ->
            accum + result.grade
          , 0


      @property 'max_grade',
        get: ->
          @results.reduce (accum, result) ->
            accum + result.max_grade
          , 0

      @PARTIAL_STATE: 'PARTIAL_STATE'
      @SUCCESS_STATE: 'SUCCESS_STATE'
      @COMPILE_ERROR_STATE: 'COMPILE_ERROR_STATE'
      
    