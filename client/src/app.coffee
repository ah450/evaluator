
angular.module 'evaluator', ['ngResource', 'ui.router', 'ui.router.title',
  'evaluatorTemplates', 'satellizer', 'LocalStorageModule', 'ngAnimate',
  'angulartics', 'angulartics.google.analytics', 'infinite-scroll',
  'ngDialog', 'datePicker', 'ngFileUpload', 'ngFileSaver'
  ]
  


# Configuration blocks.

angular.module 'evaluator'
  .config ($compileProvider) ->
    $compileProvider.debugInfoEnabled true

angular.module 'evaluator'
  .config (localStorageServiceProvider) ->
    localStorageServiceProvider.setPrefix('evaluator')

angular.module 'evaluator'
  .config ($urlMatcherFactoryProvider) ->
    $urlMatcherFactoryProvider.strictMode false

# Defines constants for use within our app.
angular.module 'evaluator'
  .constant 'apiHost', '/api'
  .constant 'baseHost', '/'
  .constant 'defaultPageSize', 5

# Infinite scroll throttling
angular.module 'infinite-scroll'
  .value 'THROTTLE_MILLISECONDS', 250