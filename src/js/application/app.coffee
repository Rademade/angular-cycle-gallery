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

    .state 'public.fix',
      url: 'fix',
      templateUrl: 'views/fix.html'

    $urlRouterProvider.otherwise '/'

    $locationProvider.html5Mode
      enabled: true
      requireBase: false
      html5Mode: false

])

app.controller 'GalleryController', ($scope) ->

  $scope.otherItems = [
    {text: 'First'}
    {text: 'Second'}
  ]

  $scope.gallery = [
    {text: 'Item 1', sref: 'https://images.wallpaperscraft.ru/image/pirs_prichal_more_sumerki_bereg_118549_1920x1080.jpg'}
    {text: 'Item 2', sref: 'https://images.wallpaperscraft.ru/image/zvezdnoe_nebo_noch_derevya_nochnoj_pejzazh_118760_1920x1080.jpg'}
    {text: 'Item 3', sref: 'https://images.wallpaperscraft.ru/image/derevo_tuman_priroda_krasivo_84257_1920x1080.jpg'}
    {text: 'Item 4', sref: 'https://images.wallpaperscraft.ru/image/plyazh_tropiki_more_pesok_palmy_zakat_84729_1920x1080.jpg'}
    {text: 'Item 5', sref: 'https://images.wallpaperscraft.ru/image/conzelman_road_zakat_povorot_doroga_more_93620_1920x1080.jpg'}
    {text: 'Item 6', sref: 'https://images.wallpaperscraft.ru/image/more_bereg_skaly_podvodnyy_mir_rastitelnost_ryba_53966_1920x1080.jpg'}
    {text: 'Item 7', sref: 'https://images.wallpaperscraft.ru/image/plyazh_tropiki_more_pesok_leto_84726_1920x1080.jpg'}
    {text: 'Item 8', sref: 'https://images.wallpaperscraft.ru/image/gory_reka_sneg_zima_93245_1920x1080.jpg'}
    {text: 'Item 9', sref: 'https://images.wallpaperscraft.ru/image/leto_priroda_doroga_listya_derevya_90616_1920x1080.jpg'}
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
