module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    bower: {
      install: {
        options: {
          install: true,
          copy: false,
          targetDir: './libs',
          cleanTargetDir: true
        }
      }
    },
    html2js: {
      options: {
        base: 'app',
        module: 'jpr-templates'
      },
      dist: {
        src: ['app/partials/*.html'],
        dest: 'tmp/templates.js'
      }
    },
    concat: {
      options: {
        separator: ';'
      },
      dist: {
        src: ['app/bower_components/jquery/dist/jquery.js', 'app/bower_components/bootstrap/dist/js/bootstrap.js',
         'app/bower_components/angular/angular.js', 'app/bower_components/angular-route/angular-route.js',
         'app/bower_components/angular-resource/angular-resource.js', 'app/bower_components/angular-cookie/angular-cookie.js',
         'app/bower_components/angular-local-storage/dist/angular-local-storage.js',
         'app/bower_components/ng-file-upload/angular-file-upload-shim.js',
         'app/bower_components/ng-file-upload/angular-file-upload.js',
         'app/bower_components/momentjs/moment.js',
         'app/*.js', 'app/*/*.js', 'tmp/*.js'],
        dest: 'app.js'
      }
    },
    uglify: {
      dist: {
        files: {
          'app.js': ['app.js']
        },
        options: {
          mangle: false
        }
      }
    },
    clean: {
      temp: {
        src: ['tmp']
      }
    },
    watch: {
      dev: {
        files: ['Gruntfile.js', 'app/*.js', 'app/*.js', '*.html'],
        tasks: ['html2js:dist', 'concat:dist', 'clean:temp'],
        options: {
          atBegin: true
        }
      },
      min: {
        files: ['Gruntfile.js', 'app/*/*.js', 'app/*.js', '*.html'],
        tasks: ['html2js:dist', 'concat:dist', 'clean:temp', 'uglify:dist'],
        options: {
          atBegin: true
        }
      }
    },
    compress: {
      dist: {
        options: {
          archive: 'lib/<%= pkg.name %>-<%= pkg.version %>.zip'
        },
        files: [{
          src: ['index.html'],
          dest: '/'
        }, {
          src: ['app.js'],
          dest: '/'
        }, {
          src: ['images/**'],
          dest: '/'
        }, {
          src: ['stylesheets/*'],
          dest: '/'
        }, 
        {
          src: ['favicon.ico'],
          dest: '/'
        }
        ],

      }
    },
    connect: {
      server: {
        options: {
          hostname: 'localhost',
          port: 8080
        }
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-compress');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-html2js');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-bower-task');
  grunt.registerTask('min', ['bower', 'connect:server', 'watch:min']);
  grunt.registerTask('package', ['bower', 'html2js:dist', 'concat:dist', 'uglify:dist',
    'clean:temp', 'compress:dist'
  ]);
};