angular.module('multiGallery').service 'ItemsStorage', [
  'CycleGenerator', 'GalleryEvents'
  (CycleGenerator, GalleryEvents)->

    class ItemsStorage

      NEAREST_ITEMS: 2

      items: []
      index: 0
      count: 0

      _counterIndex: 0

      nextBuffer: 0
      prevBuffer: 0

      cycleMultiplier: 0
      cycler: new CycleGenerator()

      setItems: (items) ->
        @count = items.length
        @items = items
        @cycler.setItems(@items)
        @setIndex(0)

      getNearestRange: () ->
        return [] if @count == 0
        @cycler.setIndex( @_counterIndex )
        [].concat(
          @cycler.getPrev(@NEAREST_ITEMS + @prevBuffer)
          @cycler.getNext(@NEAREST_ITEMS + @nextBuffer + 1) # +1 is current element
        )

      setIndex: (index)->
        @_setItemIndex(index)
        @_counterIndex = @getIndex()

      getIndex: ->
        @index

      nextIndex: ->
        @_setItemIndex(@index+1)
        @_counterIndex++

      prevIndex: ->
        @_setItemIndex(@index-1)
        @_counterIndex--

      getCurrentIndexInRange: ->
        @NEAREST_ITEMS - @prevBuffer + @nextBuffer

      clearRangeBuffer: ->
        @_clearNextBuffer()
        @_clearPrevBuffer()

      incNextBuffer: -> ++@nextBuffer
      getNextBuffer: -> @nextBuffer

      incPrevBuffer: -> ++@prevBuffer
      getPrevBuffer: -> @prevBuffer

      _clearNextBuffer: ->
        @_setItemIndex(@index + @nextBuffer)
        @_counterIndex += @nextBuffer
        @nextBuffer = 0

      _clearPrevBuffer: ->
        @_setItemIndex(@index - @prevBuffer)
        @_counterIndex -= @nextBuffer
        @prevBuffer = 0

      _setItemIndex: (index)->
        index = @_fixItemIndex(index)
        unless @index == index
          @index = index
          GalleryEvents.do('index:update')

      _fixItemIndex: (index)->
        index = index%@count if index >= @count and @count > 0
        index = @count + index if index < 0
        index = @_fixItemIndex(index) unless 0 <= index < @count or @count == 0
        index

]