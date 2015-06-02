// static assets
var gulp = require('gulp');
var minifyHtml = require("gulp-minify-html");

gulp.task('assets',['move-index', 'move-images', 'move-index-min']);

gulp.task('move-index', function() {
  return gulp.src('src/index.html')
    .pipe(gulp.dest('./build'));
});

gulp.task('move-index-min', function() {
  return gulp.src('src/index.html')
    .pipe(minifyHtml())
    .pipe(gulp.dest('./dist'))
});

gulp.task('move-images', function() {
  return gulp.src('images/*', {base: './'})
    .pipe(gulp.dest('./dist'))
    .pipe(gulp.dest('./build'))
});

