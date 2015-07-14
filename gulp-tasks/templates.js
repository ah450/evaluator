var gulp = require('gulp');
var gulp = require('gulp');
var concat = require('gulp-concat');
var ngHTML2JS = require('gulp-ng-html2js');
var minifyHtml = require("gulp-minify-html");

var html2jsOptions = {
  moduleName: 'jpr-templates',
  prefix: 'views/'
};

gulp.task('templates', function() {
  // Turns templates to html
  return gulp.src(['src/views/**/*.html'])
    .pipe(ngHTML2JS(html2jsOptions))
    .pipe(gulp.dest('./build/templates'));
});

gulp.task('templates-min', function() {
  return gulp.src(['src/views/**/*.html'])
    .pipe(minifyHtml({
      empty: true
    }))
    .pipe(ngHTML2JS(html2jsOptions))
    .pipe(concat('partials.min.js'))
    .pipe(gulp.dest('./build/temp/'));
})