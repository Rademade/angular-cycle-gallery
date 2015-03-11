angular.module('multiGallery').service 'GalleryMover', ->

  class GalleryMover

    ANIMATION_TIME: 3000
    ANIMATION_SIDE_NEXT: 1
    ANIMATION_SIDE_PREV: 2

    _storage: null
    _renderer: null
    _$holder: null
    _$scope: null

    _animation: null

    _itemWidth: 0
    _moveIndex: 0

    # Public methods

    constructor: (storage, renderer, $holder, $scope)->
      @_storage = storage
      @_renderer = renderer
      @_$holder = $holder
      @_$scope = $scope

    render: (items)->
      @_storage.setItems(items)
      @_renderer.render( @_storage.getNearestRange() )
      @_loadElementInfo()
      @_syncMoveIndex()
      @_applyCurrentIndexPosition()

    setIndex: (index)->
      @_storage.setIndex(index)
      @_syncMoveIndex()
      @_stopPreviusAnimation()
      @_rerender()

    next: ->
      @_storage.nextIndex()
      @_syncMoveIndex()
      @_rerender()

    prev: ->
      @_storage.prevIndex()
      @_syncMoveIndex()
      @_rerender()

    animateNext: ->
      return @_changeAnimationSide() if @_animation_side == @ANIMATION_SIDE_PREV
      @_animation_side = @ANIMATION_SIDE_NEXT
      @_storage.incNextBuffer()
      @_animate()

    animatePrev: ->
      return @_changeAnimationSide() if @_animation_side == @ANIMATION_SIDE_NEXT
      @_animation_side = @ANIMATION_SIDE_PREV
      @_storage.incPrevBuffer()
      @_animate()

  
    # Animation block

    _defaultAnimationTime: ->
      @ANIMATION_TIME/1000

    _stopPreviusAnimation: ->
      @_animation.pause() if @_animation
      @_animation.kill() if @_animation

    _changeAnimationSide: ->
      @_stopPreviusAnimation()
      @_animation_side = null
      @_storage.clearRangeBuffer()
      @_syncMoveIndex()
      @_rerender()

    _animate: (
      time = @_defaultAnimationTime()
      position = @_positionForMoveIndex()
    )->
      @_stopPreviusAnimation()
      # Todo make request animation frame animation
      @_animation = TweenMax.to(@_$holder, time, {
        left: position + 'px'
        ease: Linear.easeNone
        onUpdate: => @_checkFrameChange()
        onComplete: => @_onCompleteAnimation()
      })

    _onCompleteAnimation: ->
      @_animation_side = null
      @_storage.clearRangeBuffer()
      @_syncMoveIndex()
      @_rerender()

    _checkFrameChange: (changeCallback)->
      return false if (display_index = @_getDisplayIndex()) == @_getMoveIndex()
      @_stopPreviusAnimation()

      # Positions
      $current_element = @_renderer.getElementByIndex(display_index)
      right_items_count = @_renderer.getRightElementsCount($current_element )

      # Render
      @_animationRender()

      # Change current index
      if @_animation_side == @ANIMATION_SIDE_NEXT
        @_moveIndex++
        moveToPosition = @_positionForMoveIndex()
      else
        @_moveIndex = @_renderer.getRenderedCount() - right_items_count
        moveToPosition = @__calculatePositionForMoveIndex( @_storage.NEAREST_ITEMS )

      # Change position
      @_setHolderPosition( @_positionForCurrentIndex() + @_getPositionDiff() )
      @_animate(null, moveToPosition)


    # Index and position calculation

    _currentHolderPosition: ->
      parseInt(@_$holder.css('left'), 10)

    _setHolderPosition: (position)->
      @_$holder.css 'left', position

    _getPositionDiff: ->
      position_diff = @_currentHolderPosition() % @_itemWidth
      position_diff += @_itemWidth if @_animation_side == @ANIMATION_SIDE_NEXT
      position_diff

    _applyCurrentIndexPosition: ->
      @_setHolderPosition( @_positionForCurrentIndex() )

    _positionForCurrentIndex: ->
      @__calculatePositionForMoveIndex(@_getMoveIndex())

    _getDisplayIndex: ->
      Math.abs( Math.round( @_currentHolderPosition() / @_itemWidth ) )

    _syncMoveIndex: ->
      @_moveIndex = @_storage.getCurrentIndexInRange()

    _getMoveIndex: ->
      @_moveIndex

    _positionForMoveIndex: ->
      @__calculatePositionForMoveIndex(@_storage.getCurrentIndexInRange())

    __calculatePositionForMoveIndex: (index)->
      @_itemWidth * index * -1


    # Render

    _loadElementInfo: ->
      element = @_renderer.firstElement()
      @_itemWidth = element[0].offsetWidth if element #todo it's unposiable for different block size


    _animationRender: ->
      @_renderer.render( @_storage.getNearestRange() )
      @_$scope.$apply()

    _rerender: ->
      @_renderer.render( @_storage.getNearestRange() )
      @_applyCurrentIndexPosition()
      @_$scope.$apply() unless @_$scope.$$phase
