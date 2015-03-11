app = angular.module('app', ['multiGallery'])

app.controller 'AppController', ['$scope', ($scope) ->

  $scope.gallery = [
    {text: 'Item 1', color: 'red'}
    {text: 'Item 2', color: 'blue'}
    {text: 'Item 3', color: 'yellow'}
    {text: 'Item 4', color: 'white'}
    {text: 'Item 5', color: 'black'}
    {text: 'Item 6', color: 'red'}
    {text: 'Item 7', color: 'blue'}
    {text: 'Item 8', color: 'yellow'}
    {text: 'Item 9', color: 'white'}
    {text: 'Item 10', color: 'black'}
    {text: 'Item 11', color: 'red'}
    {text: 'Item 12', color: 'blue'}
    {text: 'Item 13', color: 'yellow'}
    {text: 'Item 14', color: 'white'}
    {text: 'Item 15', color: 'black'}
    {text: 'Item 16', color: 'red'}
    {text: 'Item 17', color: 'blue'}
    {text: 'Item 18', color: 'yellow'}
    {text: 'Item 19', color: 'white'}
    {text: 'Item 20', color: 'black'}
    {text: 'Item 21', color: 'white'}
  ]

  $scope.add = ->
    count = $scope.gallery.length
    $scope.gallery.push text: "Item #{count}"


  window.s = $scope

]