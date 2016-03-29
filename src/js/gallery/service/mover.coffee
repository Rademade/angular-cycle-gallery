angular.module('cycleGallery').service 'GalleryMover', [
  'animationService',
  (animationService) ->

    # TODO Need to extract sub components. Like animation and animate block

    class GalleryMover

      ANIMATION_SIDE_NEXT: 1
      ANIMATION_SIDE_PREV: 2

      constructor: (config, storage, renderer, holder) ->
        # Options
        @animationTime = config.animationTime
        @_storage = storage
        @_renderer = renderer
        @_holder = holder

        # Private attributes
        @_animation = null

        # Private indexes for moving
        @_necessaryIndex = 0
        @_displayIndex = 0

      #
      # Public methods
      # @param config {animationTime}
      #
      setScope : ($scope) ->
        @_$scope = $scope

      render : (items = []) ->
        @_storage.setItems(items)
        @_renderer.render( @_storage.getNearestRange() )
        @_holder.update()
        @_syncIndexes()
        @_applyPositionForNecessaryIndex()

      setIndex : (index) ->
        return @_stopAnimationSide() if @_animation_side
        @_storage.setIndex(index)
        @_syncIndexes()
        @_stopPreviusAnimation()
        @_rerender()

      next : ->
        return @_stopAnimationSide() if @_animation_side
        @_storage.nextIndex()
        @_syncIndexes()
        @_rerender()

      prev : ->
        return @_stopAnimationSide() if @_animation_side
        @_storage.prevIndex()
        @_syncIndexes()
        @_rerender()

      animateNext : ->
        @_clearAnimationTime()
        @_storage.incNextBuffer()
        ++@_necessaryIndex
        @_animate()

      animatePrev : ->
        @_clearAnimationTime()
        @_storage.incPrevBuffer()
        --@_necessaryIndex
        @_animate()

      getAnimationSide : ->
        @_animation_side

      updateSizes : ->
        @_stopAnimationSide()
        @_holder.update()
        @_applyPositionForNecessaryIndex()

      forceMove : (position) ->
        @_holder.setPosition( @_getPositionForDisplayIndex() + position )
        @_detectPosition()

      applyIndexDiff : (index_diff) ->
        @_storage.setIndexDiff( index_diff )
        @_storage.clearRangeBuffer()
        @_syncIndexes()
        @_rerender()
        @_detectPositionClear()


      # Animation kill

      _stopPreviusAnimation : ->
        animationService.stop()
        @_animation = null

      _stopAnimationSide : ->
        @_stopPreviusAnimation()
        @_clearAnimationTime()
        @_animation_side = null
        @_storage.clearRangeBuffer()
        @_syncIndexes()
        @_rerender()

      # Animation time

      _getAnimationTime : ->
        timestamp = (new Date()).getTime()
        @_animationStartTime = timestamp unless @_animationStartTime
        @animationTime - (timestamp - @_animationStartTime)

      _clearAnimationTime : ->
        @_animationStartTime = null

      # Animation block

      _animate: (position = @_getPositionForNecessaryIndex()) ->
        element = @_holder.getElement()[0]
        params =
          element : element
          left : position + 'px'
          onUpdate : => @_checkFrameChange()
          onComplete : => @_onCompleteAnimation()
          from : parseInt(element.style.left)
          to : position
          time : @_getAnimationTime()
          position : position

        @_animation = animationService.linear(params)

      _onCompleteAnimation : ->
        @_clearAnimationTime()
        @_detectPositionClear()
        @_storage.clearRangeBuffer()
        @_syncIndexes()
        @_rerender()

      _detectPosition : ->
        @_holder.createPositionLock()
        position_diff = @_holder.getPositionLockDiff()
        return false unless Math.abs(position_diff) > 5
        if position_diff < 0
          @_animation_side = @ANIMATION_SIDE_NEXT
        else
          @_animation_side = @ANIMATION_SIDE_PREV
        return true

      _detectPositionClear : ->
        @_holder.clearPositionLock()
        @_animation_side = null

      _checkFrameChange : ->
        return false unless @_detectPosition()
        return false if (animation_display_index = @_holder.getDisplayIndex()) == @getDisplayIndex()

        @_stopPreviusAnimation()

        # Positions
        $current_element = @_renderer.getElementByIndex(animation_display_index)
        right_items_count = @_renderer.getRightElementsCount($current_element ) # For prev animation it not change

        # ReRender new elements
        @_animationRender()

        # Change current index
        if @_animation_side == @ANIMATION_SIDE_NEXT
          @_displayIndex++
        else
          @_displayIndex = @_renderer.getRenderedCount() - right_items_count
          @_holder.setPosition( @_getPositionForDisplayIndex() + @_holder.getSlideDiff() )
          @_necessaryIndex = @getTrueIndex() # After rerender, update index

        # Change position
        @_detectPositionClear()

        # Animate
        @_animate()


      # Index and position calculation

      _applyPositionForNecessaryIndex : -> @_holder.setPosition( @_getPositionForNecessaryIndex() )

      _getPositionForDisplayIndex : -> @_holder.__calculatePositionForIndex( @getDisplayIndex() )
      _getPositionForNecessaryIndex : -> @_holder.__calculatePositionForIndex( @getNecessaryIndex() )

      getTrueIndex : -> @_storage.getCurrentIndexInRange()
      getDisplayIndex : -> @_displayIndex
      getNecessaryIndex : -> @_necessaryIndex

      _syncIndexes : ->
        @_necessaryIndex = @getTrueIndex()
        @_displayIndex = @getTrueIndex()

      getUseableDiff : ->
        position_diff = @_holder.getSlideDiff()
        is_half = Math.abs(position_diff) > @_holder.getItemWidth() / 2
        position_diff += @_holder.getItemWidth() if is_half # Check for first part of slide
        position_diff

      # Render function

      _animationRender : ->
        @_renderer.render( @_storage.getNearestRange() )
        @_scopeApply()

      _rerender : ->
        @_renderer.render( @_storage.getNearestRange() )
        @_applyPositionForNecessaryIndex()
        @_scopeApply()

      _scopeApply: ->
        return unless @_$scope
        @_$scope.$apply() unless @_$scope.$$phase

]
