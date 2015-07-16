file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
rename            = require 'gulp-rename'
preprocess        = require 'gulp-preprocess'
inject            = require 'gulp-inject'
jade              = require 'gulp-jade'
series            = require 'stream-series'

gulp.task 'layout', ->
  vendor_js = gulp.src ["#{file_manager.public}/vendor.js"], read: false
  library_js = gulp.src ["#{file_manager.public}/library.js"], read: false
  application_js = gulp.src ["#{file_manager.public}/application.js"], read: false
  styles = gulp.src ["#{file_manager.public}/*.css"], read: false
  build(series(styles, vendor_js, library_js, application_js), file_manager.public)


build = (sources, dir_path)->
  gulp
    .src "#{file_manager.source}/views/index.jade"
    .pipe(jade())
    .pipe preprocess()
    .pipe inject(sources,
      addRootSlash: true
      ignorePath: dir_path
    )
    .pipe rename('index.html')
    .pipe gulp.dest(dir_path)

gulp.task 'templates', ->
  gulp
    .src('src/templates/**/*.jade')
    .pipe jade()
    .pipe gulp.dest('public/')