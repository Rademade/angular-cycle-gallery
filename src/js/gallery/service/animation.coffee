angular.module('cycleGallery').service 'animationService', ->

  DEFAULT_TIME = 250
  FRAME_ANIMATION_TIME = 1000 / 60

  rafId = undefined

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
      time = animateParams.time
      currentTime = +new Date() - start
      newPosition = animateParams.to + (animateParams.to - animateParams.from) * (currentTime - time) / time

      if currentTime < time
        animateParams.element.style.left = newPosition + 'px'
        rafId = requestAnimationFrame(animate)
      else
        animateParams.element.style.left = animateParams.position + 'px'
        animateParams.onComplete()
      animateParams.onUpdate()

    rafId = requestAnimationFrame(animate)

  stop : ->
    cancelAnimationFrame rafId
