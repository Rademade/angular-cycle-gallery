angular.module('cycleGallery').service 'Finder', ->
    
  loadGalleryObject: ($element)->
    $parent = $element

    while (!($parent.attr('cycle-gallery')))
      $parent = $parent.parent()
      new Error('There are not parent element with attribute [cycle-gallery]') if $element == null

    $parent[0].cycleGallery
