angular.module('multiGallery').service 'ResizeEmulator', [ '$window', ($window)->

  class ResizeEmulator

    @_storage = []

    constructor: ->
      @_storage = []
      angular.element($window).bind('resize orientationchange', => @onResize())

    onResize: ->
      if @_storage.length > 0
        for action in @_storage
          action.apply()

    bind: (fn, key) ->
      action = @actionExists(key)
      if action
        action.fn = fn
      else
        action = new Action(fn, key)
        @_storage.push(action)

    actionExists : (key)->
      for action in @_storage
        if action.key == key
          return action
      false

    unbind: (key)->
      @_storage[key] = []

  class Action
    @key = null
    @fn = null

    constructor : (fn, key)->
      @fn = fn
      @key = key

    apply : ->
        @fn.call()

  window.resizeEmulator = new ResizeEmulator() unless window.resizeEmulator

]