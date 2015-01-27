module.exports = function(grunt) {

   // Load grunt tasks automatically
    require('load-grunt-tasks')(grunt);

    // Time how long tasks take. Can help when optimizing build times
    require('time-grunt')(grunt);

   
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
                module: 'jpr-templates',
                singleModule: true,
                htmlmin: {
                    collapseWhitespace: true,
                }
            },
            dist: {
                src: ['app/partials/*.html'],
                dest: 'tmp/templates.js'
            }
        },
        concat: {
            options: {
                separator: ';',
                // sourceMap:true
            },
            dist: {
                src: ['app/bower_components/jquery/dist/jquery.js', 'app/bower_components/bootstrap/dist/js/bootstrap.js',
                    'app/bower_components/angular/angular.js', 'app/bower_components/angular-route/angular-route.js',
                    'app/bower_components/angular-resource/angular-resource.js', 'app/bower_components/angular-cookie/angular-cookie.js',
                    'app/bower_components/angular-local-storage/dist/angular-local-storage.js',
                    'app/bower_components/ng-file-upload/angular-file-upload-shim.js',
                    'app/bower_components/ng-file-upload/angular-file-upload.js',
                    'app/bower_components/momentjs/moment.js',
                    'app/vendor/angular-bootstrap-datetimepicker/src/js/datetimepicker.js',
                    'app/bower_components/ellipsis-animated/src/ellipsis-animated.js',
                    'app/vendor/FileSaver.js/FileSaver.js',
                    'app/*.js', 'app/*/*.js', 'tmp/*.js'
                ],
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
            },
            lib: {
                src: ['lib']
            }
        },
        watch: {
            dev: {
                files: ['app/**/*.js', 'index.html', 'app/partials/*.html'],
                tasks: ['html2js:dist', 'concat:dist', 'clean:temp'],
                 options: {
                    atBegin: true
                }
            },
            gruntfile: {
                files: ['Gruntfile.js']
            },
            min: {
                files: ['app/*.js', 'app/*/*.js', 'index.html', 'app/partials/*.html'],
                tasks: ['html2js:dist', 'concat:dist', 'uglify:dist', 'clean:temp'],
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
                    cwd: 'app/bower_components/bootstrap/dist/css/',
                    src: ['bootstrap.css.map'],
                    dest: '/stylesheets',
                    expand: true
                }, {
                    cwd: 'app/vendor/simplex/',
                    src: ['bootstrap.min.css'],
                    dest: 'stylesheets',
                    expand: true
                }, {
                    cwd: 'app/bower_components/ellipsis-animated/src/',
                    src: ['ellipsis-animated.css'],
                    dest: '/stylesheets',
                    expand: true
                }, {
                    cwd: 'app/vendor/angular-bootstrap-datetimepicker/src/css',
                    src: ['datetimepicker.css'],
                    dest: '/stylesheets',
                    expand: true
                }, {
                    src: ['favicon.ico'],
                    dest: '/'
                }, {
                    src: ['**/**'],
                    cwd: 'app/bower_components/bootstrap/fonts/',
                    dest: '/fonts',
                    expand: true
                }],

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
   
    grunt.registerTask('dev', ['bower', 'connect:server', 'watch:dev']);
    grunt.registerTask('min', ['bower', 'connect:server', 'watch:min']);
    grunt.registerTask('package', ['bower', 'html2js:dist', 'concat:dist', 'uglify:dist',
        'clean:temp', 'clean:lib', 'compress:dist'
    ]);
};
