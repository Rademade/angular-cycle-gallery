angular.module('cycleGallery').service 'ResizeEmulatorAction', [
  ->

    class ResizeEmulatorAction

      constructor : (fn, key)->
        @fn = fn
        @key = key

      apply : ->
        @fn.call()

]