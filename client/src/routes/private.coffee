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
        'pageContent':
          templateUrl: 'private/courses.html'
          controller: 'CoursesController'

    courseState =
      name: 'private.course'
      url: '/course/:id'
      views:
        'pageContent':
          templateUrl: 'private/course.html'
          controller: 'CourseController'

    $stateProvider
      .state privateState
      .state coursesState
      .state courseState