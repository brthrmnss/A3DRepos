package org.syncon.onenote.onenotehelpers.base
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.core.ClassFactory;
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.Group;
	import spark.components.Scroller;
	
	
	public class Viewer3 //extends GroupBase
	{
		//http://www.oscar-mejia.com/blog/post/tlf-resiable-textflow-container
		//public var testText : TLFContainer
		//public var defaultWidth: Number = 350;
		public var group : Group; 
		public var groupBg : Group; //
		public var _scroller : Scroller;
		public var listersToMake : int = 10; 
		public var debug : Boolean = false; 
		/**
		 * Forcing refreshing display when new lists are added, this will pickup any missed
		 * changes in contentHeight or contentWidth; 
		 * */
		private var timer_MakeSureContentHeightSet : Timer = new Timer(1500,1)
		
		public function Viewer3()
		{
			this.timer_MakeSureContentHeightSet.addEventListener(TimerEvent.TIMER, this.onCheckContentHeight)
		}
		
		/**
		 * After a list is added, force redrawing of screen later, to ensure listers are sized proplery 
		 * */
		protected function onCheckContentHeight(event:TimerEvent):void
		{
			this.displayDp()
		}
		
		public function set scroller ( s : Scroller ) : void
		{
			this._scroller = s; 
			this.scroller.viewport.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, handleScroll);
		}
		
		/**
		 * Handle scroll position changes
		 */
		private function handleScroll(e: PropertyChangeEvent):void {
			if (e.source == e.target && e.property == "verticalScrollPosition")
			{
				//trace(e.property, "changed to", e.newValue);
				this.updateScrollV = e.newValue as Number
			}
			if (e.source == e.target && e.property == "horizontalScrollPosition")
			{
				//trace(e.property, "changed to", e.newValue);
				this.updateScrollH = e.newValue as Number
			}
			//this.resizeAllListers ;
		}
		public function get scroller ( ) : Scroller 
		{
			return this._scroller
		}		
		
		public var scrollMode : Boolean = true; 
		public function get viewportHeight() : Number
		{
			return this.scroller.height; 
		}
		public function get viewportWidth() : Number
		{
			return this.scroller.width; 
		}		
		private function get page() : IPageVO
		{
			return this._page; 
		}
		private var _page : IPageVO; 
		private var _childrenCreated : Boolean = false; 
		public function set dataProvider( d : IPageVO ) : void
		{
			_page = d; 	
			this.targetXs = -1
			this.targetYs = -1 ; 
			if ( this._childrenCreated == false ) 
			{
				this.createChildren()
			}			
			//this.measureDp()
			
			this.clearListers(); 
			this.measure.measuringTool = this.listsMeasure
			//if page needs to be measured, meausre it , if not .. .don't
			if ( isNaN(this.page.width ) || isNaN( this.page.height ) )
			{
				this.measure.measureLists( this._page.lists.toArray(), this.onMeasuredStuff )
			}
			else
			{
				this.onMeasuredStuff(null); 
			}
		}
		
		private function clearListers():void
		{
			for each ( var lister : IListable in this.listers ) 
			{
				//clear data ...
				lister.visible = false; 
				lister.goHidden(); 
				lister.data = null 
				var o : Object = lister 
				if ( o.parent == null ) 
					throw 'lister was removed from stage'
				//this.addEventListener(Event.REMOVED, this.onRemoved ), but too many events
			}
				
			//clear this so ti refreshes?... why doe sthis matter ... i afraid it is not updating ... 
			//but are you updating manually/ 
			for each ( var list : IListVO in this.listVOs() ) 
			{
				  list.loadedIntoLister = null
			} 
			
			//this.hideListers(); 
		}
		
		/*		
		private var _dp : ArrayCollection ; 
		public function set dp( d :  ArrayCollection ) : void
		{
		_dp = d; 	
		this.targetXs = -1
		this.targetYs = -1 ; 
		if ( this._childrenCreated == false ) 
		{
		this.createChildren()
		}			
		//this.measureDp()
		this.measure.measuringTool = this.listsMeasure
		this.measure.measureLists( this._page.lists.toArray(), this.onMeasuredStuff ) 
		}*/
		
		
		public function listVOs() : Array
		{
			//if ( this._page == null ) 
			//return _dp.toArray()
			return _page.lists.toArray()
		}
		
		
		public var listsMeasure: IListable; 
		private function onMeasuredStuff( e : Array ) : void
		{
			//trace('measured'); 
			this.displayDp()
			setPageSize()
		}
		public var classForListers : Class; 
		protected function createChildren():void
		{
			this._childrenCreated = true; 
			this.listers = []; 
			for ( var i : int = 0 ; i < listersToMake ; i++ )
			{
				var productRenderer:ClassFactory = new ClassFactory(classForListers);
				//productRenderer.properties = { showProductImage: true };
				//myList.itemRenderer = 
				if ( classForListers == null ) 
					throw 'Set classForListeners'
				var lister : IListable = productRenderer.newInstance() as IListable; 
				lister.addEventListener(FlexEvent.CREATION_COMPLETE, this.onListCreated ) 
				//lister.addEventListener( 'updatedLister', this.onUpdatedLister, false, 0, true ); 
				lister.id = 'lister_' + i.toString()
				this.group.addElement( lister as IVisualElement )
				this.listers.push( lister ) ; 
			}
			this.resizeAllListers = this.scroller.height-5; 
		}
		private function onUpdatedLister(e:Event):void
		{
			this.displayDp();
		}
		/**
		 * When lists are create listen for resize when adjusted
		 * */
		private function onListCreated(e:Event):void
		{
			var lister : IListable = e.target as IListable
			lister.addEventListener(ResizeEvent.RESIZE, onHandleListResize);
			adjustListerHeight( lister ) ; 
		}
		private function onHandleListResize(e: ResizeEvent):void {
			var lister : IListable = e.target as IListable
			if ( lister.resetting ) 
				return; 
			if ( lister.visible == false ) 
				return; 
			
			
			for each ( var list : IListVO in this.listVOs() ) 
			{
				if ( list.loadedIntoLister == lister )
				{
					list.width =  lister.width
					list.height =  lister.height
					this.displayDp()
					return //don't go through th elist, only one match
				}
			} 
		}		
		
		private function printDp():void
		{
			trace('data:'); 
			var i : int = 0 
			for each ( var list : IListVO in this.listVOs() ) 
			{
				i++;
				trace( i, list, list.data, list.loadedIntoLister ) ; 
				
			}
			trace('data:'); 
			i = 0 ; 
			for each ( var lister : IListable in this.listers ) 
			{
				i++;
				trace( i, lister,lister.listData, lister.height ) ; 
			}			
		}
		
		/**
		 * Changes size of a lister's internal list. 
		 * Notice that the lister itself is never resized, only the internal list, via this mechanism 
		 * might not be necessary 
		 * */
		private function adjustListerHeight(lister:IListable):void
		{
			return; 
			var oldHeight : Number = 	 lister.height 
			if ( lister.lister.dataGroup.contentHeight > this.viewportHeight ) 
			{
				lister.scrollHeight = this.viewportHeight; 
			}
			else
				lister.scrollHeight = NaN			
			
			// size seems to update atuomatically 
			/*if ( oldHeight != lister.lister.height ) 
			this.setPageSize(); */
		}
		public var measure : MeasureLists = new MeasureLists(); 
		/* 
		public function measureDp() : void{
		//if w/h not set, measure them otu 
		if ( this._page.width == 0 || isNaN( this._page.width ) ) 
		{
		for each ( var list : IListVO in this._page.lists )
		{
		list.height = 0; 
		list.width = this.defaultWidth; 
		for each ( var le : ListEntryVO in list.entries ) 
		{
		
		//var ee : Rectangle
		//var dbg : Array = [testText.textFlow.flowComposer]
		//var rectangle:Rectangle = testText.textFlow.flowComposer.getControllerAt(0).getContentBounds();
		var o : Object = {}; 
		measureFlows.push( [le, list ] ) 
		}
		}
		}
		measureFlows_()
		}
		public function measureFlows_() : void
		{
		this.testText.addEventListener( 'measureDone', this.nextMeasure ) 
		this.currentIndex = 0; 
		this.currentLe = null; 
		this.currentList = null
		this.nextMeasure() 
		
		}
		public function allDone() : void
		{
		trace('all done'); 
		//data integrity check ...
		this.setPageSize(); 
		}
		public function nextMeasure(e:Event=null) : Boolean
		{
		
		if ( this.currentLe != null ) 
		{
		var height : Number = this.testText.getHeight(); 
		this.currentLe.height = height; 
		this.currentList.height += height; 
		var o : Object = {};
		}			
		
		if ( this.currentIndex == this.measureFlows.length ) 
		{
		this.allDone()
		return false;
		}
		
		var pair : Array = this.measureFlows[this.currentIndex] 
		var le : ListEntryVO = pair[0] as ListEntryVO; 
		var list : IListVO = pair[1] as IListVO; 
		this.currentLe = le; 
		this.currentList = list			
		this.currentIndex ++;
		import flash.utils.setTimeout; 
		//setTimeout( this.setNextOne, 2000, le.contents )
		this.setNextOne( le.contents )
		//this.testText.text = le.contents;
		//this.testText.setWidth( 350 ) 				 
		return true ; 
		}
		
		public function setNextOne( s : String ) : void
		{
		this.testText.text =s;
		this.testText.setWidth( this.defaultWidth ) 				
		}
		
		public var currentIndex : int = 0 ; 
		public var currentLe : ListEntryVO
		public var currentList : IListVO
		
		
		
		private var measureFlows : Array = []; 
		*/
		/**
		 * get the size of the page ... based on max width 
		 * */
		public function setPageSize() : void
		{
			/**
			 * If no lists to display, hide scrollbars 
			 * */
			if ( this.page.lists.length == 0 )
			{
				this.groupBg.width = this.scroller.width-20
				this.groupBg.height = this.scroller.height-20
				return; 
			}
			var result : Array = this.goThrough(  this.listVOs(), this.tr, true )
			var list : IListVO = result[0] as IListVO
			this._page.width = list.x + list.width; 	
			//this._page.width = list.x + defaultWidth; 
			result = this.goThrough( this.listVOs(), this.bl, true )
			list = result[0] as IListVO			
			this._page.height = list.y + list.height; 
			if ( debug) 
				trace('setPageSize', this._page.width, this.page.height )
			this.groupBg.width = this._page.width
			this.groupBg.height = this.page.height
			//this.group.setContentSize( this._page.width, this.page.height ) ;
			if ( this.targetXs > 0 )
			{
				if ( this.group.contentWidth > this.targetYs )
				{
					this.scroller.horizontalScrollBar.value = this.targetYs
					this.targetXs = -1 ;
				}				
			}
			if ( this.targetYs > 0 ) 
			{
				if ( this.group.contentHeight > this.targetYs )
				{
					this.scroller.verticalScrollBar.value = this.targetYs
					this.targetYs = -1 ;
				}
			}
			
			return; 
		}
		
		public function goThrough( items : Array, fxValue : Function, returnMax : Boolean = true ) : Array
		{
			var cleaned : Array = [] 
			for each ( var item : Object in items ) 
			{
				var o : Object = {}
				o.item = item
				o.value = fxValue(item ) 
				cleaned.push( o ) 
			}
			cleaned.sortOn("value", Array.NUMERIC);
			
			if ( returnMax ) 
			{
				return [cleaned[cleaned.length-1].item]
			}
			//make dictionary 
			//sort dictionary ? 
			//why write this?
			return [];
		}
		
		public function br ( o : Object ) : Number
		{
			return o.x+o.height; 
		}
		public function tr ( o : Object ) : Number
		{
			return o.x+o.width; 
		}
		public function bl ( o : Object ) : Number
		{
			return o.y+o.height; 
		}		
		
		public function set updateScrollV ( n : Number ) : void
		{
			this._page.scrollY = n; 
			var clipped : Array = this.getVisibleLists ( this.scrollBox() ) ;
			this.displayClippedLists( clipped ) ; 
		}
		public function set updateScrollH ( n : Number ) : void
		{
			this._page.scrollX = n; 
			var clipped : Array = this.getVisibleLists ( this.scrollBox() ) ;
			this.displayClippedLists( clipped ) ; 
		}		
		public function displayDp(deep:Boolean=false) : void
		{
			if ( this._page == null ) 
			{
				trace('Viewer3', 'displayDp', 'page null, not setting'); 
				return;
			}
			/**
			 * who is in viewing area
			 * creat lists and place in data
			 * wait for scroll and do again 
			 * 
			 * */
			
			/*
			get
			
			*/
			//clip db
			var clipped : Array = []; var clipped2 : Array = []; 
			/**
			 * There is a bug, both x and y must be inside box, not just one or the other
			 * 
			 * */
			var box : Rectangle = this.scrollBox()
			clipped = this.getVisibleLists ( this.scrollBox() ) ; 
			//now get exactly items to be shown
			//idea: programming langauge that turns pseudo code into code? like hug emacro 
			//bg: what is amcro, what other language like this 
			/*
			trace( 'for box', box.x, box.y, box.height, box.width ) ; 
			for each ( var list : IListVO in clipped ) 
			{
			list.clipped = this.clipListForArea( list, box ) 
			if ( list.clipped.length == 0 ) 
			{
			trace('clciped length 0', list.x, list.y, list.height, list.width ) 
			continue; 
			}
			clipped2.push(list); 
			}
			*/
			if ( deep ) 
				this.lister_clearCache(); 
			this.displayClippedLists( clipped ) 
		}
		
		public function set resizeAllListers( e : Number ) : void
		{
			return;//
			//update all the listers to teh right size 
			for each ( var lister : IListable in this.listers ) 
			{
				lister.height = e; // = false; 
			}			
		}
		
		public var listers : Array 
		public var currentlyDisplayedLists : ArrayCollection = new ArrayCollection(); 
		/**
		 * Loads lists that are visible into listers
		 * ensures the list widh is synced iwth listContent
		 * scrolls lister to proper position 
		 * */
		public function displayClippedLists(clipped : Array) : void
		{
			/*if ( clipped.length > 4 )
			{
			trace('displayClippedLists', 'length greater than 4'); 
			}*/
			var nolongerUsedLists : ArrayCollection = new ArrayCollection( this.currentlyDisplayedLists.source ) ; 
			var usedListers : Array = this.getUsedListers(clipped); 
			this.hideListers()
			if ( isNaN( this._page.width ) || isNaN( this._page.height ) )
			{
				trace('displayClippedLists', 'page is invalid size', 'resizing')
				this.setPageSize()
			}
			if ( clipped.length > this.listers.length )
			{
				trace('displayClippedLists', 'Warning', 'not enough listers to cover this page'); 
			}
			var usedDps : Array = []; 
			//this is a disaster for dragging yes? 
			for each ( var list : IListVO in clipped ) 
			{
				usedDps.push(list.data)
				var name : String = list.name; 
				
				var reused : Boolean = false
				//ifa lready showing, omve it somewhere
				if ( list.loadedIntoLister != null )
				{
					lister = list.loadedIntoLister as IListable
					//fix for dragging only 
					//wtf is that?
					/*	if ( lister.lister.dataProvider != null && lister.lister.dataProvider.length != list.entries.length )
					{
					lister.newDp = list.entries 
					timer_MakeSureContentHeightSet.start()
					}
					//make sure setting get refrehsed
					//try other things ...
					if ( lister.lister.dataProvider != list.entries )
					{
					lister.newDp = list.entries 
					timer_MakeSureContentHeightSet.start()
					}					
					*/
					lister.goActive(); 
					reused = true
				}
				else
				{
					var lister : IListable = this.getNextLister(usedListers, clipped); 
					//var firstLe : ListEntryVO = list.clipped[0] as ListEntryVO;
					//find list for lister and remove it 
					var listLoadedInLister : IListVO = lister.listData
					if (listLoadedInLister != null && listLoadedInLister.loadedIntoLister != null ) 
					{
						listLoadedInLister.loadedIntoLister = null; 
					}
					lister.data = list.data
					timer_MakeSureContentHeightSet.start()
					lister.goActive(); 
				}
				list.loadedIntoLister = lister; 
				var dbg : Object = [list.loadedIntoLister.height, list.loadedIntoLister.width]
				lister.listData = list; 
				lister.visible = true; 
				
				lister.x = list.x; 
				lister.y = list.y; 
				//perhaps add the dp here? and simply add or remove them back at they are exposed? 
			}			
			
			listers_RemoveOldDp( usedDps ); 
			
		}
		
		private function getUsedListers(clipped:Array):Array
		{
			var used : Array = []
			for each ( var list : IListVO in this.listVOs() ) 
			{
				if (clipped.indexOf( list ) != -1 && list.loadedIntoLister != null ) 
					used.push( list.loadedIntoLister ) ; 
			}
			return used;
		}
		
		public function scrollTarget( x_s : Number, y_s : Number) : void
		{
			this.targetXs = x_s
			this.targetYs =y_s
		}
		
		private var currentListerIndex : int = 0 ; 
		private var targetXs:Number=-1;
		private var targetYs:Number=-1;
		/*
		will auto set x and y to 0 if NaN, 
		probably what you want, don't see why you woldntw ant ti 
		*/
		private var setUninitXYTo0:Boolean=true;
		
		public function setup(class_ : Class, testList : IListable, workspace : Group, bg : Group, scroller : Scroller ) : void
		{
			this.classForListers = class_
			this.listsMeasure = testList
			this.group = workspace; 
			this.groupBg = bg
			this.scroller = scroller; 
		}
		/**
		 * Tries to grab a lister that is not being used
		 * needs routine to not pick up arleady placed lists or continual loop may result 
		 * 
		 * */
		public function getNextLister(usedListers : Array,clipped:Array) : IListable
		{
			if ( usedListers.length == this.listers.length ) 
			{
				trace('getNextLister', ' no more listers left' ) 
				//return any lister
				this.currentListerIndex++;
				if ( this.currentListerIndex == this.listers.length )
					this.currentListerIndex = 0 ; 
				
				var lister : IListable = this.listers[this.currentListerIndex] 
				//perhaps just return null 
				return lister as IListable;
			}
			
			//gothrouch all listers and first one that is not being used, return it 
			for each ( lister in this.listers ) 
			{
				if ( usedListers.indexOf( lister ) != -1 )
					continue 
				//if it has a list loaded (that strangely has not be cleared)
				//we prefer a clean one 
				if ( lister.listData != null && lister.listData.loadedIntoLister != null &&
					clipped.indexOf(lister.listData) != -1 )
					continue ;
				return lister as IListable;
			}			
			
			return null; 
		}
		public function hideListers() : void
		{
			for each ( var lister : IListable in this.listers ) 
			{
				//clear data ...
				lister.visible = false; 
				lister.goHidden(); 
				var o : Object = lister 
				if ( o.parent == null ) 
					throw 'lister was removed from stage'
				//this.addEventListener(Event.REMOVED, this.onRemoved ), but too many events
			}
		}		
		/**
		 * Force remeasuring of lists 
		 * sets all list cached lister values to null 
		 *
		 * do this when underlying dp is changed 
		 * */
		public function lister_clearCache() : void
		{
			for each ( var list : IListVO in this.listVOs() )
			{
				list.loadedIntoLister = null; 
			}
		}				
		
		/**
		 * fix does not work 
		 * */
		public function listers_RemoveOldDp( usedDps : Array) : void
		{
			return;
			for each ( var lister : IListable in this.listers ) 
			{
				if ( lister.lister.dataProvider == null ) 
				{
					continue; 
				}
				if ( lister.visible == false)
				{
					var found : Boolean = usedDps.indexOf( lister.lister.dataProvider) != -1 
					var notFound : Boolean = ! found ; 
					if ( found ) 
						lister.lister.dataProvider = null
					//lister.lister.dataProvider = null
				}
				
			}
		}				 
		
		/**
		 * set the first listentryvo to match they initial y of list 
		 * go through and test if it is in the box 
		 * */
		/*public function clipListForArea( list : IListVO , box : Rectangle ) : Array
		{
		var totalY : Number = list.y; 
		
		var clipped : Array = []
		for each ( var le : ListEntryVO in list.entries ) 
		{
		le.y = totalY
		totalY+= le.height; 
		if ( startsInBox( le, box, 'y' ) ) 
		{
		clipped.push( le ) 
		continue; 
		}
		if ( endsInBox( le, box, 'y' ) ) 
		{
		clipped.push( le ) 
		continue; 					
		}	
		
		}
		return clipped
		}
		*/
		public function startsInBox( list : Object , box : Rectangle, direction : String = 'x' ) : Boolean
		{
			if ( direction == 'x' ) 
			{
				if ( list.x >= box.left && list.x <= box.right )
				{
					return true 
				}
			}
			else
			{
				if ( list.y >= box.top && list.y <= box.bottom )
				{
					return true
				}
			}
			return false; 
		}		
		
		public function startsBeforeBox( list : Object , box : Rectangle, direction : String = 'x' ) : Boolean
		{
			if ( direction == 'x' ) 
			{
				if ( list.x < box.left )
				{
					return true 
				}
			}
			else
			{
				if ( list.y < box.top )
				{
					return true
				}
			}
			return false; 
		}
		
		
		public function endsInBox( list : Object , box : Rectangle, direction : String = 'x' ) : Boolean
		{
			if ( direction == 'x' ) 
			{
				if ( list.x+list.width >= box.left && list.x+list.width <= box.right ) 
				{
					return true 
				}
			}
			else
			{
				if ( list.y+list.height >= box.top && list.y+list.height <= box.bottom )
				{
					return true
				}
			}
			return false; 
		}		
		public function endsOutsideBox( list : Object , box : Rectangle, direction : String = 'x' ) : Boolean
		{
			if ( direction == 'x' ) 
			{
				if ( list.x+list.width >= box.right)// && list.x+list.width <= box.right ) 
				{
					return true 
				}
			}
			else
			{
				if ( list.y+list.height >= box.bottom ) // && list.y+list.height <= box.bottom )
				{
					return true
				}
			}
			return false; 
		}				
		
		public function largerThanBox( list : Object , box : Rectangle, direction : String = 'x' ) : Boolean
		{
			if ( direction == 'x' ) 
			{
				if ( list.x <= box.left && list.x+list.width >= box.right ) 
				{
					return true 
				}
			}
			else
			{
				if ( list.y <= box.top && list.y+list.height >= box.bottom )
				{
					return true
				}
			}
			return false; 
		}
		
		public function getVisibleLists( box : Rectangle ) : Array 
		{
			var clipped : Array = []
			if ( debug) 
				trace('getVisibleLists', 'box', box.x, box.y, box.height, box.width ) 
			
			for each ( var list : IListVO in this.listVOs() )
			{
				if ( this.setUninitXYTo0 ) 
				{
					if ( isNaN( list.x ) ) list.x = 0 
					if ( isNaN( list.y ) ) list.y = 0 
				}
				var pad : Number = 100; 
				//warn about invalid dimensions
				if ( list.width == 0 || list.height == 0 || isNaN(list.width ) || isNaN( list.height ) )
				{
					trace('WARNING::','getVisibleLists', 'invalid dimensions')
					//if this is in a lister, try to grab the content height 
					//if it isn't set will cause a problem ... but isn't this the wrong place? 
					//yes , it is, perhaps when the content height is changed (adjustlisterheight) we should update the attached 
					//list as well ..
					if ( list.loadedIntoLister != null )
					{
						//conditions only happen in testing, essentially display is not ready 
						if ( list.loadedIntoLister.creationComplete == false ) // == null )
						{
							trace('WARNING::', 'testing yes?')
							return [];
						}
						/*var dbg : Array =[ list.loadedIntoLister.enabled, list.loadedIntoLister.lister.enabled, list.loadedIntoLister.parent, 
						list.loadedIntoLister.parentDocument] 
						list.height = list.loadedIntoLister.lister.dataGroup.contentHeight
						if ( list.height < 20 ) 
						list.height = 20; 
						list.width = list.loadedIntoLister.lister.dataGroup.contentWidth			
						if ( list.width < 20 ) 
						list.width = 200; 		*/					
					}
				}
				var xInRange : Boolean = ( startsInBox( list, box, 'x' ) || endsInBox( list, box, 'x' ) ) 
				var yInRange : Boolean = ( startsInBox( list, box, 'y' ) || endsInBox( list, box, 'y' ) ) 					
				//if starts above or in the box, but ends in or below the box 
				if (	 startsBeforeBox( list, box, 'y' ) && 
					( endsInBox( list, box, 'y' ) || endsOutsideBox( list, box, 'y' ) )
				) 		
				{
					yInRange = true;
				} 
				//handle case where X is before clippedArea, and width is outside clipped area
				if (	 startsBeforeBox( list, box, 'x' ) && 
					( endsInBox( list, box, 'x' ) || endsOutsideBox( list, box, 'x' ) )
				) 		
				{
					xInRange = true;
				} 				
				if ( debug) 
					trace('getVisibleLists', list.name,"\t", list.x, list.y, list.height, list.width, '--',xInRange ,yInRange ) 
				if ( xInRange && yInRange) 
				{
					clipped.push( list ) 
					continue; 
				}
				if ( largerThanBox( list, box, 'x' ) && largerThanBox( list, box, 'y' ) ) 
				{
					clipped.push( list ) 
					continue; 					
				}						
			}			
			if ( debug) 
				trace('clipped', clipped.length ) ; 				
			return clipped
		}
		
		public function scrollBox() : Rectangle
		{
			var box : Rectangle = new Rectangle( this.group.horizontalScrollPosition, this.group.verticalScrollPosition,
				this.viewportWidth, this.viewportHeight ) ;
			return box ; 
		}
		
		public function scrollTo ( list : IListVO, o : Object ) : void
		{
			this.scrollTarget( list.x, list.y ) 
		}
		
		
	}
}