angular.module('multiGallery').service 'GalleryDirective', [
  'GalleryService', 'RenderedItems', '$animate',
  (GalleryService, RenderedItems, $animate) ->

    class GalleryDirective

      _renderedItems: new RenderedItems()

      _transcludeFunction: null

      _$scope: null
      _scopeItemName: null
      _$holder: null
      _itemWidth: null

      #
      # Public methods
      #

      constructor: ($scope, scopeItemName, $holder, transcludeFunction)->
        @_$scope = $scope
        @_scopeItemName = scopeItemName
        @_$holder = $holder
        @_transcludeFunction = transcludeFunction

      setItems: (items)->
        GalleryService.setItems(items)

      update: ->
        @_renderElements()
        @_updatePosition()

      #
      # Private methods
      #

      _updatePosition: ->
        #todo add animations
        @_$holder.css('left', @_itemWidth * GalleryService.NEAREST_ITEMS * -1)

      _renderElements: ->
        @_renderedItems.markAllOutdated()
        prev_item = null
        for item in GalleryService.getNearestRange()
          @_addItemToHolder(prev_item, item) unless @_renderedItems.isRendered(item, true)
          prev_item = item
        @_renderedItems.removeOutdated()

      _addItemToHolder: (prev_item, item)->
        $itemScope = @_newItemScope(item)
        @_transcludeFunction $itemScope, (element) =>
          @_appendElement(@_renderedItems.findElement(prev_item), element, item)
          @_renderedItems.add($itemScope, element, item)
          @_collectElementStyleProperties element

      _appendElement: ($prev_element = null, $element, item)->
        if $prev_element == null
          @_$holder.prepend($element)
        else
          $prev_element.after($element)

      _newItemScope: (item)->
        $itemScope = @_$scope.$new()
        $itemScope[@_scopeItemName] = item
        return $itemScope

      _collectElementStyleProperties: (element)->
        @_itemWidth ||= element[0].offsetHeight

]