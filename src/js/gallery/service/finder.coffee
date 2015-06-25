angular.module('cycleGallery').service 'Finder', ->
    
  loadGalleryObject: ($element) ->
    $parent = $element

    while ($parent.attr('cycle-gallery') == undefined)
      $parent = $parent.parent()
      new Error('There are not parent element with attribute [cycle-gallery]') if $parent[0] == undefined

    $parent[0].cycleGallery
