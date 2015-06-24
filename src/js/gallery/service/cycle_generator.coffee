angular.module('cycleGallery').service 'CycleGenerator', ->

  AUTO_INCREMENT = 0

  class CycleGenerator

    constructor: ->
      @_count = 0
      @_items = []
      @_index = null
      @_clearCycleParams()

    setItems: (items) ->
      @_items = items
      @_count = items.length
      @_clearCycleParams()

    setIndex: (index) ->
      @_index = index

    # Get element before current index
    #
    getPrev: (count) ->
      to = @_cycleIndex + @_index
      from = to - count

      # Recalculate if need to rebuild indexes and cycleItems
      if from < 0
        @_cycleGenerate( Math.ceil(from/@_count)*-1, yes ) # Need to add more {prev_elements_cycle}
        return @getPrev(count)

      # Add additional items to cycleItems
      @_cycleGenerate( Math.ceil(count/@_count), yes ) if @_cycleItems.length < to

      # Slice elements
      @_cycleItems.slice(from, to)


    # Get next element including index (current)
    #
    getNext: (count) ->
      from = @_cycleIndex + @_index
      to = from + count
      @_cycleGenerate( Math.ceil(to/@_count), no ) if to > @_cycleItems.length - 1 # Add more element to array.
      @_cycleItems.slice(from, to)

    _cycleGenerate: (cycleMultiplier, toStart = no) ->
      for i in [0..cycleMultiplier]
        items = JSON.parse( JSON.stringify( @_items ) ) # TODO make safe cloning
        if (toStart)
          @_cycleIndex += @_items.length
          @_cycleItems = @_addUIID(items).concat( @_cycleItems )
        else
          @_cycleItems = @_cycleItems.concat( @_addUIID(items) )

    _addUIID: (items) ->
      for item in items
        item._$UUID = ++AUTO_INCREMENT
      items

    _clearCycleParams: ->
      # Description [{prev_elements_cycle} | #cycle_index | {next_element_cycle}]
      @_cycleItems = []
      @_cycleIndex = 0