var gulp = require('gulp');
var runSequence = require('run-sequence');
var git = require('gulp-git');
var gutil = require('gulp-util');
var fs = require('fs');
var coffee = require('gulp-coffee');
var gitS = require('gulp-git-streamed');

gulp.task('compile', function() {
  gulp.src('./src/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./dist/'));
});

gulp.task('commit-changes', function () {
  return gulp.src('.')
    .pipe(git.add())
    .pipe(git.commit('[Release] to production fleet'));
});

gulp.task('push-changes', function (cb) {
  git.push('resin', 'master', cb);
});

gulp.task('publish', function() {
    var version = '1.2.3';
    var message = 'Release version ' + version;
    return gulp.src('.')
        .pipe(gitS.add())
        .pipe(gitS.commit(message))
				.pipe(gitS.push('resin', 'master'))
});

gulp.task('release', function (callback) {
  runSequence(
		'compile',
    'commit-changes',
    'push-changes',
    function (error) {
      if (error) {
        console.log(error.message);
      } else {
        console.log('RELEASE FINISHED SUCCESSFULLY');
      }
      callback(error);
    });
});
