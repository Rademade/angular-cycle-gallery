gulp              = require 'gulp'

gulp.task 'build:production', gulp.series('clean:build', ->
  gulp.start ['javascript:build'], ->
    gulp.start ['stylesheets:build'], ->
      console.log('Production build finished')
)

gulp.task 'build:development', gulp.series('clean', ->
  gulp.start ['javascript'], ->
    gulp.start ['stylesheets'], ->
      gulp.start ['layout'], ->
      gulp.start ['templates'], ->
        console.log('Development build finished')
)
