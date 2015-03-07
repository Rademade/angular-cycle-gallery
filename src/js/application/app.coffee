app = angular.module('app', ['multiGallery'])

app.controller 'AppController', ['$scope', ($scope) ->

  i = 10

  $scope.gallery = [
    {text: 'Item 1'},
    {text: 'Item 2'},
    {text: 'Item 3'},
    {text: 'Item 4'},
    {text: 'Item 5'},
    {text: 'Item 6'},
    {text: 'Item 7'},
    {text: 'Item 8'},
    {text: 'Item 9'},
    {text: 'Item 10'}
  ]

  $scope.add = ->
    ++i
    $scope.gallery.push text: "Item #{i}"

  window.s = $scope

]