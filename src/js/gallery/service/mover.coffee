angular.module('multiGallery').service 'GalleryMover', [
  'MoverHolder',
  (MoverHolder)->

    class GalleryMover

      ANIMATION_TIME: 300
      ANIMATION_SIDE_NEXT: 1
      ANIMATION_SIDE_PREV: 2

      _storage: null
      _renderer: null
      _holder: null
      _$scope: null

      _animation: null

      _itemWidth: 0
      _moveIndex: 0

      # Public methods

      constructor: (storage, renderer, $holder, $scope)->
        @_storage = storage
        @_renderer = renderer
        @_holder = new MoverHolder($holder)
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
        @_animation_side = @ANIMATION_SIDE_NEXT
        @_storage.incNextBuffer()
        @_animate()

      animatePrev: ->
        return @_stopAnimationSide() if @_animation_side == @ANIMATION_SIDE_NEXT
        @_animation_side = @ANIMATION_SIDE_PREV
        @_storage.incPrevBuffer()
        @_animate()

      touchMove: (move)->
        console.log(move)
        @_holder.setPosition( @_getPositionForMoveIndex() - move )

      touchEnd: ->
#        move_index = @_holder.getDisplayIndex()
#        index_diff = move_index - @_storage.getCurrentIndexInRange()
#        @_storage.setIndex( @_storage.getIndex() + index_diff )
#        @_animate()


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
        @_animation_side = null
        @_storage.clearRangeBuffer()
        @_syncMoveIndex()
        @_rerender()

      _checkFrameChange: (changeCallback)->
        return false if (display_index = @_holder.getDisplayIndex()) == @_getMoveIndex()
        @_stopPreviusAnimation()

        # Positions
        $current_element = @_renderer.getElementByIndex(display_index)
        right_items_count = @_renderer.getRightElementsCount($current_element )

        # Render
        @_animationRender()

        # Change current index
        if @_animation_side == @ANIMATION_SIDE_NEXT
          @_moveIndex++
          moveToPosition = @_getPositionForCurrentIndex()
        else
          @_moveIndex = @_renderer.getRenderedCount() - right_items_count
          moveToPosition = @_holder.__calculatePositionForIndex( @_storage.NEAREST_ITEMS )

          @_holder.setPosition( @_getPositionForMoveIndex() + @_holder.getSlideDiff() )

        # Change position
        @_animate(null, moveToPosition)


      # Index and position calculation

      _applyMoveIndexPosition: -> @_holder.setPosition( @_getPositionForMoveIndex() )
      _applyCurrentIndexPosition: -> @_holder.setPosition( @_getPositionForCurrentIndex() )

      _getPositionForMoveIndex: -> @_holder.__calculatePositionForIndex(@_getMoveIndex())
      _getPositionForCurrentIndex: -> @_holder.__calculatePositionForIndex(@_storage.getCurrentIndexInRange())

      _syncMoveIndex: ->  @_moveIndex = @_storage.getCurrentIndexInRange()
      _getMoveIndex: -> @_moveIndex


      # Render function

      _animationRender: ->
        @_renderer.render( @_storage.getNearestRange() )
        @_$scope.$apply()

      _rerender: ->
        @_renderer.render( @_storage.getNearestRange() )
        @_applyMoveIndexPosition()
        @_$scope.$apply() unless @_$scope.$$phase

]