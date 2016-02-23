
angular.module 'evaluator', ['ngResource', 'ui.router', 'ui.router.title',
  'evaluatorTemplates', 'satellizer', 'LocalStorageModule', 'ngAnimate',
  'angulartics', 'angulartics.google.analytics', 'infinite-scroll',
  'ngDialog', 'ngFileUpload', 'ngFileSaver', 'ngMaterial', 'ngMessages'
  ]
  


# Configuration blocks.

angular.module 'evaluator'
  .config ($compileProvider) ->
    $compileProvider.debugInfoEnabled false

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
  .constant 'defaultPageSize', 15
  .constant 'GUC_ID_REGEX', /^([0-9]+)-([0-9]+)$/

# Infinite scroll throttling
angular.module 'infinite-scroll'
  .value 'THROTTLE_MILLISECONDS', 250

angular.module 'evaluator'
  .config (ngDialogProvider) ->
    ngDialogProvider.setDefaults
      closeByNavigation: true