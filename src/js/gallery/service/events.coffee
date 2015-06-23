angular.module('cycleGallery').factory 'GalleryEvents', ->

  class GalleryEvents

    constructor: ->
      @_stack = {}

    on: (name, func) ->
      @_stack[name] ||= []
      @_stack[name].push(func)

    do: (name) ->
      @_stack[name] ||= []
      for func in @_stack[name]
        func()

    clear: ->
      @_stack = {}