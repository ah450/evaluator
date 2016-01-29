angular.module 'evaluator'
  .factory 'Result', ->
    class Result
      constructor: (data) ->
        _.assign @, data

      @property 'cases',
        get: ->
          @test_cases

        