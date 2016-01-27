angular.module 'evaluator'
  .config ($stateProvider) ->

    privateState =
      name: 'private'
      templateUrl: 'private/root.html'
      url: ''
      abstract: true
      data:
        authRule: (userAuth) ->
          if userAuth.signedIn
            {
              allowed: true
            }
          else
            {
              to: 'public.login'
              params: {}
              allowed: false
            }

    coursesState =
      name: 'private.courses'
      url: '/courses'
      resolve:
        $title: ->
          'Courses'
      views:
        'privateContent':
          templateUrl: 'private/courses.html'
          controller: 'CoursesController'