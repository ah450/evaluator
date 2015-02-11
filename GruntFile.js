module.exports = function(grunt) {

   // Load grunt tasks automatically
    require('load-grunt-tasks')(grunt);

    // Time how long tasks take. Can help when optimizing build times
    require('time-grunt')(grunt);

   
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        config: grunt.file.readJSON('bower.json'),
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
                src: ['app/partials/*.html', 'app/bower_components/angular-utils-pagination/*.html'],
                dest: 'tmp/templates.js'
            }
        },
        // Compiles Sass to CSS and generates necessary files if requested
        compass: {
            options: {
                sassDir: '<%= config.app %>/style',
                cssDir: 'stylesheets',
                generatedImagesDir: 'tmp/images/generated',
                imagesDir: '/images',
                javascriptsDir: '<%= config.app %>',
                fontsDir: 'fonts',
                importPath: '<%= config.app %>/bower_components',
                httpImagesPath: '/images',
                httpGeneratedImagesPath: '/images/generated',
                httpFontsPath: 'fonts',
                relativeAssets: false,
                assetCacheBuster: false,
                raw: 'Sass::Script::Number.precision = 10\n'
            },
            dist: {
               options: {
               }
            },
            server: {
                options: {
                    debugInfo: true
                }
            }
        },
        autoprefixer: {
            options: {
                browsers: ['last 1 version']
            },
            dist: {
                files: [{
                    expand: true,
                    cwd: '.tmp/style/',
                    src: '{,*/}*.css',
                    dest: '.tmp/style/'
                }]
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
                    'app/bower_components/angular-utils-pagination/dirPagination.js',
                    'app/bower_components/momentjs/moment.js',
                    'app/vendor/angular-bootstrap-datetimepicker/src/js/datetimepicker.js',
                    'app/bower_components/ellipsis-animated/src/ellipsis-animated.js',
                    'app/vendor/Blob.js/Blob.js',
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
                src: ['tmp', 'stylesheets']
            },
            lib: {
                src: ['lib']
            }
        },
        watch: {
            dev: {
                files: ['app/**/*.js'],
                tasks: ['concat:dist'],
                options: {
                    atBegin: true
                }
            },
            html2js: {
                files:['app/partials/*.html'],
                tasks:['html2js:dist', 'concat:dist'],
                options: {
                    atBegin: true
                }
            },
            compass: {
                files: ['<%= config.app %>/style/{,*/}*.{scss,sass}'],
                tasks: ['compass:server', 'autoprefixer'],
                options: {
                    atBegin: true
                }
            },
            gruntfile: {
                files: ['Gruntfile.js']
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
                    src: ['app/dirPagination.tpl.html']m
                    dest: '/app'
                },
                 {
                    src: ['images/**'],
                    dest: '/'
                }, {
                    src: ['stylesheets/**'],
                    dest: '/'
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
   
    grunt.registerTask('dev', ['bower', 'connect:server', 'clean:temp', 'watch']);
    grunt.registerTask('package', ['bower', 'clean:temp','html2js:dist', 'concat:dist', 'compass:dist', 'uglify:dist',
         'clean:lib', 'compress:dist'
    ]);
};
