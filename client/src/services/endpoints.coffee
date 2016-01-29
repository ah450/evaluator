angular.module 'evaluator'
  .factory 'endpoints', (apiHost) ->
    endpoints =
      configurations:
        index: [apiHost, 'configurations.json'].join '/'
      users:
        resourceUrl: [apiHost, 'users', ':id.json'].join '/'
      courses:
        resourceUrl: [apiHost, 'courses', ':id.json'].join '/'
      courseProjects:
        resourceUrl: [apiHost, 'courses', ':course_id', 'projects.json'].join '/'
      project:
        resourceUrl: [apiHost, 'projects', ':id.json'].join '/'
      projectSuites:
        resourceUrl: [apiHost, 'projects', ':project_id', 'test_suites.json'].join '/'
      suite:
        resourceUrl: [apiHost, 'test_suites', ':id.json'].join '/'
        downloadUrl: [apiHost, 'test_suites', ':id', 'download'].join '/'