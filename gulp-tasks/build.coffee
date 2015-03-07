gulp              = require 'gulp'

gulp.task 'build:production', ['clean:build'], ->
  gulp.start ['javascript:build'], ->
    gulp.start ['stylesheets:build'], ->
      gulp.start ['layout:build'], ->
        console.log('Production build finished')

gulp.task 'build:development', ['clean'], ->
  gulp.start ['javascript'], ->
    gulp.start ['stylesheets'], ->
      gulp.start ['layout'], ->
        console.log('Development build finished')
