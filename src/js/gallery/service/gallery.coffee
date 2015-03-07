angular.module('multiGallery').service 'GalleryService', [
  'GalleryEvents',
  (GalleryEvents)->

    NEAREST_ITEMS: 2

    items: []
    index: 0
    counter: 0
    count: 0

    # Additional array for cycling items
    cycleMultiplier: 0
    cycleIndex: 0
    cycleItems: []

    setItems: (items) ->
      @count = items.length
      @counter = @count - 1
      # todo. Maybe some of them already exist in current class
      @items = items
      @_createCycleItems()
      @_fixIndex()
      GalleryEvents.do('update')

    getNearestRange: () ->
      return [] if @count == 0
      [].concat(@getPrevRangeItems(), [@getCurrentItem()], @getNextRangeItems())

    getCurrentItem: ->
      @items[ @index ]

    getCycleIndex: ->
      @cycleIndex

    getPrevRangeItems: ->
      from_index = @counter - @NEAREST_ITEMS + @index + 1
      @cycleItems.slice(from_index, from_index + @NEAREST_ITEMS)

    getNextRangeItems: ->
      from_index = @NEAREST_ITEMS + @index - 1
      @cycleItems.slice(from_index, from_index + @NEAREST_ITEMS)

    nextItem: ->
      if @index == @counter then @index = 0 else @index++
      ++@cycleIndex
      GalleryEvents.do('update')

    prevItem: ->
      if @index == 0 then @index = @counter else @index--
      --@cycleIndex
      GalleryEvents.do('update')

    _fixIndex: ->
      @index = 0 if @index > @counter
      @cycleIndex = @index

    _createCycleItems: ->
      @cycleItems = []
      @cycleMultiplier = Math.ceil(@NEAREST_ITEMS/@count)

      for i in [0..@cycleMultiplier]
        @cycleItems = @cycleItems.concat(@items)

]