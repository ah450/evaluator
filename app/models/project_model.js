jprServices.factory('Project', ['$upload', 'ProjectResource', 'BaseModel', 'Submission', function($upload, ProjectResource, BaseModel, SubmissionResource, Submission) {
    Project.prototype = Object.create(BaseModel.prototype);
    Project.prototype.constructor = Project;

    function Project(data, exists) {
        BaseModel.call(this, data, exists, ProjectResource, 'id');
    }

    Project.prototype.__defineGetter__('id', function() {
        return this.data.id;
    });

    Project.prototype.__defineGetter__('url', function() {
        return this.data.url;
    });

    Project.prototype.__defineGetter__('name', function() {
        return this.data.name;
    });

    Project.prototype.__defineGetter__('language', function() {
        return this.data.language;
    });

    Project.prototype.__defineGetter__('submissions_url', function() {
        return this.data.submissions_url;
    });

    Project.prototype.__defineGetter__('course', function() {
        return this.data.course;
    });

    Project.prototype.__defineGetter__('due_date', function() {
        return new Date(this.data.due_date);
    });

    Project.prototype.__defineGetter__('due_date_pretty', function() {
        return moment(this.data.due_date).format("dddd, MMMM Do YYYY");
    })

    Project.prototype.submitCode = function(codeFile, success, failure) {
        $upload.upload({
            url: 'https://api.evaluator.in' + this.data.submissions_url,
            method: 'POST',
            headers: {
                'X-Auth-Token': 'Replace Me'
            },
            file: codeFile
        }).success(function(data, status, headers, config) {
            success(new Submission(data, true), status, headers, config);
        }).error(function(data, status, headers, config) {
            failure(data, status, headers, config);
        });
    };

    Project.prototype.__defineGetter__('can_submit', function() {
        return this.data.can_submit;
    });

    Project.$all = function() {
        return new Project({}, false).all();
    }

    Project.$get = function(name) {
        return new Project({}, false).get(name);
    }
    return Project;
}]);