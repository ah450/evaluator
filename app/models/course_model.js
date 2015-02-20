jprServices.factory('Course', ['$q', 'User', 'CourseResource', 'BaseModel', '$upload', 'ProjectResource', 'Project', 'Host', function($q, User, CourseResource, BaseModel, $upload, ProjectResource, Project, Host) {
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

        if (project.published) {
            project.published = 'True';
        } else {
            project.published = 'False';
        }
        if (project.tests.length === 0) {
            // create a project without test cases
            ProjectResource.create({
                courseName: this.data.name
            }, project, function(createdProject){
                success(new Project(createdProject, true));
            }, function(httpResponse){
                failure(httpResponse);
            });
        } else {
            var formDataNames = [];
            for (var i = 0; i < project.tests.length; i++) {
                formDataNames.push('file[' + i +']');
            }
            $upload.upload({
                url: Host.api_base + this.data.projects_url,
                method: 'POST',
                headers: {
                    'X-Auth-Token': 'Replace Me'
                },
                data: {
                    name: project.name,
                    language: project.language,
                    due_date: project.due_date,
                    test_timeout: project.test_timeout
                },
                file: project.tests,
                fileFormDataName: formDataNames
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
        return (this.data.name = value);
    });
    Course.prototype.__defineSetter__('description', function(value){
        this.modified = true;
        return (this.data.description = value);
    });
    Course.prototype.__defineGetter__('description', function(){
        return this.data.description;
    });
    Course.prototype.__defineGetter__('supervisor', function(){
        return new User(this.data.supervisor, true);
    });

    Course.prototype.__defineGetter__('published', function() {
        return this.data.published == 'true';
    });

    Course.prototype.__defineSetter__('published', function(value) { 
        this.data.published = value ? 'True': 'False';
        return this.published;
    });
    
    Course.prototype.getStudentsPage = function(pageNumber) {
        var deferred = $q.defer();
        this.resource.query({
            name: this.data.name,
            page: pageNumber,
            dest: 'course',
            ep: 'students'
        }, function(studentsPage) {
            var students = studentsPage.users.map(function(element) {
                return new User(element, true);
            });
            studentsPage.students = students;
            delete studentsPage.users;
            deferred.resolve(studentsPage); 
        }, function(httpResponse) {
            deferred.reject(httpResponse);
        });
        return deferred.promise;
    };

    Course.prototype.getTeachersPage = function (pageNumber) {
        var deferred = $q.defer();
        this.resource.query({
            name: this.data.name,
            dest: 'course',
            ep: 'tas',
            page: pageNumber
        }, function(teachersPage) {
            var teachers = teachersPage.users.map(function (element) {
                return new User(element, true);
            });
            teachersPage.teachers = teachers;
            delete teachersPage.users;
            deferred.resolve(teachersPage);
        }, function(httpResponse) {
            deferred.reject(httpResponse);
        } );

        return deferred.promise
    }

    

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
        var deferred = $q.defer();

        ProjectResource.query_related({
            courseName: this.data.name,
        }, function(projects){
            projects = projects.map(function(element){
                return new Project(element, true);
            });
            deferred.resolve(projects);
        }, function(httpResponse){
            deferred.reject(httpResponse);
        });

        return deferred.promise;
    });

    Course.$all = function(pageNumber){
        return new Course({}, false).all(pageNumber);
    };

    Course.$get = function(name){
        return new Course({}, false).get(name);
    };

    Course.$fromProject = function(project){
        return new Course(project.course, true);
    };

    Course.StudentsPerPage = 5;
    return Course;
    
}]);

