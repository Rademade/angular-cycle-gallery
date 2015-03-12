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
      @_itemWidth ||= @_$holder.children().eq(0)[0].offsetWidth
      # load from holde

    getCurrentPosition: ->
      parseInt @_$holder.css('left'), 10

    setPosition: (position)->
      @_$holder.css 'left', position

    getSlideDiff: ->
      @getCurrentPosition() % @getItemWidth()

    __calculatePositionForIndex: (index)->
      @getItemWidth() * index * -1

