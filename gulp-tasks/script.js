var gulp = require('gulp');
var concat = require('gulp-concat');
var uglify = require("gulp-uglify");
var ngAnnotate = require('gulp-ng-annotate');
var jshint = require('gulp-jshint');

gulp.task('src', ['bower'], function() {
  return gulp.src(['src/**.js'])
    .pipe(jshint())
    .pipe(jshint.reporter('jshint-stylish'))
    .pipe(concat('app.js'))
    .pipe(gulp.dest('./build'));
});

gulp.task('scripts', ['bower', 'src', 'templates'], function() {
  return gulp.src([ './lib/*.js', './lib/**/*.js', './build/*.js'])
    .pipe(concat('app.js'))
    .pipe(gulp.dest('./build/'));
});


gulp.task('uglify', ['scripts', 'templates-min'], function() {
  return gulp.src(['./build/app.js', './temp/partials.min.js'])
    .pipe(concat('app.js'))
    .pipe(ngAnnotate())
    .pipe(uglify())
    .pipe(gulp.dest('./dist/'));
});