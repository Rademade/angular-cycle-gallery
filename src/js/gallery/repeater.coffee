angular.module('multiGallery').directive 'galleryRepeater', [
  'GalleryRenderer', 'ItemsStorage', 'MoverHolder', 'GalleryMover', 'MoverTouch', 'GalleryEvents', 'Resize', '$window', '$rootScope'
  (GalleryRenderer, ItemsStorage, MoverHolder, GalleryMover, MoverTouch, GalleryEvents, Resize, $window, $rootScope)->

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
      touch = new MoverTouch(mover, holder)
      resize = new Resize(mover, holder)

      # Events

      GalleryEvents.on 'move:next', -> mover.next()
      GalleryEvents.on 'move:prev', -> mover.prev()
      GalleryEvents.on 'animate:next', -> mover.animateNext()
      GalleryEvents.on 'animate:prev', -> mover.animatePrev()
      GalleryEvents.on 'index:update', -> updateIndex()

      $scope.$watchCollection _collectionName, (items)-> mover.render(items)

      # Document events
      angular.element($window).bind 'resize', -> resize.do()


      # Touch events

      _$holder.on 'touchstart', (e)-> touch.touchStart(e.touches[0].pageX)
      _$body.on 'touchend', (e)-> touch.touchEnd()
      _$body.on 'touchmove', (e)-> touch.touchMove(e.touches[0].pageX)


      # Methods

      $rootScope.setGalleryIndex = (index)-> mover.setIndex( index - 0 )
      $rootScope.updateSizes = -> mover.updateSizes()


      # Private methods

      updateIndex = -> $scope[_galleryIndexName] = storage.getIndex()
      updateIndex()

]