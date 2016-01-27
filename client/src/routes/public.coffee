angular.module 'evaluator'
  .config ($stateProvider) ->

    publicState =
      name: 'public'
      templateUrl: 'public/root.html'
      url: ''
      abstract: true
      data:
        authRule: (userAuth) ->
          if userAuth.signedIn
            {
              to: 'private.courses'
              params: {}
              allowed: false
            }
          else
            {
              allowed: true
            }

    loginState =
      name: 'public.login'
      url: '/login'
      views:
        'pageContent':
          templateUrl: 'public/login.html'
          controller: 'LoginController'

    signupState =
      name: 'public.signup'
      url: '/signup'
      views:
        'pageContent':
          templateUrl: 'public/signup.html'
          controller: 'SignupController'
    
    aboutState =
      name: 'public.about'
      url: '/about'
      views:
        'pageContent':
          templateUrl: 'public/about.html'

    verifyAccount =
      name: 'public.verify'
      url: '/verify'

    resetPass =
      name: 'public.reset'
      url: '/reset'

    sendReset =
      name: 'public.reset.send'
      url: '/send'
      views:
        'pageContent':
          templateUrl: 'generic/wait_message.html'
          controller: 'SendResetController'

    sendVerification =
      name: 'public.verify.send'
      url: '/verify'
      views:
        'pageContent':
          templateUrl: 'generic/wait_message.html'
          controller: 'SendVerifyController'

    internalErrorState =
      name: 'public.internal_error'
      url: '/oops'
      views:
        'pageContent':
          templateUrl: 'public/internal_error.html'

    welcomeState =
      name: 'public.welcome'
      url: '/welcome'
      views:
        'pageContent':
          templateUrl: 'public/welcome.html'

    $stateProvider
      .state publicState
      .state loginState
      .state signupState
      .state aboutState
      .state internalErrorState
      .state resetPass
      .state verifyAccount
      .state sendReset
      .state sendVerification
      





