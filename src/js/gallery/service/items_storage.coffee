angular.module('cycleGallery').service 'ItemsStorage', [
  'CycleGenerator'
  (CycleGenerator)->

    class ItemsStorage

      # @params [Object] config
      #   - {bufferCount}
      #
      constructor: (config) ->
        # Nearest
        @nearestItemsCount = config.bufferCount

        # Active params
        @items = []
        @index = 0
        @count = 0
        @nextBuffer = 0
        @prevBuffer = 0

        # Cycler
        @cycler = new CycleGenerator()

        # Private params
        @_counterIndex = 0
        @_events = {}


      #
      # Event methods
      #

      on: (event, callback) =>
        @_events[event] ||= []
        @_events[event].push(callback)

      trigger: (event) ->
        return unless @_events[event]
        for callback in @_events[event]
          callback.call()


      # Base logic

      setItems: (items) ->
        @count = items.length
        @items = items
        @cycler.setItems(@items)
        @setIndex(0)

      getNearestRange: ->
        return [] if @count == 0
        @cycler.setIndex( @_counterIndex )
        [].concat(
          @cycler.getPrev(@nearestItemsCount + @prevBuffer)
          @cycler.getNext(@nearestItemsCount + @nextBuffer + 1) # +1 is current element
        )

      setIndex: (index) ->
        @_setItemIndex(index)
        @_counterIndex = @getIndex()

      setIndexDiff: (index_diff) ->
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
        @nearestItemsCount + @nextBuffer

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

      _setItemIndex: (index) ->
        index = @_fixItemIndex(index)
        unless @index == index
          @index = index
          @trigger('change:index')

      _fixItemIndex: (index) ->
        index = index%@count if index >= @count and @count > 0
        index = @count + index if index < 0
        index = @_fixItemIndex(index) unless 0 <= index < @count or @count == 0
        index

]