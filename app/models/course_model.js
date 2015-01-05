jprServices.factory('Course', ['$q', 'User', 'CourseResource', 'BaseModel', function($q, User,CourseResource, BaseModel) {
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

    Course.$all = function(){
        return new Course({}, false).all();
    }

    Course.$get = function(name){
        return new Course({}, false).get(name);
    }

    return Course;
    
}]);

