angular.module('multiGallery').service 'GalleryActions', [
  'GalleryService'
  (GalleryService)->

    next: -> GalleryService.nextItem()
    prev: -> GalleryService.prevItem()

]