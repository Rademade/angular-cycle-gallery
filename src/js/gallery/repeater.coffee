angular.module('multiGallery').directive 'galleryRepeater', [
  'GalleryRenderer', 'ItemsStorage', 'GalleryMover', 'GalleryEvents',
  (GalleryRenderer, ItemsStorage, GalleryMover, GalleryEvents)->

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
      _$holder = $element.parent()

      # Classes

      storage = new ItemsStorage()
      gallery = new GalleryRenderer($scope, _scopeItemName, _$holder, renderFunction)
      mover = new GalleryMover(storage, gallery, _$holder, $scope)

      # todo update with in resize

      # Events

      GalleryEvents.on 'move:next', -> mover.next()
      GalleryEvents.on 'move:prev', -> mover.prev()
      GalleryEvents.on 'animate:next', -> mover.animateNext()
      GalleryEvents.on 'animate:prev', -> mover.animatePrev()

      $scope.$watchCollection _collectionName, (items)-> mover.render(items)

]