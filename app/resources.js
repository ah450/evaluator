// RESTFUL services

jprServices.factory('CourseResource', ['$resource', 'Host',
  function($resource, Host) {
    var url = [Host.base, ':dest', ':name', ':ep'].join('/');

    return $resource(url, {}, {
      query: {
        method: 'GET',
        params: {
          dest: 'courses'
        },
        isArray: true,
        headers: {
          'X-Auth-Token': 'Replace Me'
        }
      },
      create: {
        method: 'POST',
        params: {
          dest: 'courses'
        },
        headers: {
          'X-Auth-Token': 'Replace Me'
        }
      },
      get: {
        method: 'GET',
        params: {
          dest: 'course'
        },
        headers: {
          'X-Auth-Token': 'Replace Me'
        }
      },
      update: {
        method: 'PUT',
        params: {
          dest: 'course'
        },
        headers: {
          'X-Auth-Token': 'Replace Me'
        }
      },
      add_teacher: {
        method: 'POST',
        params: {
          dest: 'course',
          ep: 'tas'
        },
        headers: {
          'X-Auth-Token': 'Replace Me'
        },

      },
      add_student: {
        method: 'POST',
        params: {
          dest: 'course',
          ep: 'students'
        },
        headers: {
          'X-Auth-Token': 'Replace Me'
        },
      },
      delete: {
        method: 'DELETE',
        params: {
          dest: 'course'
        },
        headers: {
          'X-Auth-Token': 'Replace Me'
        }
      }
    });

  }
]);



jprServices.factory('UserResource', ['$resource', 'Host', function($resource, Host) {
  var url = [Host.base, ':dest', ':id'].join('/');
  return $resource(url, {}, {
    query: {
      method: 'GET',
      params: {
        dest: 'users'
      },
      isArray: true,
      headers: {
        'X-Auth-Token': 'Replace Me'
      }
    },
    create: {
      method: 'POST',
      params: {
        dest: 'users'
      },
      headers: {
        'X-Auth-Token': 'Replace Me'
      }
    },
    update: {
      method: 'PUT',
      params: {
        dest: 'user'
      },
      headers: {
        'X-Auth-Token': 'Replace Me'
      }
    },
    delete: {
      method: 'DELETE',
      params: {
        dest: 'user'
      },
      headers: {
        'X-Auth-Token': 'Replace Me'
      }
    },
    get: {
      method: 'GET',
      params: {
        dest: 'user'
      },
      headers: {
        'X-Auth-Token': 'Replace Me'
      }
    }
  });
}]);


jprServices.factory('ProjectResource', ['$resource', 'Host', function($resource, Host) {
  var url = [Host.base, ':dest'].join('/');
  var course_related_url = [Host.base, 'course', ':courseName', 'projects'].join('/');
  var submissions_url = [course_related_url, ':projectName', 'submissions'].join('/');
  var project_by_id_url = [Host.base, 'project', ':id'].join('/');
  return $resource(url, {}, {
    query_all: {
      method: 'GET',
      params: {
        dest: 'projects'
      },
      isArray: true,
      headers: {
        'X-Auth-Token': 'Replace Me'
      }
    },
    get: {
      method: 'GET',
      url: project_by_id_url,
      headers: {
        'X-Auth-Token': 'Replace Me'
      }
    },
    create: {
      method: 'POST',
      headers: {
        'X-Auth-Token': 'Replace Me'
      },
      url: course_related_url
    },
    query: {
      method: 'GET',
      headers: {
        'X-Auth-Token': 'Replace Me'
      },
      url: course_related_url,
      isArray: true
    },
    get_submissions: {
      method: 'GET',
      headers: {
        'X-Auth-Token': 'Replace Me'
      },
      url: submissions_url,
      isArray: true
    },
    post_submission: {
      method: 'POST',
      headers: {
        'X-Auth-Token': 'Replace Me'
      },
      url: submissions_url
    }
  });
}]);