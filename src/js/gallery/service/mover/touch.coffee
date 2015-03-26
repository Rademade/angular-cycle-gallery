angular.module('multiGallery').service 'MoverTouch', ->

  class MoverTouch

    _mover: null
    _storage: null
    _holder: null

    _trigger: false
    _start_position: 0
    _last_position: 0

    # Foce swipe tracking
    _last_track_time: null
    _last_track_position: null
    
    TRACK_TIME: 150
    MIN_POSITION_CHANGE: 30

    constructor: (mover, holder)->
      @_mover = mover
      @_holder = holder

    touchStart: (position)->
      @_trigger = true
      @_mover._stopPreviusAnimation() # TODO fix name. Like a private function
      @_start_position = position - @_mover.getUseableDiff()
      @_setPosition(0)
      # Swipe start logick
      @_startSwipeDetecting()
      @_moveTrackingReload()

    touchMove: (position)->
      return true unless @_trigger
      @_setPosition(position - @_start_position)
      @_mover.forceMove( @_getPosition() )
      @_mover._detectPosition()
      @_moveTracking()

    touchEnd: ->
      return true unless @_trigger
      @_trigger = false

      slides_diff = @_holder.getDisplayIndex() - @_mover.getTrueIndex()

      if slides_diff == 0
        @_moveTracking(yes)
        @_swipeChange() if @_isSwipeReady()
      else
        @_rerenderOnIndexDiff(slides_diff)

      @_mover._detectPositionClear()
      @_mover._animate()


    _rerenderOnIndexDiff: (slides_diff)->
      current_position_diff = @_mover.getUseableDiff()
      @_mover.applyIndexDiff( slides_diff )
      @_holder.setPosition( @_holder.getCurrentPosition() + current_position_diff )

    #
    # Swipe logic
    #

    _startSwipeDetecting: ->
      @_force_swipe = false

    _isSwipeReady: ->
      @_force_swipe

    _setPosition: (position)->
      @_last_position = position

    _getPosition: ->
      @_last_position

    _moveTrackingReload: ->
      @_last_track_time = (new Date()).getTime()
      @_last_track_position = @_getPosition()

    _moveTracking: (force = false)->
      track_timer_ready = (new Date()).getTime() - @_last_track_time > @TRACK_TIME
      force_check_conditions = force and not @_force_swipe

      if track_timer_ready or force_check_conditions
        @_force_swipe = @_checkForForceSwipe()
        @_moveTrackingReload()

    _checkForForceSwipe: ->
      position_diff = @_last_track_position - @_getPosition()
      return Math.abs(position_diff) > @MIN_POSITION_CHANGE

    _swipeChange: ->
      if @_mover.getAnimationSide() == @_mover.ANIMATION_SIDE_NEXT
        @_mover.animateNext()
      else
        @_mover.animatePrev()
        

