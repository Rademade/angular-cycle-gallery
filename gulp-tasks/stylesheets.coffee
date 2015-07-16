file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
sass              = require 'gulp-sass'
concat            = require 'gulp-concat'
minifyCSS         = require 'gulp-minify-css'
plumber           = require 'gulp-plumber'
Q                 = require 'q'


###
  Stylesheets tasks
###

gulp.task 'stylesheets:build', ->
  compileStylesheets file_manager.build, 'stylesheets.min.css'


gulp.task 'stylesheets', ->
  compileStylesheets file_manager.public, 'stylesheets.css'


compileStylesheets = (build_directory, name, opts = {}) ->
  file_name = 'import'

  deferred = Q.defer()

  stream = gulp
    .src("#{file_manager.source}/sass/#{file_name}.sass")
    .pipe sass(
      indentedSyntax: true
      cache: false
      sourcemap: no,
      bundle_exec: yes
    )
  stream = stream.pipe minifyCSS() if opts.compress
  stream = stream.pipe concat(name)
  stream = stream.pipe gulp.dest(build_directory)

  stream.on 'end', -> file_manager.removeFile("#{build_directory}/#{file_name}.css", deferred)

  deferred.promise
