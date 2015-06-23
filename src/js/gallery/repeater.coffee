angular.module('cycleGallery').directive 'galleryRepeater', [
  'Finder', (Finder)->

    terminal: true
    transclude : 'element'
    terminal : true
    $$tlb : true
    priority: 1000

    link: ($scope, $element, $attr, nullController, renderFunction) =>

      # Attributes
      _repeatAttributes = $attr['galleryRepeater']
      _matchResult = _repeatAttributes.match(/^\s*(.+)\s+in\s+(.*?)\s*(\s+track\s+by\s+(.+)\s*)?$/)
      _scopeItemName = _matchResult[1]
      _collectionName = _matchResult[2]


      # Set options
      gallery = Finder.loadGalleryObject($element)
      gallery.mover.setScope($scope)
      gallery.renderer.setOptions(_scopeItemName, renderFunction)


      # Watchers
      $scope.$watchCollection _collectionName, (items)->
        gallery.mover.render(items)

]