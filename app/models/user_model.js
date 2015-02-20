jprServices.factory('User', ['UserResource', 'BaseModel', '$http', 'Host', '$q', function(UserResource, BaseModel, $http, Host, $q) {

    User.prototype = Object.create(BaseModel.prototype);
    User.prototype.constructor = User;

    function User(data, exists) {
        BaseModel.call(this, data, exists, UserResource, 'id', 'users');
    }

    User.prototype.isStudent = function() {
        return this.data.email.endsWith('@student.guc.edu.eg');
    }
    User.prototype.isTeacher = function() {
        return !this.isStudent();
    }
    User.prototype.__defineSetter__('email', function(value) {
        this.modified = true;
        return this.data.email = value;
    });
    User.prototype.__defineGetter__('email', function() {
        return this.data.email;
    });
    User.prototype.__defineGetter__('id', function() {
        return this.data.id;
    });
    User.prototype.__defineSetter__('name', function(value) {
        this.modified = true;
        return this.data.name = name;
    });
    User.prototype.__defineGetter__('name', function() {
        return this.data.name;
    });
    User.prototype.__defineSetter__('guc_id', function(value) {
        this.modified = true;
        return this.data.guc_id = value;
    });
    User.prototype.__defineGetter__('guc_id', function() {
        return this.data.guc_id;
    });
    User.prototype.__defineSetter__('password', function(value) {
        this.modified = true;
        return this.data.password = value;
    });
    User.prototype.__defineGetter__('password', function() {
        return this.data.password;
    });
    User.prototype.__defineGetter__('url', function() {
        return this.data.url;
    });

    User.prototype.update = function() {
        return $http({
            method: 'PUT',
            headers: {
                'X-Auth-Token': 'Replace Me'
            },
            url: [Host.api_base, 'user', this.data.id].join('/'),
            data: this.data
        });
    };

    User.prototype.courses = function() {
        var defered = $q.defer();
        var ep = [Host.api_base, 'user', 'dashboard'].join('/');
        var req = {
            method: 'GET',
            url: ep,
            headers: {
                'X-Auth-Token': 'Replace Me'
            }
        };
        $http(req)
            .success(function(data, status, headers, config) {
                defered.resolve(data);
            })
            .error(function(data, status, headers, config) {
                var response = {
                    data: data,
                    status: status,
                    headers: headers,
                    config: config
                };
                defered.reject(response);
            });
        return defered.promise;
    }

    User.$all = function() {
        return new User({}, false).all();
    };

    User.$get = function(id) {
        return new User({}, false).get(id);
    };
    return User;

}]);
