file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
compass           = require 'gulp-compass'
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
    .pipe compass(
      css: build_directory
      sass: "#{file_manager.source}/sass"
      path: '/'
      image: "#{build_directory}/images"
      sourcemap: no,
      bundle_exec: yes
    )
  stream = stream.pipe minifyCSS() if opts.compress
  stream = stream.pipe concat(name)
  stream = stream.pipe gulp.dest(build_directory)

  stream.on 'end', -> file_manager.removeFile("#{build_directory}/#{file_name}.css", deferred)

  deferred.promise