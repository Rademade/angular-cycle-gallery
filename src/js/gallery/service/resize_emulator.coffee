angular.module('cycleGallery').factory 'ResizeEmulator', [
  'ResizeEmulatorAction', '$window',
  (ResizeEmulatorAction, $window) ->

    class ResizeEmulator

      constructor: ->
        @_storage = []
        angular.element($window).bind 'resize orientationchange', => @onResize()

      onResize: ->
        if @_storage.length > 0
          for action in @_storage
            action.apply()

      # TODO change params order
      bind: (callback, key) ->
        if action = @actionExists(key)
          action.fn = callback
        else
          action = new ResizeEmulatorAction(callback, key)
          @_storage.push(action)

      actionExists: (key) ->
        for action in @_storage
          return action if action.key == key
        false

      unbind: (key) ->
        @_storage[key] ||= []

]