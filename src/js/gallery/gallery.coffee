angular.module('cycleGallery').directive 'cycleGallery', [
  'GalleryRenderer',
  'ItemsStorage',
  'MoverHolder',
  'GalleryMover',
  'MoverTouch',
  'GalleryEvents',
  'Resize',
  'ResizeEmulator',
  (
    GalleryRenderer,
    ItemsStorage,
    MoverHolder,
    GalleryMover,
    MoverTouch,
    GalleryEvents,
    Resize,
    ResizeEmulator
  ) ->

    restrict: 'A',
    scope:
      galleryInit: '&galleryInit'
      galleryIndex: '=galleryIndex'
      configBuffer: '=configBuffer'


    compile: ($scope, $element) ->
      pre: ($scope, $element) ->

        # Parameters
        $body = angular.element(document).find('body')


        # Config
        config =
          render:
            bufferCount: $scope.configBuffer || 2
          mover:
            animationTime: 300


        # Initialize
        storage = new ItemsStorage(config.render)
        renderer = new GalleryRenderer($scope)
        holder = new MoverHolder()
        mover = new GalleryMover(config.mover, storage, renderer, holder)
        touch = new MoverTouch(mover, holder)
        resize = new Resize(mover, holder)
        events = new GalleryEvents()


        # Options
        storage.setIndex($scope.galleryIndex || 0)


        # Element binding
        $element[0].cycleGallery = {
          renderer: renderer
          storage: storage
          holder: holder
          mover: mover
          touch: touch
          resize: resize
          events: events
        }


        # Global events
        window.resizeEmulator = new ResizeEmulator() unless window.resizeEmulator
        window.resizeEmulator.bind(resize.do, $element)


        # Events
        events.on 'move:next', -> mover.next()
        events.on 'move:prev', -> mover.prev()
        events.on 'animate:next', -> mover.animateNext()
        events.on 'animate:prev', -> mover.animatePrev()

        # Touch events
        $body.on 'touchend', (e)-> touch.touchEnd()
        $body.on 'touchmove', (e)-> touch.touchMove(e.touches[0].pageX)


        # Move events
        storage.on 'change:index', ->
          $scope.galleryIndex = storage.getIndex() unless $scope.galleryIndex == undefined


        # Methods
        initializer = $scope.galleryInit()
        initializer({
          setIndex: (index)-> mover.setIndex( index - 0 ),
          getIndex: -> storage.getIndex()
          updateSizes: -> mover.updateSizes(),
        }) if initializer


        # Watch index
        $scope.$watch 'galleryIndex', (index) ->
          return if index == storage.getIndex() or index == undefined
          mover.setIndex(index)


        # On destroy
        $element.on '$destroy', ->
          events.clear()
          window.resizeEmulator.unbind($element)
          delete $element[0].cycleGallery

]