jprApp.controller('ActivationCtrl', ['$http', '$location', 'Page', 'Host', function($http, $location, Page, Host) {
    Page.showSpinner();
    Page.clearCurrentLink();
    Page.clearTitle();
    var searchObject = $location.search();
    if (!searchObject.hasOwnProperty('token')) {
        searchObject.token = 'triggerA404Response';
    }
    var activateUrl = Host.api_base + '?token=' + searchObject.token;

    function activationCallback(data, status) {
        Page.hideSpinner();
        if (status == 204) {
            Page.setFlash('Account Activated.');
            $location.path('/home').replace();
        } else if (status == 404 || status == 400) {
            // bad token
            Page.addErrorMessage('Please make sure you copy the link correctly from the email.');
        } else {
            // undocumented behaviour !!!
            Page.addErrorMessage('Major server oopsie, please grab a programmer.');
        }
    }
    $http.get(activateUrl)
    .success(activationCallback)
    .error(activationCallback);
}]);