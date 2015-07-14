var gulp = require('gulp');
var concat = require('gulp-concat');
var uglify = require("gulp-uglify");
var ngAnnotate = require('gulp-ng-annotate');
var jshint = require('gulp-jshint');
var coffee = require('gulp-coffee');
var coffeelint = require('gulp-coffeelint');
var stylishCoffee = require('coffeelint-stylish');
var gutil = require('gulp-util');
var order = require('gulp-order');

gulp.task('src-js', function() {
  return gulp.src(['src/**/*.js'])
    .pipe(jshint())
    .pipe(jshint.reporter('jshint-stylish'))
    .pipe(concat('app-src.js'))
    .pipe(gulp.dest('./build/temp'));
});

gulp.task('src-coffee', function() {
  return gulp.src(['src/**/*.coffee'])
    .pipe(coffeelint())
    .pipe(coffeelint.reporter(stylishCoffee))
    .pipe(coffee().on('error', gutil.log))
    .pipe(concat('coffee.js'))
    .pipe(gulp.dest('./build/temp'));
});


gulp.task('scripts-no-tempaltes', ['bower', 'src-js', 'src-coffee'], function() {
  return gulp.src(['lib/**/*.js', 'build/temp/app-src.js', 'build/temp/coffee.js'])
    .pipe(order([
      'lib/jquery/dist/jquery.js',
      'lib/angular/angular.js',
      'lib/**/*.js'
      ], { base: './'}))
    .pipe(concat('app-no-template.js'))
    .pipe(gulp.dest('build/temp'));
});

gulp.task('scripts', ['scripts-no-tempaltes', 'templates'], function() {
  return gulp.src(['build/temp/app-no-template.js', 'build/templates/*.js' ])
    .pipe(concat('app.js'))
    .pipe(gulp.dest('build/'));
});

gulp.task('uglify', ['scripts-no-tempaltes', 'templates-min'], function() {
  return gulp.src(['build/temp/app-no-template.js', 'build/temp/partials.min.js'])
    .pipe(concat('app.js'))
    .pipe(ngAnnotate())
    .pipe(uglify())
    .pipe(gulp.dest('dist/'));
});
