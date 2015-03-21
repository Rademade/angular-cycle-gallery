# Angular-cycle-gallery 

AngularJS responsive gallery with loop items listing. Support:
- Next / Prev buttons
- Animation for next and previous items 
- Touch scrolling support. **Amazing!**

#### Live demo -> [Try it now](http://angular-cycle-gallery.rademade.com)


## How to use?

### Template example

```slim
  div.gallery-wrapper(gallery-config-buffer="2")
      div.gallery-slider
          div.gallery-item(gallery-repeater="item in gallery")
              div.gallery-item-content() {{item.text}}

      button.action-button.next(gallery-button="next") next
      button.action-button.prev(gallery-button="prev") prev
      button.action-button.next.animate(gallery-button="animateNext") Animate next
      button.action-button.prev.animate(gallery-button="animatePrev") Animate prev
```

### Controller example

```coffee
app = angular.module('app', ['multiGallery'])

app.controller 'AppController', ['$scope', ($scope) ->

  $scope.gallery = [
    {text: 'Item 1'}
    {text: 'Item 2'}
    {text: 'Item 3'}
    {text: 'Item 4'}
    {text: 'Item 5'}
  ]
  
  $scope.forceUpdate = ->
    $scope.setGalleryIndex(2)

  $scope.$watch '$galleryIndex', (index)->
    console.log('Gallery item index changed', index)

]
```

### Styles

Copy style to your project or use build of bower components
- [Link for styles](https://github.com/Rademade/angular-cycle-gallery/blob/master/src/sass/import.sass)
- Path for bower build styles: */build/stylesheets.min.css*

