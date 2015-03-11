angular.module('multiGallery').service 'ItemsStorage', ->

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
    cycleItems: []

    setItems: (items) ->
      @count = items.length
      @counter = @count - 1
      # todo. Maybe some of them already exist in current class
      @items = items
      @_createCycleItems()
      @_fixIndex()

    getNearestRange: () ->
      return [] if @count == 0
      [].concat(@getPrevRangeItems(), [@getCurrentItem()], @getNextRangeItems())

    getCurrentItem: ->
      @items[ @index ]

    getPrevRangeItems: ->
      # Todo for big cycels need to update count_multiplier
      from_index = @count - @NEAREST_ITEMS - @prevBuffer + @index
      @cycleItems.slice(from_index, from_index + @NEAREST_ITEMS + @prevBuffer)

    getNextRangeItems: ->
      from_index = @index
      @cycleItems.slice(from_index, from_index + @NEAREST_ITEMS + @nextBuffer + 1)

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
      @index = @index - @counter if @index > @counter
      @index = @count + @index if @index < 0
      @_fixIndex() unless 0 <= @index <= @counter

    _createCycleItems: ->
      @cycleItems = []
      @cycleMultiplier = Math.ceil(@NEAREST_ITEMS/@count)

      for i in [0..@cycleMultiplier]
        @cycleItems = @cycleItems.concat(@items)