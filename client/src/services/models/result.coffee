angular.module 'evaluator'
  .factory 'Result', (ResultResource) ->
    class Result
      constructor: (data) ->
        @resource = new ResultResource data
        @test_suite = @resource.test_suite

      @property 'cases',
        get: ->
          @resource.test_cases

      @property 'compiled',
        get: ->
          @resource.compiled

      @property 'grade',
        get: ->
          @resource.grade

      @property 'max_grade',
        get: ->
          @resource.max_grade

      @property 'id',
        get: ->
          @resource.id

      @property 'compiler_stderr',
        get: ->
          @resource.compiler_stderr

      @property 'compiler_stdout',
        get: ->
          @resource.compiler_stdout

      @property 'hidden',
        get: ->
          @resource.hidden

      @property 'success',
        get: ->
          @resource.success

      @property 'state',
        get: ->
          if @success
            @SUCCESS_STATE
          else if not @compiled
            @ERROR_STATE
          else
            @FAILED_STATE

      SUCCESS_STATE: 'success-result'
      ERROR_STATE: 'error-result'
      FAILED_STATE: 'failed-result'





        