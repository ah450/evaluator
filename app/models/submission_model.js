jprServices.factory('Submission', ['SubmissionResource', 'BaseModel', function(SubmissionResource, BaseModel){
    Submission.prototype = Object.create(BaseModel.prototype);
    function Submission(data, exists){
        BaseModel.call(this, data, exists, SubmissionResource, 'name');
    }
    return Submission;
}]);