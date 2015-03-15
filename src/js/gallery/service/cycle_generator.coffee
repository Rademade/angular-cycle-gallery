angular.module('multiGallery').service 'CycleGenerator', ->

  AUTO_INCREMENT = 0

  class CycleGenerator

    _count: 0
    _items: []
    _index: null

    # Description [{prev_elements_cycle} | #cycle_index | {next_element_cycle}]
    _cycleIndex: 0 
    _cycleItems: []

    setItems: (items)->
      @_items = items
      @_count = items.length
      @_cycleItems = []

    setIndex: (index)->
      @_index = index

    getPrev: (count)->
      to = @_cycleIndex + @_index
      from = to - count
      return @_cycleItems.slice(from, to) if from >= 0 
      @_cycleGenerate( Math.ceil(from/@_count)*-1, yes ) # Need to add more {prev_elements_cycle}
      return @getPrev(count)

    getNext: (count)->
      from = @_cycleIndex + @_index
      to = from + count
      @_cycleGenerate( Math.ceil(to/@_count), no ) if to > @_cycleItems.length - 1 # Add more element to array.
      @_cycleItems.slice(from, to)

    _cycleGenerate: (cycleMultiplier, toStart = false)->
      for i in [0..cycleMultiplier]
        items = JSON.parse( JSON.stringify( @_items ) ) # TODO make safe cloning
        if (toStart)
          @_cycleIndex += @_items.length
          @_cycleItems = @_addUIID(items).concat( @_cycleItems )
        else
          @_cycleItems = @_cycleItems.concat( @_addUIID(items) )
        

    _addUIID: (items)->
      for item in items
        item._$UUID = ++AUTO_INCREMENT
      items