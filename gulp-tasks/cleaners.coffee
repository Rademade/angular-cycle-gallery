file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
rimraf            = require 'gulp-rimraf'

###
  Clean tasks
###

gulp.task 'clean:build', -> clean(file_manager.build)

gulp.task 'clean', ['clean:build'], -> clean(file_manager.public)

clean = (dir)->
  gulp.src(dir, read: no).pipe rimraf()