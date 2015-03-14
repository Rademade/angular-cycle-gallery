angular.module('multiGallery').service 'GalleryMover', ->

  class GalleryMover

    ANIMATION_TIME: 300
    ANIMATION_SIDE_NEXT: 1
    ANIMATION_SIDE_PREV: 2

    _storage: null
    _renderer: null
    _holder: null
    _$scope: null

    _animation: null

    _checked_position: null

    _itemWidth: 0
    _moveIndex: 0

    # Public methods

    constructor: (storage, renderer, holder, $scope)->
      @_storage = storage
      @_renderer = renderer
      @_holder = holder
      @_$scope = $scope

    render: (items)->
      @_storage.setItems(items)
      @_renderer.render( @_storage.getNearestRange() )
      @_holder.update()
      @_syncMoveIndex()
      @_applyCurrentIndexPosition()

    setIndex: (index)->
      return @_stopAnimationSide() if @_animation_side
      @_storage.setIndex(index)
      @_syncMoveIndex()
      @_stopPreviusAnimation()
      @_rerender()

    next: ->
      return @_stopAnimationSide() if @_animation_side
      @_storage.nextIndex()
      @_syncMoveIndex()
      @_rerender()

    prev: ->
      return @_stopAnimationSide() if @_animation_side
      @_storage.prevIndex()
      @_syncMoveIndex()
      @_rerender()

    animateNext: ->
      return @_stopAnimationSide() if @_animation_side == @ANIMATION_SIDE_PREV
      @_storage.incNextBuffer()
      @_animate()

    animatePrev: ->
      return @_stopAnimationSide() if @_animation_side == @ANIMATION_SIDE_NEXT
      @_storage.incPrevBuffer()
      @_animate()

    forceMove: (position)->
      @_holder.setPosition( @_getPositionForMoveIndex() + position )
      @_detectPosition()

    applyIndexDiff: (index_diff)->
      @_storage.setIndex( @_storage.getIndex() + index_diff )
      @_animationRender()
      @_syncMoveIndex()
      @_holder.setPosition( @_getPositionForMoveIndex() )
      @_detectPositionClear()


    # Animation block

    _defaultAnimationTime: ->
      @ANIMATION_TIME/1000

    _stopPreviusAnimation: ->
      @_animation.pause() if @_animation
      @_animation.kill() if @_animation

    _stopAnimationSide: ->
      @_stopPreviusAnimation()
      @_animation_side = null
      @_storage.clearRangeBuffer()
      @_syncMoveIndex()
      @_rerender()

    _animate: (
      time = @_defaultAnimationTime()
      position = @_getPositionForCurrentIndex()
    )->
      @_stopPreviusAnimation()
      # Todo make request animation frame animation
      @_animation = TweenMax.to(@_holder.getElement(), time, {
        left: position + 'px'
        ease: Linear.easeNone
        onUpdate: => @_checkFrameChange()
        onComplete: => @_onCompleteAnimation()
      })

    _onCompleteAnimation: ->
      @_detectPositionClear()
      @_storage.clearRangeBuffer()
      @_syncMoveIndex()
      @_rerender()

    _detectPosition: ->
      @_holder.createPositionLock()
      position_diff = @_holder.getPositionLockDiff()
      return false unless Math.abs(position_diff) > 5
      if position_diff < 0
        @_animation_side = @ANIMATION_SIDE_NEXT
      else
        @_animation_side = @ANIMATION_SIDE_PREV
      return true

    _detectPositionClear: ->
      @_holder.clearPositionLock()
      @_animation_side = null

    _checkFrameChange: (changeCallback)->
      return unless @_detectPosition()

      return false if (display_index = @_holder.getDisplayIndex()) == @getMoveIndex()
      @_stopPreviusAnimation()

      # Positions
      $current_element = @_renderer.getElementByIndex(display_index)
      right_items_count = @_renderer.getRightElementsCount($current_element )

      # Render
      @_animationRender()

      new_right_items_count = @_renderer.getRightElementsCount($current_element )

      # Change current index
      if @_animation_side == @ANIMATION_SIDE_NEXT
        @_moveIndex++
        moveToPosition = @_getPositionForCurrentIndex()
      else
        @_moveIndex = @_renderer.getRenderedCount() - right_items_count
        moveToPosition = @_holder.__calculatePositionForIndex( @_storage.NEAREST_ITEMS )

        # todo fix position. Has problem
        @_holder.setPosition( @_getPositionForMoveIndex() + @_holder.getSlideDiff() )

      # Change position
      @_detectPositionClear()

      # Animate
      @_animate(null, moveToPosition)


    # Index and position calculation

    _applyMoveIndexPosition: -> @_holder.setPosition( @_getPositionForMoveIndex() )
    _applyCurrentIndexPosition: -> @_holder.setPosition( @_getPositionForCurrentIndex() )

    _getPositionForMoveIndex: -> @_holder.__calculatePositionForIndex(@getMoveIndex())
    _getPositionForCurrentIndex: -> @_holder.__calculatePositionForIndex(@getTrueMoveIndex())

    getTrueMoveIndex: -> @_storage.getCurrentIndexInRange()
    getMoveIndex: -> @_moveIndex
    _syncMoveIndex: ->  @_moveIndex = @getTrueMoveIndex()


    # Render function

    _animationRender: ->
      @_renderer.render( @_storage.getNearestRange() )
      @_$scope.$apply()

    _rerender: ->
      @_renderer.render( @_storage.getNearestRange() )
      @_applyMoveIndexPosition()
      @_$scope.$apply() unless @_$scope.$$phase