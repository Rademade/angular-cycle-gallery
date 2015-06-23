angular.module('cycleGallery').factory 'ResizeEmulator', [
  'ResizeEmulatorAction', '$window',
  (ResizeEmulatorAction, $window)->

    class ResizeEmulator

      constructor: ->
        @_storage = []
        angular.element($window).bind 'resize orientationchange', => @onResize()

      onResize: ->
        if @_storage.length > 0
          for action in @_storage
            action.apply()

      bind: (fn, key) ->
        action = @actionExists(key)
        if action
          action.fn = fn
        else
          action = new ResizeEmulatorAction(fn, key)
          @_storage.push(action)

      actionExists: (key) ->
        for action in @_storage
          if action.key == key
            return action
        false

      unbind: (key) ->
        @_storage[key] ||= []

]