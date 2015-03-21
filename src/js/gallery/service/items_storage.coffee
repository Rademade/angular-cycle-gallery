angular.module('multiGallery').service 'ItemsStorage', [
  'CycleGenerator', 'GalleryEvents', 'GalleryConfig'
  (CycleGenerator, GalleryEvents, GalleryConfig)->

    class ItemsStorage

      _NEAREST_ITEMS: null

      items: []
      index: 0
      count: 0

      _counterIndex: 0

      nextBuffer: 0
      prevBuffer: 0

      cycleMultiplier: 0
      cycler: new CycleGenerator()

      constructor: ()->
        @_NEAREST_ITEMS = GalleryConfig.getBuffer()

      setItems: (items) ->
        @count = items.length
        @items = items
        @cycler.setItems(@items)
        @setIndex(0)

      getNearestRange: () ->
        return [] if @count == 0
        @cycler.setIndex( @_counterIndex )
        [].concat(
          @cycler.getPrev(@_NEAREST_ITEMS + @prevBuffer)
          @cycler.getNext(@_NEAREST_ITEMS + @nextBuffer + 1) # +1 is current element
        )

      setIndex: (index)->
        @_setItemIndex(index)
        @_counterIndex = @getIndex()

      setIndexDiff: (index_diff)->
        @_counterIndex += index_diff
        @_setItemIndex( @getIndex() + index_diff )

      getIndex: ->
        @index

      nextIndex: ->
        @_setItemIndex(@index+1)
        @_counterIndex++

      prevIndex: ->
        @_setItemIndex(@index-1)
        @_counterIndex--

      getCurrentIndexInRange: ->
        @_NEAREST_ITEMS + @nextBuffer

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
        @_counterIndex -= @prevBuffer
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