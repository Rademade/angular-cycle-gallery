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
            item.destroy() # todo move to rendererer

        console.log('Remove', index_for_removeing)

        for i in index_for_removeing
          @_items.splice(i, 1)


      firstElement: ->
        @getElementByIndex(0)

      getElementByIndex: (index)->
        for item in @_items
          return item.getElement() if item.getIndex() == index

#      _compare: (a, b)->
#        return -1 if (a.getIndex() < b.getIndex())
#        return 1 if (a.getIndex() > b.getIndex())
#        return 0

]