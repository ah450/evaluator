jprServices.factory('Project', ['$q', '$upload', 'ProjectResource', 'BaseModel', 'Submission', 'Host', function($q, $upload, ProjectResource, BaseModel, Submission, Host) {
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

    Project.prototype.__defineSetter__('due_date', function(due_date) {
        this.data.due_date = due_date.toISOString();
        return due_date;
    });

    Project.prototype.__defineGetter__('due_date_pretty', function() {
        return moment(this.data.due_date).format("dddd, MMMM Do YYYY, h:mm:ss");
    });

    Project.prototype.getSubmissionsPage = function(page) {
        var deferred = $q.defer();

        ProjectResource.get_submissions({
            courseName: this.data.course.name,
            projectName: this.data.name,
            page: page
        }, function(submissionPage) {
            var submissions = submissionPage.submissions.map(function(element) {
                return new Submission(element, true);
            });
            submissionPage.submissions = submissions;
            deferred.resolve(submissionPage);
        }, function(httpResponse) {
            deferred.reject(httpResponse);
        });

        return deferred.promise;
    };

    Project.prototype.submitCode = function(codeFile, success, failure) {
        $upload.upload({
            url: Host.api_base + this.data.submissions_url,
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

    Project.prototype.update_project = function(project, success, failure) {

        var formDataNames = [];
        for (var i = 0; i < project.tests.length; i++) {
            formDataNames.push('file[' + i + ']');
        }
        $upload.upload({
            url: Host.api_base + this.data.url,
            method: 'PUT',
            headers: {
                'X-Auth-Token': 'Replace Me'
            },
            data: {
                due_date: this.data.due_date,
            },
            file: project.tests,
            fileFormDataName: formDataNames
        }).success(function(data) {
            success(new Project(data, true));
        }).error(function(data, status, headers, config) {
            failure({
                data: data,
                status: status,
                headers: headers,
                config: config
            });
        });

    };

    Project.prototype.__defineGetter__('can_submit', function() {
        return this.data.can_submit;
    });

    Project.prototype.__defineGetter__('tests', function() {
        return this.data.tests;
    });


    Project.prototype.__defineSetter__('tests', function(tests) {
        this.data.tests = tests;
        return tests;
    });

    Project.submissionsPerPage = 10;

    Project.$all = function() {
        return new Project({}, false).all();
    }

    Project.$get = function(name) {
        return new Project({}, false).get(name);
    }
    return Project;
}]);
