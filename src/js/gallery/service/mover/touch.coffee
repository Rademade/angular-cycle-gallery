angular.module('multiGallery').service 'MoverTouch', ->

  class MoverTouch

    _mover: null
    _storage: null
    _holder: null

    trigger: false
    start_position: 0
    slide_diff: 0

    constructor: (mover, holder)->
      @_mover = mover
      @_holder = holder

    touchStart: (position)->
      @trigger = true
      @_mover._stopPreviusAnimation() # todo fix name
      @start_position = position

    touchEnd: ->
      return true unless @trigger
      @trigger = false
      @start_position = 0
      @_mover.applyIndexDiff( @_holder.getDisplayIndex() - @_mover.getTrueMoveIndex() )

    touchMove: (position)->
      return true unless @trigger
      @_mover.forceMove(position - @start_position)

