angular.module('multiGallery').service 'CycleGenerator', [
  'uuid4'
  (uuid4)->

    class CycleGenerator

      _count: 0
      _items: []

      _cycleItems: []

      setItems: (items)->
        @_items = items
        @_count = items.length
        @_cycleItems = []
        @_cycleGenerate(1)

      sliceItems: (from, to) ->
        @_cycleGenerate( Math.ceil(to/@_count) ) if to > @_cycleItems.length - 1
        @_cycleItems.slice(from, to)

      _cycleGenerate: (cycleMultiplier)->
        for i in [0..cycleMultiplier]
          # todo make safe cloning
          items = JSON.parse( JSON.stringify( @_items ) )
          @_cycleItems = @_cycleItems.concat( @_addUIID(items) )

      _addUIID: (items)->
        for item in items
          item._$UUID = uuid4.generate()
        items

]