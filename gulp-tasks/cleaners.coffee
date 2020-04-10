file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
del 			  = require 'del'
###
  Clean tasks
###

gulp.task 'clean:build', (cb) -> clean(file_manager.build); cb()

gulp.task 'clean', gulp.series('clean:build', (cb) -> clean(file_manager.public); cb())

clean = (dir)->
  del([dir])
