app = angular.module('app', ['ui.router','cycleGallery'])

app.config([
  '$stateProvider', '$urlRouterProvider', '$locationProvider',
  ($stateProvider, $urlRouterProvider, $locationProvider) ->

    $stateProvider

    .state 'public',
      abstract: true,
      url: '/',
      templateUrl: 'layout/main.html',
      # controller: 'LayoutController'

    .state 'public.index',
      url: '',
      templateUrl: 'views/index.html'

    .state 'public.animation',
      url: 'animation_example',
      templateUrl: 'views/animation.html'

    .state 'public.simple',
      url: 'simple_example',
      templateUrl: 'views/simple.html'

    $urlRouterProvider.otherwise '/'

    $locationProvider.html5Mode
      enabled: true
      requireBase: false
      html5Mode: true

])

app.controller 'GalleryController', ($scope) ->

  $scope.otherItems = [
    {text: 'First'}
    {text: 'Second'}
  ]

  $scope.gallery = [
    {text: 'Item 1', color: 'red'}
    {text: 'Item 2', color: 'blue'}
    {text: 'Item 3', color: 'green'}
    {text: 'Item 4', color: 'yellow'}
    {text: 'Item 5', color: 'black'}
    {text: 'Item 6', color: 'grey'}
    {text: 'Item 7', color: 'purple'}
    {text: 'Item 8', color: 'darkgreen'}
    {text: 'Item 9', color: 'darkblue'}
    {text: 'Item 10', color: 'yellow'}
    {text: 'Item 11', color: 'darkgrey'}
  ]

  $scope.baseIndex = 5
  $scope.showGallery = true

  _gallery = null

  $scope.onGalleryInit = (gallery) -> _gallery = gallery

  $scope.add = ->
    count = $scope.gallery.length
    $scope.gallery.push text: "Item #{count}"
    _gallery.setIndex(1)

  $scope.toggleGallery = ->
    $scope.showGallery = !$scope.showGallery
