angular.module 'evaluator'
  .factory 'Result', ->
    class Result
      constructor: (data) ->
        _.assign @, data
        