app = angular.module('app', ['multiGallery'])

app.controller 'AppController', ['$scope', ($scope) ->

  $scope.gallery = [
    {text: 'Item 1', color: 'red'}
    {text: 'Item 2', color: 'blue'}
    {text: 'Item 3', color: 'green'}
  ]

  $scope.add = ->
    count = $scope.gallery.length
    $scope.gallery.push text: "Item #{count}"

  $scope.forceUpdate = ->
    $scope.setGalleryIndex(2)

  $scope.$watch '$galleryIndex', (index)->
    console.log('Gallery item index changed', index)

  window.s = $scope

]