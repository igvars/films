/**
 * Put here your scripts, what need to build
 */
var scripts 	= [
        // Package libraries here
        'node_modules/angular/angular.min.js',
        'node_modules/angular-route/angular-route.min.js',
        'node_modules/angular-resource/angular-resource.min.js',
        'node_modules/ng-infinite-scroll/build/ng-infinite-scroll.min.js',
        'node_modules/angular-aria/angular-aria.min.js',
        'node_modules/angular-animate/angular-animate.min.js',
        'node_modules/angular-material/angular-material.min.js',

        'node_modules/jquery/dist/jquery.min.js',
        'node_modules/bootstrap-sass/assets/javascripts/bootstrap.min.js',

        // Another scripts here
        'src/js/controllers.js'
    ],
    watchCoffee	=[
        'src/coffee/*.coffee'
    ],
    watchScripts	=[
        'src/js/*.js'
    ],
    styles 	= [
        'src/scss/styles.scss'
    ],
    watchStyles 	= [
        'src/scss/*.scss'
    ],
    wantToMove = [
        {
            from: 'node_modules/bootstrap-sass/assets/fonts/bootstrap/*',
            to: 'dist/fonts/bootstrap'
        }
    ],

// define libraries
    gulp 			= require('gulp'),
    autoPrefixer 	= require('gulp-autoprefixer'),
    concat 			= require('gulp-concat'),
    uglify 			= require('gulp-uglify'),
    plumber 		= require('gulp-plumber'),
    sourcemaps      = require('gulp-sourcemaps'),
    sass 			= require('gulp-sass');
coffee 			= require('gulp-coffee');

// Handler for exception
function errorHandler(error){
    console.error('Gulp build error!');
    console.error(error.message);
    this.emit('end');
}

/**
 * Move any files
 */
gulp.task('move', function(){
    if(!wantToMove.length)
        return true;

    for(var i in wantToMove){
        if(wantToMove.hasOwnProperty(i)) {
            gulp.src(wantToMove[i].from)
                .pipe(plumber({errorHandler: errorHandler}))
                .pipe(gulp.dest(wantToMove[i].to));
        }
    }
});

/**
 * Build SASS files, concat and minify for production
 * */
gulp.task('styles', function(){
    gulp.src(styles)
        .pipe(plumber({errorHandler: errorHandler}))
        .pipe(sourcemaps.init())
        .pipe(sass({outputStyle: 'compressed'}))
        .pipe(sourcemaps.write())
        .pipe(autoPrefixer({browsers: ['last 15 versions', '> 1%']}))
        .pipe(concat('styles.min.css'))
        .pipe(gulp.dest('dist/css'));
});


gulp.task('coffee', function() {
    gulp.src('./src/coffee/*.coffee')
        .pipe(coffee({bare: true}))
        .pipe(gulp.dest('./src/js/'));
});

/**
 * Concat, minify and move to right folder
 */
gulp.task('scripts', function(){
    gulp.src(scripts)
        .pipe(plumber({errorHandler: errorHandler}))
        .pipe(concat('scripts.min.js'))
        .pipe(uglify())
        .pipe(gulp.dest('dist/js'));
});
/**
 * Run gulp watcher, for listen to changes of watch files
 */
gulp.task('watch', function(){
    gulp.watch(watchStyles, ['styles']);
    gulp.watch(watchCoffee, ['coffee']);
    gulp.watch(watchScripts, ['scripts']);
});

/**
 * Default task for gulp
 */
gulp.task('default', ['styles', 'coffee', 'scripts', 'move']);