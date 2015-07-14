var gulp = require('gulp');
var manifest = require('gulp-manifest');

var manifestOptions = {
  hash: false,
  timestamp: true,
  filename: 'jpr.appcache',
  exclude: 'jpr.appcache'
};


gulp.task('manifest', ['scripts', 'assets', 'css'], function() {
  return gulp.src(['build/**'])
    .pipe(manifest(manifestOptions))
    .pipe(gulp.dest('./build'));
});

gulp.task('manifest-dist', ['uglify', 'assets', 'css-min'], function() {
  return gulp.src(['dist/**'])
    .pipe(manifest(manifestOptions))
    .pipe(gulp.dest('./dist'));
});
