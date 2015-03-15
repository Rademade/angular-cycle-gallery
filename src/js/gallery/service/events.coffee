angular.module('multiGallery').service 'GalleryEvents', [ ->

  # TODO use native events

  _stack: {}

  on: (name, func) ->
    unless @_stack[name] then @_stack[name] = []
    @_stack[name].push(func)

  do: (name) ->
    if @_stack[name]
      for func in @_stack[name]
        func()

]