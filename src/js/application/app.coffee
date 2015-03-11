app = angular.module('app', ['multiGallery'])

app.controller 'AppController', ['$scope', ($scope) ->

  $scope.gallery = [
    {text: 'Item 1', color: 'red'}
    {text: 'Item 2', color: 'blue'}
  ]

  $scope.add = ->
    count = $scope.gallery.length
    $scope.gallery.push text: "Item #{count}"


  window.s = $scope

]