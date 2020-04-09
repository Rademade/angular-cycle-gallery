file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
concat            = require 'gulp-concat'
nodemon           = require 'gulp-nodemon'

gulp.task 'watch', ->
  gulp.watch "#{file_manager.source}/sass/**/*",            gulp.series 'stylesheets'
  gulp.watch "#{file_manager.source}/js/application/**/*",  gulp.series 'javascript:application'
  gulp.watch "#{file_manager.source}/js/gallery/**/*",      gulp.series 'javascript:library'
  gulp.watch "#{file_manager.source}/views/**/*",           gulp.series 'layout'
  gulp.watch "#{file_manager.source}/templates/**/*",       gulp.series 'templates'

gulp.task 'server', ->
  nodemon
    script: 'server.js'
    ext: 'coffee js html jade'
    ignore: [
      "#{file_manager.build}/**/*",
      "#{file_manager.public}/**/*",
      "#{file_manager.source}/**/*",
      'gulpfile.js',
      'gulpfile.coffee'
    ]
  .on 'restart', ->
    console.log 'Express server restarted'

gulp.task 'default', gulp.series(
  'build:development',
  gulp.parallel 'watch', 'server'
)
