var compareTo = function() {
    return {
        require: "ngModel",
        scope: {
            otherModelValue: "=compareTo"
        },
        link: function(scope, element, attributes, ngModel) {
             
            ngModel.$validators.compareTo = function(modelValue) {
                return modelValue == scope.otherModelValue;
            };
 
            scope.$watch("otherModelValue", function() {
                ngModel.$validate();
            });
        }
    };
};
 
jprApp.directive("compareTo", compareTo);

jprApp.directive("submissions", function () {
   return {
    restrict:'E',
    // scope: {'submissions':'=', 'loadingSubmission':'='},
    templateUrl:'submissions.html'
   }; 
});