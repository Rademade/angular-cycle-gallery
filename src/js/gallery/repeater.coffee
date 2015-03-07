angular.module('multiGallery').directive 'galleryRepeater', [
  'GalleryDirective', 'GalleryEvents',
  (GalleryDirective, GalleryEvents)->

    terminal: true
    transclude : 'element'
    terminal : true
    $$tlb : true

    link: ($scope, $element, $attr, nullController, transclude) ->

      _repeatAttributes = $attr.galleryRepeater
      _matchResult = _repeatAttributes.match(/^\s*(.+)\s+in\s+(.*?)\s*(\s+track\s+by\s+(.+)\s*)?$/)
      _scopeItemName = _matchResult[1]
      _collectionName = _matchResult[2]

      gallery = new GalleryDirective($scope, _scopeItemName, $element.parent(), transclude)

      GalleryEvents.on 'update', ->
        gallery.update()
        $scope.$apply() unless $scope.$$phase

      $scope.$watchCollection _collectionName, (items)-> gallery.setItems(items)

]