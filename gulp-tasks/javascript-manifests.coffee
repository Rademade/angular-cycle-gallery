module.exports = (->

  file_manager      = require './file_manager.coffee'

  manifests = {}

  manifests.vendor = ->
    file_manager.rootify [
      'angular/angular'
      'angular-swipe/dist/angular-swipe'
    ], "bower_components", 'js'

  manifests.library = ->
    file_manager.rootify [
      'gallery/module'
      'gallery/**/*'
    ], "#{file_manager.source}/js", 'coffee'

  manifests.application = ->
    file_manager.rootify [
      'application/app'
      "application/**/*"
    ], "#{file_manager.source}/js", 'coffee'

  manifests

)()