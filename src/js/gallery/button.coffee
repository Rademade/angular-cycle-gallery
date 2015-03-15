angular.module('multiGallery').directive 'galleryButton', [
  'GalleryActions',
  (GalleryActions) ->

    restrict: 'A',
    scope:
    	galleryButton: '@'

    link: (scope, $element) ->
      action = scope.galleryButton
      $element.on 'click', (e) -> GalleryActions[action]()

]