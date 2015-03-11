angular.module('multiGallery').service 'RenderedItems', ->

  class RenderedItems

    _items: [],

    add: ($scope, element, data) ->
      @_items.push(
        scope: $scope
        element: element
        data: data
        _$outedate: false
      )

    isRendered: (data, removeOutdated = false)->
      for item in @_items
        if item.data == data
          item._$outedate = false if removeOutdated
          return true
      return false

    markAllOutdated: ->
      for item in @_items
        item._$outedate = true

    removeOutdated: ->
      index_for_removeing = []

      for item, i in @_items
        if item._$outedate
          index_for_removeing.unshift i # for reverse deleting
          item.element.remove()
          item.scope.$destroy()

      for i in index_for_removeing
        @_items.splice(i, 1)

    findElementByData: (data)->
      return null unless data
      for item in @_items
        return item.element if item.data == data

    firstElement: ->
      item = @_items[0]
      item.element[0] if item