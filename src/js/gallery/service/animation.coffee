angular.module('cycleGallery').service 'Animation', ->

  DEFAULT_TIME = 300
  FRAME_ANIMATION_TIME = 1000 / 60

  rafId = undefined

  class Animation

    requestAnimationFrame = do () ->
      window.requestAnimationFrame ||
      window.webkitRequestAnimationFrame ||
      window.mozRequestAnimationFrame ||
      window.oRequestAnimationFrame ||
      window.msRequestAnimationFrame ||
      (callback) ->
        setTimeout callback, FRAME_ANIMATION_TIME

    linear : (animateParams) ->
      cancelAnimationFrame rafId

      animateParams.time ||= DEFAULT_TIME
      animateParams.element.style.transition = 'linear'
      start = +new Date

      animate = () ->
        currentTime = +new Date() - start
        newPosition = animateParams.to + (animateParams.to - animateParams.from) * (currentTime - animateParams.time) / animateParams.time
        if currentTime < animateParams.time
          animateParams.element.style.left = newPosition + 'px'
          rafId = requestAnimationFrame(animate)
        else
          animateParams.element.style.left = animateParams.position + 'px'
          animateParams.onComplete()

      rafId = requestAnimationFrame(animate)
