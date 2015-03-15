angular.module('multiGallery').service 'RenderedItems', [
  'RenderedItem',
  (RenderedItem)->

    class RenderedItems

      _items: [],

      addItem: (index, data)->
        for item in @_items
          if item.isDataMatch(data)
            item.updateRenderIndex(index)
            return true

        @_items.push( new RenderedItem(index, data) )

      getCount: ->
        @_items.length

      getItemsForRender: ->
        items = []
        for item in @_items
          items.push(item) if item.isWaitingForRender()
        items

      markAllOutdated: ->
        for item in @_items
          item.markOutdated()

      removeOutdated: ->
        index_for_removeing = []

        for item, i in @_items
          if item.isOutdate()
            index_for_removeing.unshift i # for reverse deleting
            item.destroy() # TODO move to rendererer

        for i in index_for_removeing
          @_items.splice(i, 1)


      firstElement: ->
        @getElementByIndex(0)

      getElementByIndex: (index)->
        for item in @_items
          return item.getElement() if item.getIndex() == index

]