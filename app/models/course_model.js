jprServices.factory('Course', ['$q', 'User', 'CourseResource', 'BaseModel', '$upload', 'ProjectResource', 'Project', function($q, User,CourseResource, BaseModel, $upload, ProjectResource, Project) {
    Course.prototype = Object.create(BaseModel.prototype);
    Course.prototype.constructor = Course;
    function Course(data, exists) {
      BaseModel.call(this, data, exists, CourseResource, 'name');
    }
    Course.prototype.add_student = function(user, success, failure) {
        this.resource.add_student({
            name: this.data.name,
        }, {id: user.id}, function(response, headers) {
            success(response, headers);
        }, function(httpResponse){
            failure(httpResponse);
        });
    };

    Course.prototype.add_teacher = function(user, success, failure) {
        this.resource.add_teacher({
            name: this.data.name
        }, {id: user.id}, function(response, headers) {
            success(response, headers);
        }, function(httpResponse) {
            failure(httpResponse);
        });
    };

    Course.prototype.create_project = function(project, success, failure){
        if (project.tests.length == 0) {
            // create a project without test cases
            ProjectResource.create({
                courseName: this.data.name
            }, project, function(createdProject){
                success(new Project(createdProject, true))
            }, function(httpResponse){
                failure(httpResponse);
            });
        }else {
            $upload.upload({
                url: 'https://api.evaluator.in' + this.data.projects_url,
                method: 'POST',
                headers: {
                    'X-Auth-Token': 'Replace Me'
                },
                data: {
                    name: project.name,
                    language: project.language
                },
                file: project.tests
            }).success(function(data){
                success(new Project(data, true));
            }).error(function(data, status, headers, config){
                failure({data: data, status: status, headers: headers, config: config});
            });
        }
    };

    Course.prototype.__defineGetter__('name', function() {
        return this.data.name;
    });
    Course.prototype.__defineSetter__('name', function(value) {
        this.modified = true;
        return this.data.name = value;
    });
    Course.prototype.__defineSetter__('description', function(value){
        this.modified = true;
        return this.data.description = value;
    });
    Course.prototype.__defineGetter__('description', function(){
        return this.data.description;
    });
    Course.prototype.__defineGetter__('supervisor', function(){
        return new User(this.data.supervisor, true);
    })

    Course.prototype.__defineGetter__('students', function(){
        students = $q.defer();
        this.resource.query({
            name: this.data.name,
            dest: 'course',
            ep: 'students'
        }, function(data, headers) {
            data = data.map(function(element) {
                return new User(element, true);
            });
            students.resolve(data);
        }, function(httpResponse){
            students.reject(httpResponse);
        });
        return students.promise;
    });

    Course.prototype.__defineGetter__('teachers', function(){
        teachers = $q.defer();
        this.resource.query({
            name: this.data.name,
            dest: 'course',
            ep: 'tas'
        }, function(data, headers) {
            data = data.map(function(element){
                return new User(element, true);
            });
            teachers.resolve(data);
        }, function(httpResponse){
            teachers.reject(httpResponse);
        });
        return teachers.promise;
    });

    Course.prototype.__defineGetter__('tas_url', function(){
        return this.data.tas_url;
    });
    Course.prototype.__defineGetter__('students_url', function() {
        return this.data.students_url;
    });
    Course.prototype.__defineGetter__('projects_url', function() {
        return this.data.projects_url;
    });
    Course.prototype.__defineGetter__('url', function(){
        return this.data.url;
    });

    Course.prototype.__defineGetter__('projects', function(){
        deferred = $q.defer();

        ProjectResource.query_related({
            courseName: this.data.name,
        }, function(projects){
            projects = projects.map(function(element){
                return new Project(element, true);
            })
            deferred.resolve(projects);
        }, function(httpResponse){
            deferred.reject(httpResponse);
        });

        return deferred.promise;
    });

    Course.$all = function(){
        return new Course({}, false).all();
    }

    Course.$get = function(name){
        return new Course({}, false).get(name);
    }

    Course.$fromProject = function(project){
        return new Course(project.course, true);
    }

    return Course;
    
}]);

