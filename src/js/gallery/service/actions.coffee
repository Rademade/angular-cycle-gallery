angular.module('multiGallery').service 'GalleryActions', [
  'GalleryEvents'
  (GalleryEvents)->

    next: -> GalleryEvents.do('move:next')
    prev: -> GalleryEvents.do('move:prev')

    animateNext: -> GalleryEvents.do('animate:next')
    animatePrev: -> GalleryEvents.do('animate:prev')

]