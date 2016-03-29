angular.module('cycleGallery').service 'MoverHolder', ->

  class MoverHolder

    constructor: ->
      @_$hostElement = null
      @_itemWidth = 0
      @_position_lock = null

    setElement: ($element) ->
      @_$hostElement = $element

    update: ->
      @getItemWidth(false)

    getElement: ->
      @_$hostElement

    getDisplayIndex: ->
      Math.abs( Math.round( @getCurrentPosition() / @getItemWidth() ) )

    getItemWidth: (cached = true) ->
      return @_itemWidth if @_itemWidth and cached
      $element = @_$hostElement.children().eq(0)
      @_itemWidth = $element[0].offsetWidth if $element[0]

    getCurrentPosition: ->
      parseInt @_$hostElement.css('left'), 10

    setPosition: (position) ->
      @_$hostElement.css 'left', position + 'px'

    getSlideDiff: ->
      @getCurrentPosition() % @getItemWidth()

    __calculatePositionForIndex: (index) ->
      @getItemWidth() * index * -1

    createPositionLock: ->
      @_position_lock = @getCurrentPosition() unless @_position_lock

    getPositionLockDiff: ->
      @getCurrentPosition() - @_position_lock

    clearPositionLock: ->
      @_position_lock = null
