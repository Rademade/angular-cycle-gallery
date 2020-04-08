file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
concat            = require 'gulp-concat'
uglify            = require 'gulp-uglify'
manifests         = require './javascript-manifests.coffee'
coffee            = require 'gulp-coffee'
plumber           = require 'gulp-plumber'
Q                 = require 'q'

###
  JavaScript tasks
###

gulp.task 'javascript:application', ->
  collectJavaScript manifests.application(), 'application.js', file_manager.public, coffee: yes

gulp.task 'javascript:library', ->
  collectJavaScript manifests.library(), 'library.js', file_manager.public, coffee: yes

gulp.task 'javascript:vendor', ->
  collectJavaScript manifests.vendor(), 'vendor.js', file_manager.public, coffee: no

gulp.task 'javascript', gulp.series(
  'javascript:vendor',
  'javascript:application'
  'javascript:library',
)

###
  JavaScript build tasks
###

gulp.task 'javascript:build', gulp.series('javascript', ->
  files = [
    "#{file_manager.public}/library.js"
  ]

  collectJavaScript(files, 'angular-cycle-gallery.js', file_manager.build, {coffee: no})
  collectJavaScript(files, 'angular-cycle-gallery.min.js', file_manager.build, {coffee: no, compress: yes})
)


###
  JavaScript private methods
###

collectJavaScript = (source, name, destination, opts = {}) ->
  stream = gulp.src source
  stream = stream.pipe plumber()

  stream = stream.pipe coffee(bare: no) if opts.coffee
  stream = stream.pipe uglify() if opts.compress

  stream.pipe(concat(name)).pipe(gulp.dest(destination))
