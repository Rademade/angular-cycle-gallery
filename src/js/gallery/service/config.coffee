angular.module('multiGallery').service 'GalleryConfig', ->

  _config: {
    buffer: 2,
    animationSpeed: 300
  }

  setBuffer: (number) -> 
  	@_config.buffer = parseInt(number, 10)
  
  getBuffer: -> 
  	@_config.buffer

  getAnimationSpeed: ->
  	@_config.animationSpeed

  getConfig: ->
  	@_config