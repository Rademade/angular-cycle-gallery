# Angular-cycle-gallery 

AngularJS **responsive** gallery with loop items listing. Support:
- Loop listing
- Optimized items render
- Next / Prev buttons
- Animation for next and previous items 
- Touch scrolling support. **Amazing!**

#### [Live demo](http://angular-cycle-gallery.rademade.com)

#### [Check jsfiddle.net example](https://jsfiddle.net/08b8uonz/5/)

## Installation guide

1. Add bower component `bower install angular-cycle-gallery --save`
2. Add JS  file. Path `build/angular-cycle-gallery.min.js`
3. Add `cycleGallery` dependency to application

		app = angular.module('app', ['cycleGallery'])

4. Add gallery structure to template

        div.wrapper(cycle-gallery)
            div.slider(cycle-gallery-holder)
                div.item(gallery-repeater="item in list") {{item.content}}

5. Add list object to scope

		$scope.list = [
			{content: 'First'},
			{content: 'Second'}
		];

6. Add styles to your application. [SASS example](https://github.com/Rademade/angular-cycle-gallery/blob/master/src/sass/import.sass)

## API and supported options

#### Directives and options

 We need to mark tags. For working library we use 3 elements: `cycle-gallery`, `cycle-gallery-holder`, `gallery-repeater`

1. `cycle-gallery` support such attributes:

		config-buffer="2" # integer
	    config-animation-time="250" # integer
	    gallery-index="indexVariable" # 2 way binding for gallery index
	    gallery-init="onGalleryInit" # Callback method. Call when gallery load

2. `cycle-gallery-holder` marks holder element
3. `gallery-repeater="item in list"` has same logic like `ng-repeat` but render only needed part of elements


#### Javascript API

Method `gallery-init` receive object that can manipulate with cycle-gallery

Template:
```slim
div.wrapper(cycle-gallery gallery-init="onGalleryInit")
    // ...
```

Controller:
```javascript
function onGalleryInit(gallery) {
	gallery.setIndex(1) # Set index with javascript API
	gallery.getIndex() # Get current index
	gallery.updateSizes() # Update gallery sizes and rerender gallery
}
```

#### Complete example

Rich template example
```slim
div.wrapper(
	ng-controller="GalleryController"
    cycle-gallery
    config-buffer="2"
    config-animation-time="250"
    gallery-index="baseIndex"
    gallery-init="onGalleryInit"
)
    div.slider(cycle-gallery-holder)
        div.gallery-item(gallery-repeater="item in gallery")
	        h1() {{item.text}}

	div.buttons
	    button.action-button.next(gallery-button="next") next
	    button.action-button.prev(gallery-button="prev") prev
	    button.action-button.next.animate(gallery-button="animateNext") Animate next
	    button.action-button.prev.animate(gallery-button="animatePrev") Animate prev
```

Controller example
```coffee
app.controller 'GalleryController', ($scope) ->

	$scope.baseIndex = 1

	$scope.gallery = [
	    {text: 'Item 1'}
	    {text: 'Item 2'}
	    {text: 'Item 3'}
	]

	$scope.onGalleryInit = (gallery) ->
		# We can call other methods
		console.log( gallery.getIndex() )
```
