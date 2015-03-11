angular.module('multiGallery').service 'ItemsStorage', [
  'CycleGenerator'
  (CycleGenerator)->

    class ItemsStorage

      NEAREST_ITEMS: 2

      items: []
      index: 0
      counter: 0
      count: 0

      nextBuffer: 0
      prevBuffer: 0

      # Additional array for cycling items
      cycleMultiplier: 0
      nextCycleItems: new CycleGenerator()
      prevCycleItems: new CycleGenerator()

      setItems: (items) ->
        @count = items.length
        @counter = @count - 1
        # todo. Maybe some of them already exist in current class
        @items = items
        @nextCycleItems.setItems(@items)
        @prevCycleItems.setItems(@items)
        @_fixIndex()

      getNearestRange: () ->
        return [] if @count == 0
        [].concat(@getPrevRangeItems(), @getNextRangeItems())

      getPrevRangeItems: ->
        items_count = @NEAREST_ITEMS + @prevBuffer
        cycle_multiplier = (((items_count + @index) / @count) | 0) + 1
        from_index = @count * cycle_multiplier - items_count + @index
        to_index = from_index + items_count
        console.log(from_index, to_index)
        @prevCycleItems.sliceItems(from_index, to_index)

      getNextRangeItems: ->
        items_count = @NEAREST_ITEMS + @nextBuffer
        from_index = @index
        to_index = from_index + items_count + 1
        @nextCycleItems.sliceItems(from_index, to_index)

      nextIndex: ->
        ++@index
        @_fixIndex()

      prevIndex: ->
        --@index
        @_fixIndex()

      getCurrentIndexInRange: ->
        @NEAREST_ITEMS - @prevBuffer + @nextBuffer

      clearRangeBuffer: ->
        @_clearNextBuffer()
        @_clearPrevBuffer()
        @_fixIndex()

      incNextBuffer: -> ++@nextBuffer
      getNextBuffer: -> @nextBuffer

      incPrevBuffer: -> ++@prevBuffer
      getPrevBuffer: -> @prevBuffer

      _clearNextBuffer: ->
        @index += @nextBuffer
        @nextBuffer = 0

      _clearPrevBuffer: ->
        @index -= @prevBuffer
        @prevBuffer = 0

      _fixIndex: ->
        fixed = false
        @index = @index - @count if @index > @counter
        @index = @count + @index if @index < 0
        @_fixIndex() unless 0 <= @index <= @counter

]