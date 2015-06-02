// bower components
var gulp = require('gulp');
var bower = require('gulp-bower');
var mainBowerFiles = require('main-bower-files');

gulp.task('bower-install', function() {
  // Runs bower install
  return bower()
    .pipe(gulp.dest('./bower_components'));
});

gulp.task('bower', ['bower-install'], function() {
  // moves main files to lib folder
  return gulp.src(mainBowerFiles(), {base: './bower_components'})
    .pipe(gulp.dest('./lib'));
});