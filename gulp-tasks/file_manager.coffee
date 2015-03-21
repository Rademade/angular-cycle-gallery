gulp              = require 'gulp'
md5               = require 'gulp-md5'
del               = require 'del'


module.exports =
  source:   'src'
  build:    'build'
  public:   'public'

  rootify: (targets, root, extension = null) ->
    targets.map (target) ->
      root + '/' + target + if extension then ".#{extension}" else ''

  hashifyFile: (directory, filename, deferred)->
    full_source_path = "#{directory}/#{filename}"
    gulp
      .src full_source_path
      .pipe md5()
      .pipe gulp.dest directory
      .on 'end', => @removeFile(full_source_path, deferred)

  removeFile: (file_path, deferred) ->
    del([file_path], -> deferred.resolve())