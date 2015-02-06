jprServices.factory('BaseModel', ['$q', function($q) {
  function BaseModel(data, exists, resource, identifier_name) {
    this.loadFromObject(data);
    this.exists = exists;
    this.modified = false;
    this.resource = resource;
    this.identifier_name = identifier_name;
  }

  BaseModel.prototype.loadFromObject = function(data) {
    this.data = {};
    for (var key in data) {
      if (data.hasOwnProperty(key)) {
        this.data[key] = data[key];
      }
    }
  };

  BaseModel.prototype.save = function(success, error) {
    var parent_this = this;
    if (!this.exists) {
      this.resource.create(this.data, function(data, headers) {
        parent_this.loadFromObject(data);
        parent_this.exists = true; // it now exists
        parent_this.modified = false; // hasn't been modified yet
        success(parent_this, headers);
      }, function(httpResponse) {
        error(httpResponse);
      });
    } else if (this.modified) {
      this.resource.update(this.data, function(data, headers) {
        parent_this.loadFromObject(data);
        parent_this.modified = false;
        // Already exists
        success(parent_this, headers);
      }, function(httpResponse) {
        error(httpResponse);
      });
    } else {
      success(this, {});
    }
  };

  BaseModel.prototype.get = function(id) {
    // Get a single resource
    var defered = $q.defer(); // create promise
    var parent_this = this;
    var params = {};
    params[this.identifier_name] = id;
    this.resource.get(params, function(data, headers) {
      // translate to class
      defered.resolve(new parent_this.constructor(data, true));
    }, function(httpResponse) {
      // pass http response
      defered.reject(httpResponse);
    });
    return defered.promise;
  };

  BaseModel.prototype.all = function() {
    // Return all objects.
    var defered = $q.defer(); // create promise
    var parent_this = this;
    this.resource.query(function(data, headers) {
      // convert received objects to Class instances.
      objects = data.map(function(element) {
        return new parent_this.constructor(element, true);
      });
      defered.resolve(objects);
    }, function(httpResponse) {
      // Pass http response
      defered.reject(httpResponse);
    });
    return defered.promise;
  };

  BaseModel.prototype.__defineGetter__('created_at_pretty', function() {
    return moment(this.data.created_at).format("dddd, MMMM Do YYYY, h:mm:ss a");
  });
  BaseModel.prototype.__defineGetter__('created_at', function() {
      return new Date(this.data.created_at);
  });
  return BaseModel;

}]);