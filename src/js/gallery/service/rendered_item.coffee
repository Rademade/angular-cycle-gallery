angular.module('multiGallery').service 'RenderedItem', ->

  class RenderedItem

    _index: null
    _data: null
    _element: null
    _scope: null

    _outdate: null
    _rendered: no

    constructor: (index, data)->
      @_index = index
      @_data = data
      @_outdate = no

    getIndex: ->
      @_index

    isDataMatch: (data)->
      @_data._$UUID == data._$UUID

    getData: ->
      @_data

    getElement: -> @_element

    updateRenderIndex: (index)->
      @_index = index
      @_outdate = no
      @_rendered = yes

    setRenderData: (scope, element) ->
      @_scope = scope
      @_element = element
      @_outdate = no
      @_rendered = yes

    destroy: ->
      @_element.remove()
      @_scope.$destroy()

    isOutdate: ->
      @_outdate

    markOutdated: ->
      @_outdate = yes

    isWaitingForRender: ->
      @_outdate == no and @_rendered == no

