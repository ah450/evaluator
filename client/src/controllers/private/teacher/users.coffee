angular.module 'evaluator'
  .controller 'UsersController', ($scope, Pagination, defaultPageSize,
    UsersResource, User) ->
      $scope.studentsOnly = false
      $scope.teachersOnly = false
      $scope.loading = true
      $scope.loadingUsers = false
      $scope.params = {
        name: null,
        email: null,
        guc_suffix: null,
        guc_prefix: null,
        student: null,
        super_user: null
      }

      $scope.$watch 'teachersOnly', (newValue, oldValue) ->
        if newValue
          $scope.params.student = false
          $scope.reload()
          $scope.studentsOnly = false
        else
          if !$scope.studentsOnly
            $scope.params.student = null
            $scope.reload()
      $scope.$watch 'studentsOnly', (newValue, oldValue) ->
        if newValue
          $scope.params.student = true
          $scope.reload()
          $scope.teachersOnly = false
        else
          if !$scope.teachersOnly
            $scope.params.student = null
            $scope.reload()




      
      $scope.users = []

      addUsersCallback = (users) ->
        args = [0, $scope.users.length].concat users
        $scope.users.splice.apply $scope.users, args

      userFactory = (data) ->
        new User(data)

      usersPagination = new Pagination UsersResource, 'users', $scope.params,
        userFactory, defaultPageSize


      $scope.currentPage = 1

      $scope.reload = ->
        return if $scope.loadingUsers
        $scope.loadingUsers = true
        usersPagination.reload().then (users) ->
          $scope.loading = false
          $scope.loadingUsers = false
          addUsersCallback users

      loadUsersPage = (page) ->
        $scope.loadingUsers = true
        usersPagination.page(page).then (users) ->
          $scope.loading = false
          $scope.loadingUsers = false
          $scope.currentPage = page
          addUsersCallback users

      # Load first page
      loadUsersPage $scope.currentPage

      $scope.backDisabled = ->
        $scope.currentPage is 1

      $scope.nextDisabled = ->
        $scope.currentPage >= usersPagination.totalPages

      $scope.next = ->
        if not $scope.nextDisabled()
          loadUsersPage($scope.currentPage + 1)

      $scope.back = ->
        if not $scope.backDisabled()
          loadUsersPage($scope.currentPage - 1)

