angular.module('multiGallery').directive 'galleryRepeater', [
  'GalleryRenderer', 'ItemsStorage', 'MoverHolder', 'GalleryMover', 'GalleryEvents', '$rootScope'
  (GalleryRenderer, ItemsStorage, MoverHolder, GalleryMover, GalleryEvents, $rootScope)->

    terminal: true
    transclude : 'element'
    terminal : true
    $$tlb : true
    priority: 1000

    link: ($scope, $element, $attr, nullController, renderFunction) ->

      # Attributes

      _repeatAttributes = $attr.galleryRepeater
      _matchResult = _repeatAttributes.match(/^\s*(.+)\s+in\s+(.*?)\s*(\s+track\s+by\s+(.+)\s*)?$/)
      _scopeItemName = _matchResult[1]
      _collectionName = _matchResult[2]
      _galleryIndexName = '$galleryIndex'
      _$holder = $element.parent()
      _$body = angular.element(document).find('body')

      # Classes

      storage = new ItemsStorage()
      gallery = new GalleryRenderer($scope, _scopeItemName, _$holder, renderFunction)
      holder = new MoverHolder(_$holder)
      mover = new GalleryMover(storage, gallery, holder, $scope)

      # todo update with in resize

      # Events

      GalleryEvents.on 'move:next', -> mover.next()
      GalleryEvents.on 'move:prev', -> mover.prev()
      GalleryEvents.on 'animate:next', -> mover.animateNext()
      GalleryEvents.on 'animate:prev', -> mover.animatePrev()
      GalleryEvents.on 'index:update', -> $scope[_galleryIndexName] = storage.getIndex()

      $scope.$watchCollection _collectionName, (items)-> mover.render(items)


      trigger = false
      start_position = 0
      slide_diff = 0

      _$holder.on 'mousedown', (e)->
        trigger = true
        start_position = e.x

      _$body.on 'mouseup', ->
        trigger = false
#        mover.touchEnd()

      _$body.on 'mousemove', (e)->
        return true unless trigger
        console.log('SLIDE', slide_diff, move)
        move = e.x - start_position
        mover.touchMove(move)

      # Methods

      $rootScope.setGalleryIndex = (index)-> mover.setIndex( index - 0 )

]