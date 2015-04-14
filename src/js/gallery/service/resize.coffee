angular.module('multiGallery').service 'Resize', ->

  class Resize

    mover: null
    holder: null

    resizeTimeout: 0
    resizeDelay: 0

    constructor: (mover, holder)->
      @mover = mover
      @holder = holder

    do: =>
      clearTimeout(@resizeTimeout)
      @resizeTimeout = setTimeout (=> @_resize()), @resizeDelay

    _resize: ->
      @holder.update()
      @mover._rerender()

