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

    .state 'example',
      abstract: true,
      url: '/',
      templateUrl: 'layout/example.html'

    .state 'example.animation',
      url: 'animation_example',
      templateUrl: 'views/animation.html'

    .state 'example.simple',
      url: 'simple_example',
      templateUrl: 'views/simple.html'

    .state 'example.fix',
      url: 'fix',
      templateUrl: 'views/fix.html'

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
    {text: 'Item 1', sref: 'http://wfiles.brothersoft.com/a/alpine-mountain-austria_107989-1600x1200.jpg'}
    {text: 'Item 2', sref: 'http://wfiles.brothersoft.com/a/alpine-mountain-austria_107989-1600x1200.jpg'}
    {text: 'Item 3', sref: 'http://www.jpegwallpapers.com/images/wallpapers/Mountain-466704.jpeg'}
    {text: 'Item 4', sref: 'http://www.mrwallpaper.com/wallpapers/summer-mountain-lake-1600x1200.jpg'}
    {text: 'Item 5', sref: 'http://wfiles.brothersoft.com/i/iceland_mountain_and_lake_37299-1600x1200.jpg'}
    {text: 'Item 6', sref: 'http://www.photography-match.com/views/images/gallery/Mountain_Mist_Alberta_Canada___1600x1200___ID_.jpg'}
    {text: 'Item 7', sref: 'http://www.pcwalls.net/download/mountain_lake_wallpaper_7-1600x1200.jpg'}
    {text: 'Item 8', sref: 'http://www.wallpaper77.com/upload/DesktopWallpapers/cache/Top-of-Mountain-landscape-mountain-1600x1200.jpg'}
    {text: 'Item 9', sref: 'http://www.mrwallpaper.com/wallpapers/Mountain-scenery-1600x1200.jpg'}
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
