angular.module('cycleGallery').factory 'Resize', ->

  class Resize

    constructor: (mover, holder) ->
      @mover = mover
      @holder = holder
      @resizeTimeout = 0
      @resizeDelay = 0

    do: =>
      clearTimeout(@resizeTimeout)
      @resizeTimeout = setTimeout (=> @_resize()), @resizeDelay

    _resize: ->
      @holder.update()
      @mover._rerender()

