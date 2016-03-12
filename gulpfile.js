var gulp = require('gulp');
var runSequence = require('run-sequence');
var git = require('gulp-git');
var gutil = require('gulp-util');
var fs = require('fs');
var coffee = require('gulp-coffee');
var exec = require('child_process').exec;

gulp.task('sync', function (cb) {
  exec('resin sync 120ce8f', function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
    cb(err);
  });
})

gulp.task('compile', function() {
  gulp.src('./src/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./dist/'));
});

gulp.task('commit-changes', function () {
  return gulp.src('.')
    .pipe(git.add())
    .pipe(git.commit('[Release] to fleet'));
});

gulp.task('push-to-fleet', function (cb) {
  git.push('resin', 'master', cb);
});

gulp.task('release', function (callback) {
  runSequence(
		'compile',
    'commit-changes',
    'push-to-fleet',
    function (error) {
      if (error) {
        console.log(error.message);
      } else {
        console.log('RELEASE FINISHED SUCCESSFULLY');
      }
      callback(error);
    });
});
