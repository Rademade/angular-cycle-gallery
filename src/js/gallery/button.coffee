angular.module('multiGallery').directive 'galleryButton', [
  'GalleryActions',
  (GalleryActions) ->

    restrict: 'A',
    #todo get via class attributes galleryButton

    link: (scope, element, attrs, controller) ->
      action_name = attrs.galleryButton
      element.on('click', -> GalleryActions[action_name]())

]