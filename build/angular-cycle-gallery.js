(function() {
  angular.module('multiGallery', []);

}).call(this);

(function() {
  angular.module('multiGallery').directive('galleryButton', [
    'GalleryActions', function(GalleryActions) {
      return {
        restrict: 'A',
        link: function(scope, element, attrs, controller) {
          var action_name;
          action_name = attrs.galleryButton;
          return element.on('click', function(e) {
            return GalleryActions[action_name]();
          });
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('multiGallery').directive('galleryRepeater', [
    'GalleryRenderer', 'ItemsStorage', 'MoverHolder', 'GalleryMover', 'MoverTouch', 'GalleryEvents', 'Resize', '$window', '$rootScope', function(GalleryRenderer, ItemsStorage, MoverHolder, GalleryMover, MoverTouch, GalleryEvents, Resize, $window, $rootScope) {
      return {
        terminal: true,
        transclude: 'element',
        terminal: true,
        $$tlb: true,
        priority: 1000,
        link: function($scope, $element, $attr, nullController, renderFunction) {
          var _$body, _$holder, _collectionName, _galleryIndexName, _matchResult, _repeatAttributes, _scopeItemName, gallery, holder, mover, resize, storage, touch, updateIndex;
          _repeatAttributes = $attr.galleryRepeater;
          _matchResult = _repeatAttributes.match(/^\s*(.+)\s+in\s+(.*?)\s*(\s+track\s+by\s+(.+)\s*)?$/);
          _scopeItemName = _matchResult[1];
          _collectionName = _matchResult[2];
          _galleryIndexName = '$galleryIndex';
          _$holder = $element.parent();
          _$body = angular.element(document).find('body');
          storage = new ItemsStorage();
          gallery = new GalleryRenderer($scope, _scopeItemName, _$holder, renderFunction);
          holder = new MoverHolder(_$holder);
          mover = new GalleryMover(storage, gallery, holder, $scope);
          touch = new MoverTouch(mover, holder);
          resize = new Resize(mover, holder);
          GalleryEvents.on('move:next', function() {
            return mover.next();
          });
          GalleryEvents.on('move:prev', function() {
            return mover.prev();
          });
          GalleryEvents.on('animate:next', function() {
            return mover.animateNext();
          });
          GalleryEvents.on('animate:prev', function() {
            return mover.animatePrev();
          });
          GalleryEvents.on('index:update', function() {
            return updateIndex();
          });
          $scope.$watchCollection(_collectionName, function(items) {
            return mover.render(items);
          });
          angular.element($window).bind('resize', function() {
            return resize["do"]();
          });
          _$holder.on('touchstart', function(e) {
            return touch.touchStart(e.touches[0].pageX);
          });
          _$body.on('touchend', function(e) {
            return touch.touchEnd();
          });
          _$body.on('touchmove', function(e) {
            return touch.touchMove(e.touches[0].pageX);
          });
          $rootScope.setGalleryIndex = function(index) {
            return mover.setIndex(index - 0);
          };
          updateIndex = function() {
            return $scope[_galleryIndexName] = storage.getIndex();
          };
          return updateIndex();
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('multiGallery').service('GalleryActions', [
    'GalleryEvents', function(GalleryEvents) {
      return {
        next: function() {
          return GalleryEvents["do"]('move:next');
        },
        prev: function() {
          return GalleryEvents["do"]('move:prev');
        },
        animateNext: function() {
          return GalleryEvents["do"]('animate:next');
        },
        animatePrev: function() {
          return GalleryEvents["do"]('animate:prev');
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('multiGallery').service('CycleGenerator', function() {
    var AUTO_INCREMENT, CycleGenerator;
    AUTO_INCREMENT = 0;
    return CycleGenerator = (function() {
      function CycleGenerator() {}

      CycleGenerator.prototype._count = 0;

      CycleGenerator.prototype._items = [];

      CycleGenerator.prototype._cycleItems = [];

      CycleGenerator.prototype.setItems = function(items) {
        this._items = items;
        this._count = items.length;
        this._cycleItems = [];
        return this._cycleGenerate(1);
      };

      CycleGenerator.prototype.sliceItems = function(from, to) {
        if (to > this._cycleItems.length - 1) {
          this._cycleGenerate(Math.ceil(to / this._count));
        }
        return this._cycleItems.slice(from, to);
      };

      CycleGenerator.prototype._cycleGenerate = function(cycleMultiplier) {
        var i, items, j, ref, results;
        results = [];
        for (i = j = 0, ref = cycleMultiplier; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
          items = JSON.parse(JSON.stringify(this._items));
          results.push(this._cycleItems = this._cycleItems.concat(this._addUIID(items)));
        }
        return results;
      };

      CycleGenerator.prototype._addUIID = function(items) {
        var item, j, len;
        for (j = 0, len = items.length; j < len; j++) {
          item = items[j];
          item._$UUID = ++AUTO_INCREMENT;
        }
        return items;
      };

      return CycleGenerator;

    })();
  });

}).call(this);

(function() {
  angular.module('multiGallery').service('GalleryEvents', [
    function() {
      return {
        _stack: {},
        on: function(name, func) {
          if (!this._stack[name]) {
            this._stack[name] = [];
          }
          return this._stack[name].push(func);
        },
        "do": function(name) {
          var func, i, len, ref, results;
          if (this._stack[name]) {
            ref = this._stack[name];
            results = [];
            for (i = 0, len = ref.length; i < len; i++) {
              func = ref[i];
              results.push(func());
            }
            return results;
          }
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('multiGallery').service('GalleryRenderer', [
    'RenderedItems', function(RenderedItems) {
      var GalleryRenderer;
      return GalleryRenderer = (function() {
        GalleryRenderer.prototype._renderedItems = new RenderedItems();

        GalleryRenderer.prototype._transcludeFunction = null;

        GalleryRenderer.prototype._$scope = null;

        GalleryRenderer.prototype._scopeItemName = null;

        GalleryRenderer.prototype._$holder = null;

        function GalleryRenderer($scope, scopeItemName, $holder, transcludeFunction) {
          this._$scope = $scope;
          this._scopeItemName = scopeItemName;
          this._$holder = $holder;
          this._transcludeFunction = transcludeFunction;
        }

        GalleryRenderer.prototype.render = function(items) {
          this._renderedItems.markAllOutdated();
          this._updateRenderedPosition(items);
          this._renderedItems.removeOutdated();
          return this._updateHolder();
        };

        GalleryRenderer.prototype.getRenderedCount = function() {
          return this._renderedItems.getCount();
        };

        GalleryRenderer.prototype.firstElement = function() {
          return this._renderedItems.firstElement();
        };

        GalleryRenderer.prototype.getElementByIndex = function(index) {
          return this._$holder.children().eq(index)[0];
        };

        GalleryRenderer.prototype.getRightElementsCount = function($element) {
          return this.getRenderedCount() - this.getElementIndex($element);
        };

        GalleryRenderer.prototype.getElementIndex = function(element) {
          var i;
          i = 0;
          while ((element = element.previousSibling) !== null) {
            ++i;
          }
          return i;
        };

        GalleryRenderer.prototype._updateRenderedPosition = function(items) {
          var i, item, j, len, results;
          results = [];
          for (i = j = 0, len = items.length; j < len; i = ++j) {
            item = items[i];
            results.push(this._renderedItems.addItem(i, item));
          }
          return results;
        };

        GalleryRenderer.prototype._updateHolder = function(items) {
          var $itemScope, item, j, len, ref, results;
          ref = this._renderedItems.getItemsForRender();
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            item = ref[j];
            $itemScope = this._newItemScope(item.getData());
            results.push(this._transcludeFunction($itemScope, (function(_this) {
              return function($element) {
                item.setRenderData($itemScope, $element);
                return _this._appendItem(item, $element);
              };
            })(this)));
          }
          return results;
        };

        GalleryRenderer.prototype._appendItem = function(item, $element) {
          if (item.getIndex() === 0) {
            return this._$holder.prepend($element);
          } else {
            return this._renderedItems.getElementByIndex(item.getIndex() - 1).after($element);
          }
        };

        GalleryRenderer.prototype._newItemScope = function(item) {
          var $itemScope;
          $itemScope = this._$scope.$new();
          $itemScope[this._scopeItemName] = item;
          return $itemScope;
        };

        return GalleryRenderer;

      })();
    }
  ]);

}).call(this);

(function() {
  angular.module('multiGallery').service('ItemsStorage', [
    'CycleGenerator', 'GalleryEvents', function(CycleGenerator, GalleryEvents) {
      var ItemsStorage;
      return ItemsStorage = (function() {
        function ItemsStorage() {}

        ItemsStorage.prototype.NEAREST_ITEMS = 2;

        ItemsStorage.prototype.items = [];

        ItemsStorage.prototype.index = 0;

        ItemsStorage.prototype.count = 0;

        ItemsStorage.prototype.nextBuffer = 0;

        ItemsStorage.prototype.prevBuffer = 0;

        ItemsStorage.prototype.cycleMultiplier = 0;

        ItemsStorage.prototype.nextCycleItems = new CycleGenerator();

        ItemsStorage.prototype.prevCycleItems = new CycleGenerator();

        ItemsStorage.prototype.setItems = function(items) {
          this.count = items.length;
          this.items = items;
          this.nextCycleItems.setItems(this.items);
          this.prevCycleItems.setItems(this.items);
          return this.setIndex(0);
        };

        ItemsStorage.prototype.getNearestRange = function() {
          if (this.count === 0) {
            return [];
          }
          return [].concat(this.getPrevRangeItems(), this.getNextRangeItems());
        };

        ItemsStorage.prototype.getIndex = function() {
          return this.index;
        };

        ItemsStorage.prototype.getPrevRangeItems = function() {
          var cycle_multiplier, from_index, items_count, to_index;
          items_count = this.NEAREST_ITEMS + this.prevBuffer;
          cycle_multiplier = (((items_count + this.index) / this.count) | 0) + 1;
          from_index = this.count * cycle_multiplier - items_count + this.index;
          to_index = from_index + items_count;
          return this.prevCycleItems.sliceItems(from_index, to_index);
        };

        ItemsStorage.prototype.getNextRangeItems = function() {
          var from_index, items_count, to_index;
          items_count = this.NEAREST_ITEMS + this.nextBuffer;
          from_index = this.index;
          to_index = from_index + items_count + 1;
          return this.nextCycleItems.sliceItems(from_index, to_index);
        };

        ItemsStorage.prototype.nextIndex = function() {
          return this.setIndex(this.index + 1);
        };

        ItemsStorage.prototype.prevIndex = function() {
          return this.setIndex(this.index - 1);
        };

        ItemsStorage.prototype.getCurrentIndexInRange = function() {
          return this.NEAREST_ITEMS - this.prevBuffer + this.nextBuffer;
        };

        ItemsStorage.prototype.clearRangeBuffer = function() {
          this._clearNextBuffer();
          return this._clearPrevBuffer();
        };

        ItemsStorage.prototype.incNextBuffer = function() {
          return ++this.nextBuffer;
        };

        ItemsStorage.prototype.getNextBuffer = function() {
          return this.nextBuffer;
        };

        ItemsStorage.prototype.incPrevBuffer = function() {
          return ++this.prevBuffer;
        };

        ItemsStorage.prototype.getPrevBuffer = function() {
          return this.prevBuffer;
        };

        ItemsStorage.prototype._clearNextBuffer = function() {
          this.setIndex(this.index + this.nextBuffer);
          return this.nextBuffer = 0;
        };

        ItemsStorage.prototype._clearPrevBuffer = function() {
          this.setIndex(this.index - this.prevBuffer);
          return this.prevBuffer = 0;
        };

        ItemsStorage.prototype.setIndex = function(index) {
          var fixed_index;
          fixed_index = this._fixIndex(index);
          if (this.index !== fixed_index) {
            this.index = fixed_index;
            return GalleryEvents["do"]('index:update');
          }
        };

        ItemsStorage.prototype._fixIndex = function(index) {
          if (index >= this.count && this.count > 0) {
            index = index % this.count;
          }
          if (index < 0) {
            index = this.count + index;
          }
          if (!((0 <= index && index < this.count) || this.count === 0)) {
            index = this._fixIndex(index);
          }
          return index;
        };

        return ItemsStorage;

      })();
    }
  ]);

}).call(this);

(function() {
  angular.module('multiGallery').service('GalleryMover', function() {
    var GalleryMover;
    return GalleryMover = (function() {
      GalleryMover.prototype.ANIMATION_TIME = 300;

      GalleryMover.prototype.ANIMATION_SIDE_NEXT = 1;

      GalleryMover.prototype.ANIMATION_SIDE_PREV = 2;

      GalleryMover.prototype._storage = null;

      GalleryMover.prototype._renderer = null;

      GalleryMover.prototype._holder = null;

      GalleryMover.prototype._$scope = null;

      GalleryMover.prototype._animation = null;

      GalleryMover.prototype._checked_position = null;

      GalleryMover.prototype._itemWidth = 0;

      GalleryMover.prototype._moveIndex = 0;

      function GalleryMover(storage, renderer, holder, $scope) {
        this._storage = storage;
        this._renderer = renderer;
        this._holder = holder;
        this._$scope = $scope;
      }

      GalleryMover.prototype.render = function(items) {
        this._storage.setItems(items);
        this._renderer.render(this._storage.getNearestRange());
        this._holder.update();
        this._syncMoveIndex();
        return this._applyCurrentIndexPosition();
      };

      GalleryMover.prototype.setIndex = function(index) {
        if (this._animation_side) {
          return this._stopAnimationSide();
        }
        this._storage.setIndex(index);
        this._syncMoveIndex();
        this._stopPreviusAnimation();
        return this._rerender();
      };

      GalleryMover.prototype.next = function() {
        if (this._animation_side) {
          return this._stopAnimationSide();
        }
        this._storage.nextIndex();
        this._syncMoveIndex();
        return this._rerender();
      };

      GalleryMover.prototype.prev = function() {
        if (this._animation_side) {
          return this._stopAnimationSide();
        }
        this._storage.prevIndex();
        this._syncMoveIndex();
        return this._rerender();
      };

      GalleryMover.prototype.animateNext = function() {
        if (this._animation_side === this.ANIMATION_SIDE_PREV) {
          return this._stopAnimationSide();
        }
        this._clearAnimationTime();
        this._storage.incNextBuffer();
        return this._animate();
      };

      GalleryMover.prototype.animatePrev = function() {
        if (this._animation_side === this.ANIMATION_SIDE_NEXT) {
          return this._stopAnimationSide();
        }
        this._clearAnimationTime();
        this._storage.incPrevBuffer();
        return this._animate();
      };

      GalleryMover.prototype.forceMove = function(position) {
        this._holder.setPosition(this._getPositionForMoveIndex() + position);
        return this._detectPosition();
      };

      GalleryMover.prototype.applyIndexDiff = function(index_diff) {
        this._storage.setIndex(this._storage.getIndex() + index_diff);
        this._storage.clearRangeBuffer();
        this._syncMoveIndex();
        this._rerender();
        return this._detectPositionClear();
      };

      GalleryMover.prototype._stopPreviusAnimation = function() {
        if (this._animation) {
          this._animation.pause();
        }
        if (this._animation) {
          return this._animation.kill();
        }
      };

      GalleryMover.prototype._stopAnimationSide = function() {
        this._stopPreviusAnimation();
        this._clearAnimationTime();
        this._animation_side = null;
        this._storage.clearRangeBuffer();
        this._syncMoveIndex();
        return this._rerender();
      };

      GalleryMover.prototype._getAnimationTime = function() {
        var timestamp;
        timestamp = (new Date()).getTime();
        if (!this._animationStartTime) {
          this._animationStartTime = timestamp;
        }
        return this.ANIMATION_TIME - (timestamp - this._animationStartTime);
      };

      GalleryMover.prototype._clearAnimationTime = function() {
        return this._animationStartTime = null;
      };

      GalleryMover.prototype._animate = function(position) {
        if (position == null) {
          position = this._getPositionForCurrentIndex();
        }
        this._stopPreviusAnimation();
        return this._animation = TweenMax.to(this._holder.getElement(), this._getAnimationTime() / 1000, {
          left: position + 'px',
          ease: Linear.easeNone,
          onUpdate: (function(_this) {
            return function() {
              return _this._checkFrameChange();
            };
          })(this),
          onComplete: (function(_this) {
            return function() {
              return _this._onCompleteAnimation();
            };
          })(this)
        });
      };

      GalleryMover.prototype._onCompleteAnimation = function() {
        this._clearAnimationTime();
        this._detectPositionClear();
        this._storage.clearRangeBuffer();
        this._syncMoveIndex();
        return this._rerender();
      };

      GalleryMover.prototype._detectPosition = function() {
        var position_diff;
        this._holder.createPositionLock();
        position_diff = this._holder.getPositionLockDiff();
        if (!(Math.abs(position_diff) > 5)) {
          return false;
        }
        if (position_diff < 0) {
          this._animation_side = this.ANIMATION_SIDE_NEXT;
        } else {
          this._animation_side = this.ANIMATION_SIDE_PREV;
        }
        return true;
      };

      GalleryMover.prototype._detectPositionClear = function() {
        this._holder.clearPositionLock();
        return this._animation_side = null;
      };

      GalleryMover.prototype._checkFrameChange = function(changeCallback) {
        var $current_element, display_index, moveToPosition, right_items_count;
        if (!this._detectPosition()) {
          return false;
        }
        if ((display_index = this._holder.getDisplayIndex()) === this.getMoveIndex()) {
          return false;
        }
        this._stopPreviusAnimation();
        $current_element = this._renderer.getElementByIndex(display_index);
        right_items_count = this._renderer.getRightElementsCount($current_element);
        this._animationRender();
        if (this._animation_side === this.ANIMATION_SIDE_NEXT) {
          this._moveIndex++;
          moveToPosition = this._getPositionForCurrentIndex();
        } else {
          this._moveIndex = this._renderer.getRenderedCount() - right_items_count;
          moveToPosition = this._holder.__calculatePositionForIndex(this._storage.NEAREST_ITEMS);
          this._holder.setPosition(this._getPositionForMoveIndex() + this._holder.getSlideDiff());
        }
        this._detectPositionClear();
        return this._animate(moveToPosition);
      };

      GalleryMover.prototype._applyMoveIndexPosition = function() {
        return this._holder.setPosition(this._getPositionForMoveIndex());
      };

      GalleryMover.prototype._applyCurrentIndexPosition = function() {
        return this._holder.setPosition(this._getPositionForCurrentIndex());
      };

      GalleryMover.prototype._getPositionForMoveIndex = function() {
        return this._holder.__calculatePositionForIndex(this.getMoveIndex());
      };

      GalleryMover.prototype._getPositionForCurrentIndex = function() {
        return this._holder.__calculatePositionForIndex(this.getTrueMoveIndex());
      };

      GalleryMover.prototype.getTrueMoveIndex = function() {
        return this._storage.getCurrentIndexInRange();
      };

      GalleryMover.prototype.getMoveIndex = function() {
        return this._moveIndex;
      };

      GalleryMover.prototype._syncMoveIndex = function() {
        return this._moveIndex = this.getTrueMoveIndex();
      };

      GalleryMover.prototype._animationRender = function() {
        this._renderer.render(this._storage.getNearestRange());
        return this._$scope.$apply();
      };

      GalleryMover.prototype._rerender = function() {
        this._renderer.render(this._storage.getNearestRange());
        this._applyMoveIndexPosition();
        if (!this._$scope.$$phase) {
          return this._$scope.$apply();
        }
      };

      return GalleryMover;

    })();
  });

}).call(this);

(function() {
  angular.module('multiGallery').service('RenderedItem', function() {
    var RenderedItem;
    return RenderedItem = (function() {
      RenderedItem.prototype._index = null;

      RenderedItem.prototype._data = null;

      RenderedItem.prototype._element = null;

      RenderedItem.prototype._scope = null;

      RenderedItem.prototype._outdate = null;

      RenderedItem.prototype._rendered = false;

      function RenderedItem(index, data) {
        this._index = index;
        this._data = data;
        this._outdate = false;
      }

      RenderedItem.prototype.getIndex = function() {
        return this._index;
      };

      RenderedItem.prototype.isDataMatch = function(data) {
        return this._data._$UUID === data._$UUID;
      };

      RenderedItem.prototype.getData = function() {
        return this._data;
      };

      RenderedItem.prototype.getElement = function() {
        return this._element;
      };

      RenderedItem.prototype.updateRenderIndex = function(index) {
        this._index = index;
        this._outdate = false;
        return this._rendered = true;
      };

      RenderedItem.prototype.setRenderData = function(scope, element) {
        this._scope = scope;
        this._element = element;
        this._outdate = false;
        return this._rendered = true;
      };

      RenderedItem.prototype.destroy = function() {
        this._element.remove();
        return this._scope.$destroy();
      };

      RenderedItem.prototype.isOutdate = function() {
        return this._outdate;
      };

      RenderedItem.prototype.markOutdated = function() {
        return this._outdate = true;
      };

      RenderedItem.prototype.isWaitingForRender = function() {
        return this._outdate === false && this._rendered === false;
      };

      return RenderedItem;

    })();
  });

}).call(this);

(function() {
  angular.module('multiGallery').service('RenderedItems', [
    'RenderedItem', function(RenderedItem) {
      var RenderedItems;
      return RenderedItems = (function() {
        function RenderedItems() {}

        RenderedItems.prototype._items = [];

        RenderedItems.prototype.addItem = function(index, data) {
          var item, j, len, ref;
          ref = this._items;
          for (j = 0, len = ref.length; j < len; j++) {
            item = ref[j];
            if (item.isDataMatch(data)) {
              item.updateRenderIndex(index);
              return true;
            }
          }
          return this._items.push(new RenderedItem(index, data));
        };

        RenderedItems.prototype.getCount = function() {
          return this._items.length;
        };

        RenderedItems.prototype.getItemsForRender = function() {
          var item, items, j, len, ref;
          items = [];
          ref = this._items;
          for (j = 0, len = ref.length; j < len; j++) {
            item = ref[j];
            if (item.isWaitingForRender()) {
              items.push(item);
            }
          }
          return items;
        };

        RenderedItems.prototype.markAllOutdated = function() {
          var item, j, len, ref, results;
          ref = this._items;
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            item = ref[j];
            results.push(item.markOutdated());
          }
          return results;
        };

        RenderedItems.prototype.removeOutdated = function() {
          var i, index_for_removeing, item, j, k, len, len1, ref, results;
          index_for_removeing = [];
          ref = this._items;
          for (i = j = 0, len = ref.length; j < len; i = ++j) {
            item = ref[i];
            if (item.isOutdate()) {
              index_for_removeing.unshift(i);
              item.destroy();
            }
          }
          results = [];
          for (k = 0, len1 = index_for_removeing.length; k < len1; k++) {
            i = index_for_removeing[k];
            results.push(this._items.splice(i, 1));
          }
          return results;
        };

        RenderedItems.prototype.firstElement = function() {
          return this.getElementByIndex(0);
        };

        RenderedItems.prototype.getElementByIndex = function(index) {
          var item, j, len, ref;
          ref = this._items;
          for (j = 0, len = ref.length; j < len; j++) {
            item = ref[j];
            if (item.getIndex() === index) {
              return item.getElement();
            }
          }
        };

        return RenderedItems;

      })();
    }
  ]);

}).call(this);

(function() {
  angular.module('multiGallery').service('Resize', function() {
    var Resize;
    return Resize = (function() {
      Resize.prototype.mover = null;

      Resize.prototype.holder = null;

      Resize.prototype.resizeTimeout = 0;

      Resize.prototype.resizeDelay = 500;

      function Resize(mover, holder) {
        this.mover = mover;
        this.holder = holder;
      }

      Resize.prototype["do"] = function() {
        clearTimeout(this.resizeTimeout);
        return this.resizeTimeout = setTimeout(((function(_this) {
          return function() {
            return _this._resize();
          };
        })(this)), this.resizeDelay);
      };

      Resize.prototype._resize = function() {
        this.holder.update();
        return this.mover._rerender();
      };

      return Resize;

    })();
  });

}).call(this);

(function() {
  angular.module('multiGallery').service('MoverHolder', function() {
    var MoverHolder;
    return MoverHolder = (function() {
      MoverHolder.prototype._$holder = null;

      MoverHolder.prototype._itemWidth = 0;

      MoverHolder.prototype._position_lock = null;

      function MoverHolder($holder) {
        this._$holder = $holder;
      }

      MoverHolder.prototype.update = function() {
        return this.getItemWidth(false);
      };

      MoverHolder.prototype.getElement = function() {
        return this._$holder;
      };

      MoverHolder.prototype.getDisplayIndex = function() {
        return Math.abs(Math.round(this.getCurrentPosition() / this.getItemWidth()));
      };

      MoverHolder.prototype.getItemWidth = function(cached) {
        var $element;
        if (cached == null) {
          cached = true;
        }
        if (this._itemWidth && cached) {
          return this._itemWidth;
        }
        $element = this._$holder.children().eq(0);
        if ($element[0]) {
          return this._itemWidth = $element[0].offsetWidth;
        }
      };

      MoverHolder.prototype.getCurrentPosition = function() {
        return parseInt(this._$holder.css('left'), 10);
      };

      MoverHolder.prototype.setPosition = function(position) {
        return this._$holder.css('left', position + 'px');
      };

      MoverHolder.prototype.getSlideDiff = function() {
        return this.getCurrentPosition() % this.getItemWidth();
      };

      MoverHolder.prototype.__calculatePositionForIndex = function(index) {
        return this.getItemWidth() * index * -1;
      };

      MoverHolder.prototype.createPositionLock = function() {
        if (!this._position_lock) {
          return this._position_lock = this.getCurrentPosition();
        }
      };

      MoverHolder.prototype.getPositionLockDiff = function() {
        return this.getCurrentPosition() - this._position_lock;
      };

      MoverHolder.prototype.clearPositionLock = function() {
        return this._position_lock = null;
      };

      return MoverHolder;

    })();
  });

}).call(this);

(function() {
  angular.module('multiGallery').service('MoverTouch', function() {
    var MoverTouch;
    return MoverTouch = (function() {
      MoverTouch.prototype._mover = null;

      MoverTouch.prototype._storage = null;

      MoverTouch.prototype._holder = null;

      MoverTouch.prototype.trigger = false;

      MoverTouch.prototype.start_position = 0;

      MoverTouch.prototype.slide_diff = 0;

      function MoverTouch(mover, holder) {
        this._mover = mover;
        this._holder = holder;
      }

      MoverTouch.prototype.touchStart = function(position) {
        this.trigger = true;
        this._mover._stopPreviusAnimation();
        return this.start_position = position;
      };

      MoverTouch.prototype.touchEnd = function() {
        var first_half, position_diff;
        if (!this.trigger) {
          return true;
        }
        this.trigger = false;
        this.start_position = 0;
        position_diff = this._holder.getSlideDiff();
        this._mover.applyIndexDiff(this._holder.getDisplayIndex() - this._mover.getTrueMoveIndex());
        first_half = Math.abs(position_diff) > this._holder.getItemWidth() / 2;
        if (first_half) {
          position_diff += this._holder.getItemWidth();
        }
        this._holder.setPosition(this._holder.getCurrentPosition() + position_diff);
        return this._mover._animate();
      };

      MoverTouch.prototype.touchMove = function(position) {
        if (!this.trigger) {
          return true;
        }
        return this._mover.forceMove(position - this.start_position);
      };

      return MoverTouch;

    })();
  });

}).call(this);
