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
        # todo problem with rendering same element's in cycle. Hard to repeat them
        @_renderedItems.markAllOutdated()
        @_updateHolder(items)
        @_renderedItems.removeOutdated()

      firstElement: ->
        @_renderedItems.firstElement()

      getElementByIndex: (index)->
        @_$holder.children().eq(index)[0]

      getElementIndex: (element)->
        i = 0
        while ((element = element.previousSibling) != null)
          ++i
        return i

      #
      # Private methods
      #

      _updateHolder: (items)->
        prev_item = null
        for item in items
          @_addItemToHolder(prev_item, item) unless @_renderedItems.isRendered(item, true)
          prev_item = item

      _addItemToHolder: (prev_item, item)->
        $itemScope = @_newItemScope(item)
        @_transcludeFunction $itemScope, (element) =>
          prev_element = @_renderedItems.findElementByData(prev_item)
          console.log(prev_element)
          @_appendElement(prev_element, element, item)
          @_renderedItems.add($itemScope, element, item)

      _appendElement: ($prev_element = null, $element, item)->
        if $prev_element == null
          @_$holder.prepend($element) # to the start
        else
          $prev_element.after($element)

      _newItemScope: (item)->
        $itemScope = @_$scope.$new()
        $itemScope[@_scopeItemName] = item
        return $itemScope

]