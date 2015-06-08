var gulp = require('gulp'),
    uglify = require('gulp-uglify'),
    minifyCSS = require('gulp-minify-css'),
    concat = require('gulp-concat'),
    rename = require('gulp-rename'),
    sass = require('gulp-ruby-sass'),
    autoprefixer = require('gulp-autoprefixer'),
    browserify = require('gulp-browserify'),
    streamify = require('gulp-streamify'),
    source = require('vinyl-source-stream'),
    coffee = require('gulp-coffee'),
    coffeelint = require('gulp-coffeelint'),
    plumber = require('gulp-plumber'),
    gutil = require('gulp-util'),
    notify = require("gulp-notify"),
    merge = require('merge-stream')
    coffeeify = require('gulp-coffeeify'),
    exorcist   = require('exorcist'),
    transform = require('vinyl-transform');

var PRO = 'pro';
var DEV = 'dev';

var env = process.argv[2] || DEV;
var path = {
    sass: './styles/sass/*.scss',
    mainsass:'./styles/sass/main.scss',
    css: './styles/css',
    coffeeLint:'.scripts/**/*.coffee',
    // coffeeFrom: ['../../src/components/fall/*.coffee','../../src/components/common/*.coffee'],
    // coffeeTo: ['./scripts/coffee/fall/*','./scripts/coffee/common/*'],
    coffee: './scripts/coffee/**/*.coffee',
    js: 'scripts/',
    jsbuild: './build/js/',
    cssbuild: './build/css/',
    images: './images/*',
    imagesbuild: './build/images/'
}


gulp.task('sass', function() {
    return gulp.src(path.mainsass)
    .pipe(plumber({errorHandler: notify.onError("Error: <%= error.message %>")}))
    .pipe(sass({
        noCache: true,
        'sourcemap=none': true,
        compass: true
    }))
    //.pipe(autoprefixer({browsers: ['last 5 versions']}))
    .pipe(gulp.dest(path.css));
});

gulp.task('lint', function () {
    return gulp.src(path.coffeeLint)
        .pipe(coffeelint({
            literate: false,
            opt:{
              indentation:{
                value: 2,
                level: 'error'
                },
              no_trailing_semicolons: {level: 'error'},
              no_trailing_whitespace: {level: 'error'},
              max_line_length: {level: 'ignore'}
          }
        }))
        .pipe(coffeelint.reporter())
});

gulp.task('coffee', ['lint'],function () {
  return gulp.src('./scripts/coffee/main.coffee', { read: false })

        // .pipe(sourcemaps.init())
        .pipe(browserify({
            debug : true,
            transform: ['coffeeify'],
            extensions: ['.coffee']
        }))
        .pipe(plumber({errorHandler: notify.onError("Error: <%= error.message %>")}))
        .pipe(transform(function () { return exorcist(path.js + 'app.map.js'); }))
        .pipe(rename('app.js'))
    // .pipe(sourcemaps.write())
        .pipe(gulp.dest(path.js))
        // .pipe(exorcist(path.js))
        // .pipe(gulp.dest(path.js));
});


var watcher = function() {
    var watcher1 = gulp.watch([path.sass, ], ['sass']);
    watcher1.on('change', function(event) {
        console.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
    });

    var watcher2 = gulp.watch(path.coffeeFrom, ['coffee']);
    watcher2.on('change', function(event) {
        console.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
    });
    var watcher3 = gulp.watch('./scripts/js/', ['build']);
    watcher2.on('change', function(event) {
        console.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
    });
}

gulp.task('minjs', function(){
    return gulp.src('scripts/app.js')
    .pipe(rename({suffix: '.min'}))
    .pipe(uglify({
      outSourceMap: true
    }))
    .pipe(gulp.dest(path.jsbuild));
});

gulp.task('mincss', function(){
    return gulp.src('./styles/css/main.css')
    .pipe(rename({suffix: '.min'}))
    .pipe(minifyCSS())
    .pipe(gulp.dest(path.cssbuild));
});
gulp.task('bowerJs', function(){

    var bDir = './bower_components';
    var libbase = [
    // "./bower_components/zepto/dist/zepto.js",
    ]

    var base =  gulp.src(libbase)
        // .pipe(filter('*.js'))
        .pipe(concat('plugin.js'))
        // .pipe(jsmin())
        .pipe(rename({suffix: '.min'}))
        .pipe(uglify())
        .pipe(gulp.dest(path.jsbuild))

    merge(base)
});
gulp.task('b', ['minjs', 'mincss', 'bowerJs'], function () {
    var images =  gulp.src(path.images)
    .pipe(gulp.dest(path.imagesbuild));

    merge(images)
});
gulp.task('default',['coffee'], watcher);
