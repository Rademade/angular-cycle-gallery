angular.module('multiGallery').service 'RenderedItems', ->

  class RenderedItems

    _items: [],

    add: ($scope, element, data) ->
      @_items.push(
        scope: $scope,
        element: element,
        data: data,
        _$outedate: false
      )

    markAllOutdated: ->
      for item in @_items
        item._$outedate = true

    isRendered: (data, removeOutdated = false)->
      for item in @_items
        if item.data == data
          item._$outedate = false if removeOutdated
          return true
      return false

    removeOutdated: ->
      index_for_removeing = []

      for item, i in @_items
        if item._$outedate
          index_for_removeing.push i
          item.element.remove()
          item.scope.$destroy()

      for i in index_for_removeing
        @_items.splice(i, 1)

    findElement: (data)->
      return null unless data
      for item in @_items
        return item.element if item.data == data
      return null