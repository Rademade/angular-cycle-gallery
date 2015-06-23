angular.module('cycleGallery').service 'GalleryRenderer', [
  'RenderedItems'
  (RenderedItems) ->

    class GalleryRenderer

      constructor: ($scope) ->
        @_$scope = $scope
        @_renderedItems = new RenderedItems()

      setOptions: (scopeItemName, transcludeFunction)->
        @_scopeItemName = scopeItemName
        @_transcludeFunction = transcludeFunction

      setHostElement: ($element) ->
        @_$hostElement = $element

      render: (items)->
        @_renderedItems.markAllOutdated()
        @_updateRenderedPosition(items)
        @_renderedItems.removeOutdated()
        @_updateHolder()

      getRenderedCount: ->
        @_renderedItems.getCount()

      firstElement: ->
        @_renderedItems.firstElement()

      getElementByIndex: (index)->
        @_$hostElement.children().eq(index)[0]

      getRightElementsCount: ($element)->
        @getRenderedCount() - @getElementIndex($element)

      getElementIndex: (element)->
        i = 0
        while ((element = element.previousSibling) != null)
          ++i
        return i

      #
      # Private methods
      #

      _updateRenderedPosition: (items) ->
        for item, i in items
          @_renderedItems.addItem(i, item)

      _updateHolder: (items)->
        for item in @_renderedItems.getItemsForRender()
          $itemScope = @_newItemScope(item.getData())
          @_transcludeFunction $itemScope, ($element) =>
            item.setRenderData($itemScope, $element)
            @_appendItem(item, $element)

      _appendItem: (item, $element)->
        if item.getIndex() == 0
          @_$hostElement.prepend($element)
        else
          @_renderedItems.getElementByIndex( item.getIndex() - 1 ).after($element)

      _newItemScope: (item)->
        $itemScope = @_$scope.$new()
        $itemScope[@_scopeItemName] = item
        return $itemScope

]