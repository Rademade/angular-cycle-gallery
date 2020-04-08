gulp              = require 'gulp'

gulp.task 'build:production', gulp.series(
  'clean:build',
  'javascript:build',
  'stylesheets:build',
  -> console.log('Production build finished'),
)

gulp.task 'build:development', gulp.series(
  'clean',
  'javascript',
  'stylesheets',
  'layout',
  'templates',
  -> console.log('Development build finished'),
)
