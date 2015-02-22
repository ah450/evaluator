jprServices.factory('Submission', ['$q', 'SubmissionResource', 'BaseModel', 'User', function($q, SubmissionResource, BaseModel, User) {
    Submission.prototype = Object.create(BaseModel.prototype);

    function Submission(data, exists) {
        BaseModel.call(this, data, exists, SubmissionResource, 'id');
    }

    Submission.prototype.__defineGetter__('id', function() {
        return this.data.id;
    });
    Submission.prototype.__defineGetter__('compiler_out', function() {
        return this.data.compiler_out;
    });
    Submission.prototype.__defineGetter__('compile_status', function() {
        return this.data.compile_status;
    });
    Submission.prototype.__defineGetter__('compile_fail', function() {
        return this.data.processed && !this.data.compile_status || (this.data.project.tests.length>0 && this.data.tests.length!==0);
    });
    Submission.prototype.__defineGetter__('processed', function() {
        return this.data.processed || this.data.compiler_out!=="";
    });
    Submission.prototype.__defineGetter__('url', function() {
        return this.data.url;
    });

    Submission.prototype.__defineGetter__('tests', function() {
        return this.data.tests;
    });
    Submission.prototype.__defineGetter__('all_tests_passed', function() {
        return this.data.tests.reduce(function(previousValue, testCase) {
            return previousValue && testCase.success;
        }, true);
    });

    Submission.prototype.__defineGetter__('tests_passed_count', function() {
        return this.data.tests.reduce(function(count, testCase) {
            return (testCase.success) ? count + 1 : count;
        }, 0);
    });

    Submission.prototype.__defineGetter__('cases_passed_count', function() {
        return this.data.tests.reduce(function(count, test) {
            return count + test.cases.reduce(function(c, tcase) {
                return (tcase.pass) ? c + 1 : c;
            }, 0);
        }, 0);
    });

    Submission.prototype.__defineGetter__('project', function() {
        return this.data.project;
    });


    Submission.prototype.__defineGetter__('submitter', function() {
        return new User(this.data.submitter, true);
    });

    Submission.prototype.__defineGetter__('download_url', function() {
        return this.data.download_url;
    });


    return Submission;
}]);
