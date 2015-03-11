angular.module('multiGallery').service 'ItemsStorage', [
  'CycleGenerator', 'GalleryEvents'
  (CycleGenerator, GalleryEvents)->

    class ItemsStorage

      NEAREST_ITEMS: 2

      items: []
      index: 0
      count: 0

      nextBuffer: 0
      prevBuffer: 0

      # Additional array for cycling items
      cycleMultiplier: 0
      nextCycleItems: new CycleGenerator()
      prevCycleItems: new CycleGenerator()

      setItems: (items) ->
        @count = items.length
        @items = items
        @nextCycleItems.setItems(@items)
        @prevCycleItems.setItems(@items)
        @setIndex(0)

      getNearestRange: () ->
        return [] if @count == 0
        [].concat(@getPrevRangeItems(), @getNextRangeItems())

      getIndex: ->
        @index

      getPrevRangeItems: ->
        items_count = @NEAREST_ITEMS + @prevBuffer
        cycle_multiplier = (((items_count + @index) / @count) | 0) + 1
        from_index = @count * cycle_multiplier - items_count + @index
        to_index = from_index + items_count
        @prevCycleItems.sliceItems(from_index, to_index)

      getNextRangeItems: ->
        items_count = @NEAREST_ITEMS + @nextBuffer
        from_index = @index
        to_index = from_index + items_count + 1
        @nextCycleItems.sliceItems(from_index, to_index)

      nextIndex: ->
        @setIndex(@index+1)

      prevIndex: ->
        @setIndex(@index-1)

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
        @setIndex(@index + @nextBuffer)
        @nextBuffer = 0

      _clearPrevBuffer: ->
        @setIndex(@index - @prevBuffer)
        @prevBuffer = 0

      setIndex: (index)->
        fixed_index = @_fixIndex(index)
        unless @index == fixed_index
          @index = fixed_index
          GalleryEvents.do('index:update')

      _fixIndex: (index)->
        index = index%@count if index >= @count and @count > 0
        index = @count + index if index < 0
        index = @_fixIndex(index) unless 0 <= index < @count or @count == 0
        index

]