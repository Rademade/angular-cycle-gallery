angular.module('multiGallery').service 'GalleryRenderer', [
  'RenderedItems'
  (RenderedItems) ->

    class GalleryRenderer

      # GalleryMover
      _renderedItems: new RenderedItems()

      _transcludeFunction: null

      _$scope: null
      _scopeItemName: null
      _$holder: null

      #
      # Public methods
      #

      constructor: ($scope, scopeItemName, $holder, transcludeFunction)->
        @_$scope = $scope
        @_scopeItemName = scopeItemName
        @_$holder = $holder
        @_transcludeFunction = transcludeFunction

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
        @_$holder.children().eq(index)[0]

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
          @_$holder.prepend($element)
        else
          @_renderedItems.getElementByIndex( item.getIndex() - 1 ).after($element)

      _newItemScope: (item)->
        $itemScope = @_$scope.$new()
        $itemScope[@_scopeItemName] = item
        return $itemScope

]