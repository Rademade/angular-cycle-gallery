angular.module('multiGallery').directive 'galleryConfigBuffer', [
  'GalleryConfig',
  (GalleryConfig) ->
 
    restrict: 'A',

    compile: (scope, $element) ->
      pre: (scope, $element, attr) -> 
      	GalleryConfig.setBuffer(attr.galleryConfigBuffer)
      
]