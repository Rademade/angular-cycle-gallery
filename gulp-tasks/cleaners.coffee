file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
del 			  = require 'del'
###
  Clean tasks
###

gulp.task 'clean:build', -> clean(file_manager.build)

gulp.task 'clean', gulp.series('clean:build', -> clean(file_manager.public))

clean = (dir)->
  del([dir])
