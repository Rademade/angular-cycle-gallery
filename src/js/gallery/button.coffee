angular.module('cycleGallery').directive 'galleryButton', [
  'Finder',
  (Finder) ->

    restrict: 'A',
    scope:
    	galleryButton: '@'

    link: (scope, $element) ->
      action = scope.galleryButton
      events = Finder.loadGalleryObject($element).events

      $element.on 'click', ->
        switch action
          when 'next' then events.do('move:next')
          when 'prev' then events.do('move:prev')
          when 'animateNext' then events.do('animate:next')
          when 'animatePrev' then events.do('animate:prev')

]