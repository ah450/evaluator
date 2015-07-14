var gulp = require('gulp');
var fs = require('fs');
var del = require('del');
var connect = require('gulp-connect');
var watch = require('gulp-watch');
var requireDir = require('require-dir');
requireDir('./gulp-tasks');


gulp.task('clean', function() {
  var dirs = ['./dist', './build', './lib', './temp'];
  del.sync(dirs);
  dirs.forEach(function(dir) {
    fs.mkdirSync(dir);
  });
});

gulp.task('webserver', ['assets', 'scripts', 'watch', 'css', 'manifest'], function() {
  connect.server({
    livereload: true,
    root: 'build'
  });
});

gulp.task('watch', function() {
  watch('./src/**', function() {
    gulp.start('reload')
  });
});

gulp.task('reload', ['assets', 'scripts', 'css', 'manifest'], function() {
  return gulp.src('./build/**/*')
    .pipe(connect.reload());
});

gulp.task('dev', ['clean'], function() {
  return gulp.start('webserver');
});

gulp.task('default', ['dev']);


gulp.task('dist', ['clean'], function() {
  return gulp.start('uglify', 'css-min', 'assets', 'manifest-dist');
});