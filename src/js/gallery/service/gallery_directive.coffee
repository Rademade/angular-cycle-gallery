angular.module('multiGallery').service 'GalleryDirective', [
  'GalleryService', '$animate',
  (GalleryService, $animate) ->

    class GalleryDirective

      _renderedItems: []

      _transcludeFunction = null

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
        @_removeRenderFlags()
        for item in GalleryService.getNearestRange()
          continue if @_flagRenderedElements(item)
          @_appendItem(item)
        @_removeOutdatedElements()

      _appendItem: (item)->
        $itemScope = @_newItemScope(item)
        @_transcludeFunction $itemScope, (element) =>
          $animate.enter element, @_$holder
          @_storeRenderElementData $itemScope, element, item
          @_collectElementStyleProperties element

      _newItemScope: (item)->
        $itemScope = @_$scope.$new()
        $itemScope[@_scopeItemName] = item
        return $itemScope

      _storeRenderElementData: ($scope, element, item) ->
        data = scope: $scope, element: element, itemData: item, renderUpdate: true
        @_renderedItems.push( data )

      _removeRenderFlags: =>
        for renderedItem in @_renderedItems
          renderedItem.renderUpdate = false

      _flagRenderedElements: (item)->
        for renderedItem in @_renderedItems
          if renderedItem.itemData == item
            renderedItem.renderUpdate = true
            return true
        return false

      _removeOutdatedElements: ->
        index_for_removeing = []
        for renderedItem, i in @_renderedItems
          unless renderedItem.renderUpdate
            index_for_removeing.push i
            renderedItem.element.remove()
            renderedItem.scope.$destroy()

        for index in index_for_removeing
          @_renderedItems.splice(index, index+1)

      _collectElementStyleProperties: (element)->
        @_itemWidth ||= element[0].offsetHeight

]