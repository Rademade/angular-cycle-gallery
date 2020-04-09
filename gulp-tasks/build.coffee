gulp              = require 'gulp'

gulp.task 'build:production', gulp.series(
  'clean:build',
  'javascript:build',
  'stylesheets:build',
  (cb) -> console.log('Production build finished'); cb(),
)

gulp.task 'build:development', gulp.series(
  'clean',
  'javascript',
  'stylesheets',
  'layout',
  'templates',
  (cb) -> console.log('Development build finished'); cb(),
)
