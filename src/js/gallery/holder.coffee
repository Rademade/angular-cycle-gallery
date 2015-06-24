angular.module('cycleGallery').directive 'cycleGalleryHolder', [
  'Finder',
  (Finder) ->

    compile: ($scope, $element) ->
      pre: ($scope, $element) ->

        # Set options
        gallery = Finder.loadGalleryObject($element)
        gallery.renderer.setHostElement($element)
        gallery.holder.setElement($element)

        # Touch events
        $element.on 'touchstart', (e) ->
          gallery.touch.touchStart(e.touches[0].pageX)

]