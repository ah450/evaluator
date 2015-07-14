// Compiles sass
// Outputs main.css as topfile in build and dist folders
var gulp = require('gulp');
var concatCss = require('gulp-concat-css');
var sass = require('gulp-sass');
var minifyCss = require('gulp-minify-css');
var postcss = require('gulp-postcss');
var autoprefixer = require('autoprefixer-core');

gulp.task('css-min', ['css'], function() {
  return gulp.src('build/main.css')
    .pipe(minifyCss())
    .pipe(gulp.dest('dist'));
});

gulp.task('css',['sass', 'bower'], function() {
  return gulp.src(['./lib/**/*.css', './build/css/*.css'])
    .pipe(concatCss('main.css'))
    .pipe(postcss([autoprefixer({browsers: ['last 5 version']})]))
    .pipe(gulp.dest('./build/'));
});

gulp.task('sass', function() {
  return gulp.src('./src/style/main.scss')
    .pipe(sass())
    .pipe(gulp.dest('./build/css'));
});