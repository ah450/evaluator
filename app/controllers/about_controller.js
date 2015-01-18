jprApp.controller('AboutCtrl', ['$scope', 'Page', function($scope, page){
    Page.setSection('About');
    Page.setLink('about');
    Page.clearErrorMessages();
    
}])