// RESTFUL services

jprServices.factory('CourseResource', ['$resource', 'Host',
  function($resource, Host) {
    var url = [Host.api_base, ':dest', ':name', ':ep'].join('/');
    var common_headers = {
      'X-Auth-Token': 'Replace Me'
    }
    return $resource(url, {}, {
      query: {
        method: 'GET',
        params: {
          dest: 'courses'
        },
        isArray: true,
        headers: common_headers
      },
      create: {
        method: 'POST',
        params: {
          dest: 'courses'
        },
        headers: common_headers
      },
      get: {
        method: 'GET',
        params: {
          dest: 'course'
        },
        headers: common_headers
      },
      update: {
        method: 'PUT',
        params: {
          dest: 'course'
        },
        headers: common_headers
      },
      add_teacher: {
        method: 'POST',
        params: {
          dest: 'course',
          ep: 'tas'
        },
        headers: common_headers,

      },
      add_student: {
        method: 'POST',
        params: {
          dest: 'course',
          ep: 'students'
        },
        headers: common_headers,
      },
      delete: {
        method: 'DELETE',
        params: {
          dest: 'course'
        },
        headers: common_headers
      }
    });

  }
]);



jprServices.factory('UserResource', ['$resource', 'Host', function($resource, Host) {
  var url = [Host.api_base, ':dest', ':id'].join('/');
  var common_headers = {
    'X-Auth-Token': 'Replace Me'
  }
  return $resource(url, {}, {
    query: {
      method: 'GET',
      params: {
        dest: 'users'
      },
      isArray: true,
      headers: common_headers
    },
    create: {
      method: 'POST',
      params: {
        dest: 'users'
      },
      headers: common_headers
    },
    update: {
      method: 'PUT',
      params: {
        dest: 'user'
      },
      headers: common_headers
    },
    delete: {
      method: 'DELETE',
      params: {
        dest: 'user'
      },
      headers: common_headers
    },
    get: {
      method: 'GET',
      params: {
        dest: 'user'
      },
      headers: common_headers
    }
  });
}]);


jprServices.factory('ProjectResource', ['$resource', 'Host', function($resource, Host) {
  var url = [Host.api_base, ':dest'].join('/');
  var course_related_url = [Host.api_base, 'course', ':courseName', 'projects'].join('/');
  var submissions_url = [course_related_url, ':projectName', 'submissions'].join('/');
  var project_by_id_url = [Host.api_base, 'project', ':id'].join('/');
  var common_headers = {
    'X-Auth-Token': 'Replace Me'
  }
  return $resource(url, {}, {
    query: {
      method: 'GET',
      params: {
        dest: 'projects'
      },
      isArray: true,
      headers: common_headers
    },
    get: {
      method: 'GET',
      url: project_by_id_url,
      headers: common_headers
    },
    create: {
      method: 'POST',
      headers: common_headers,
      url: course_related_url
    },
    query_related: {
      method: 'GET',
      headers: common_headers,
      url: course_related_url,
      isArray: true
    },
    get_submissions: {
      method: 'GET',
      headers: common_headers,
      url: submissions_url,
      isArray: true
    },
    post_submission: {
      method: 'POST',
      headers: common_headers,
      url: submissions_url
    }
  });
}]);


jprServices.factory('SubmissionResource', ['$resource', 'Host', function($resource, Host){
  var url = [Host.api_base, 'submission', ':id'].join('/');
  var common_headers = {
    'X-Auth-Token': 'Replace Me'
  }
  return $resource(url, {}, {
    get: {
      method: 'GET',
      headers: common_headers
    }, 
    delete: {
      method: 'DELETE',
      headers: common_headers
    }
  });
}]);