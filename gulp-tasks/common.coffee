file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
concat            = require 'gulp-concat'
nodemon           = require 'gulp-nodemon'

gulp.task 'default', ->
  gulp.start ['build:development', 'watch', 'server'], ->
    console.log('Run')

gulp.task 'watch', ->
  gulp.watch "#{file_manager.source}/sass/**/*",            ['stylesheets']
  gulp.watch "#{file_manager.source}/js/application/**/*",  ['javascript:application']
  gulp.watch "#{file_manager.source}/js/gallery/**/*",      ['javascript:library']
  gulp.watch "#{file_manager.source}/views/**/*",           ['layout']

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