angular.module('multiGallery').service 'MoverHolder', ->

  class MoverHolder

    _$holder: null
    _itemWidth: 0

    constructor: ($holder)->
      @_$holder = $holder

    getElement: ->
      @_$holder

    getDisplayIndex: ->
      Math.abs( Math.round( @getCurrentPosition() / @getItemWidth() ) )

    getItemWidth: ->
      return @_itemWidth if @_itemWidth
      $element = @_$holder.children().eq(0)
      @_itemWidth = $element[0].offsetWidth if $element[0]

    getCurrentPosition: ->
      parseInt @_$holder.css('left'), 10

    setPosition: (position)->
      @_$holder.css 'left', position

    getSlideDiff: ->
      @getCurrentPosition() % @getItemWidth()

    __calculatePositionForIndex: (index)->
      @getItemWidth() * index * -1

