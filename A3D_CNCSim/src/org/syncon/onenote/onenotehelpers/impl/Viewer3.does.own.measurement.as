package   
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.container.ContainerController;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	
	import spark.components.Group;
	import spark.components.RichText;
	import spark.components.Scroller;
	import spark.components.supportClasses.GroupBase;
	import spark.primitives.Rect;
	
	
	
	public class Viefwer3.does //extends GroupBase
	{
		//http://www.oscar-mejia.com/blog/post/tlf-resiable-textflow-container
		public var testText  :    TLFContainer
		public var defaultWidth: Number = 350;
		public var group : Group; 
		public var _scroller : Scroller;
		public function set scroller ( s : Scroller ) : void
		{
			this._scroller = s; 
			//this.newHeight ;
		}
		public function get  scroller ( ) : Scroller  
		{
			return this._scroller
		}		
		
		public var scrollMode : Boolean = true; 
		public function get viewportHeight() :  Number
		{
			return this.scroller.height; 
		}
		public function get viewportWidth() :  Number
		{
			return this.scroller.width; 
		}		
		private function get page() : PageVO
		{
			return this._page; 
		}
		private var _page  : PageVO; 
		private var _childrenCreated : Boolean = false; 
		public function set dataProvider( d : PageVO ) : void
		{
			_page = d; 	
			if ( this._childrenCreated == false ) 
			{
				this._childrenCreated = true; 
				this.createChildren()
			}			
			this.measureDp()

			this.displayDp(); 
		}
		
		  protected function   createChildren():void
		{
			this.listers = []; 
			for ( var i : int = 0 ; i < 10 ; i++ )
			{
				var lister : lister2 = new lister2(); 
				lister.scrollMode = this.scrollMode; 
				this.group.addElement( lister )
				this.listers.push( lister )  ; 
			}
			this.newHeight = this.scroller.height; 
		}
		
		public function measureDp() : void{
			//if w/h not set, measure them otu 
			if ( this._page.width == 0 || isNaN( this._page.width ) ) 
			{
				for each ( var list : ListVO in this._page.lists )
				{
					list.height = 0; 
					list.width = this.defaultWidth; 
					for each ( var le : ListEntryVO in list.entries ) 
					{
						/*	this.testText.text = le.contents;
						this.testText.invalidateDisplayList()
						this.testText.invalidateSize()							
						trace('what is height', this.testText.measuredHeight )*/
						//var ee :  Rectangle
						//var dbg : Array = [testText.textFlow.flowComposer]
						//var rectangle:Rectangle = testText.textFlow.flowComposer.getControllerAt(0).getContentBounds();
						var o : Object = {}; 
						measureFlows.push( [le, list ] ) 
					}
				}
			}
			measureFlows_()
		}
		public function measureFlows_()  : void
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
		public function nextMeasure(e:Event=null) :  Boolean
		{
			
			if ( this.currentLe != null ) 
			{
				var height :   Number = this.testText.getHeight(); 
				this.currentLe.height = height; 
				this.currentList.height += height; 
				var o : Object = {};
			}			
			
			if ( this.currentIndex == this.measureFlows.length  ) 
			{
				this.allDone()
				return false;
			}
			
			var pair : Array   = this.measureFlows[this.currentIndex] 
			var le : ListEntryVO = pair[0] as ListEntryVO; 
			var list : ListVO = pair[1] as ListVO; 
			this.currentLe = le; 
			this.currentList = list			
			this.currentIndex ++;
			import flash.utils.setTimeout; 
			//setTimeout( this.setNextOne, 2000,  le.contents )
			this.setNextOne( le.contents )
			/*
			this.testText.text = le.contents;
			this.testText.setWidth( 350 ) 				 
			*/
			return true ; 
		}
		
		public function setNextOne( s : String ) : void
		{
			this.testText.text =s;
			this.testText.setWidth( this.defaultWidth ) 				
		}
		
		public var currentIndex : int = 0 ; 
		public var currentLe : ListEntryVO
		public var currentList : ListVO
		
		
		
		private var measureFlows : Array = []; 
		
		/**
		 * get the size of the page ... based on max width 
		 * */
		public function setPageSize()  : void
		{
			var result : Array = this.goThrough( this._page.lists.toArray(), this.tr, true )
			var list : ListVO = result[0] as ListVO
			this._page.width = list.x + list.width; 	
			this._page.width = list.x + defaultWidth; 
			result    = this.goThrough( this._page.lists.toArray(), this.bl, true )
			list  = result[0] as ListVO			
			this._page.height = list.y + list.height; 
			
			this.group.setContentSize( this._page.width, this.page.height ) ; 
			return; 
		}
		
		public function goThrough( items : Array, fxValue : Function, returnMax : Boolean = true ) : Array
		{
			var cleaned : Array = [] 
			for each ( var item  : Object in items ) 
			{
				var o :  Object = {}
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
			return  [];
		}
		
		public function br ( o :  Object ) :   Number
		{
			return o.x+o.height; 
		}
		public function tr ( o :  Object ) :   Number
		{
			return o.x+o.width; 
		}
		public function bl ( o :  Object ) :   Number
		{
			return o.y+o.height; 
		}		
		
		public function set updateScrollV ( n : Number ) : void
		{
			/**
			 * Horionztal scroll
			 * */
			//visibleLists
			/*for each ( var list : lister2 in this.visibleLists ) 
			{
				var maxVerticalScrollPosition : Number = list.dataGroup.contentHeight - list.dataGroup.height;
				if ( list.scrollLayout.verticalScrollPosition == maxVerticalScrollPosition )
					continue
				var newY : Number = n ;
				var setToPosition = n - list.y
			}*/
			var clipped :  Array = this.getVisibleLists ( this.scrollBox() ) ;
			this.displayClippedLists( clipped  ) ; 
		}
		public function displayDp() : void
		{
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
			var box   : Rectangle = this.scrollBox()
			clipped = this.getVisibleLists (  this.scrollBox() ) ; 
			//now get exactly items to be shown
			//idea: programming langauge that turns pseudo code into code? like hug emacro 
			//bg: what is amcro, what other language like this 
			
			trace( 'for box', box.x, box.y, box.height, box.width ) ; 
			for each ( var list : ListVO in clipped ) 
			{
				list.clipped = this.clipListForArea( list, box ) 
				if ( list.clipped.length == 0 ) 
				{
					trace('clciped length 0', list.x, list.y, list.height, list.width ) 
					continue; 
				}
				clipped2.push(list); 
			}
			
			this.displayClippedLists( clipped2 ) 
		}
		
		public function set newHeight( e : Number ) : void
		{
			//update all the listers to teh right size 
			for each ( var lister : lister2 in this.listers ) 
			{
				lister.scrollHeight = e; //  = false; 
			}			
		}
		
		public var listers : Array 
		public var currentlyDisplayedLists : ArrayCollection = new ArrayCollection(); 
		public function displayClippedLists(clipped : Array) : void
		{
			var nolongerUsedLists : ArrayCollection = new ArrayCollection( this.currentlyDisplayedLists.source ) ; 
			this.hideListers()
			//this is a disaster for dragging yes? 
			for each ( var  list : ListVO  in clipped ) 
			{
				if ( list.clipped.length == 0 )
				{
					trace('warning','displayClippedLists',  'clipped length 0' ) ; 
					continue;
				}
				//ifa lready showing, omve it somewhere
				if ( list.loadedIntoLister != null )
				{
					 lister =  list.loadedIntoLister  as lister2
				}
				else
				{
					var lister : lister2 = this.getNextLister(); 
					var firstLe : ListEntryVO  = list.clipped[0] as ListEntryVO;
					lister.dp = list.entries.toArray(); 
				}
				//lister.loadedList = list; 
				list.loadedIntoLister = lister; 
				lister.visible = true; 
				if ( this.scrollMode ) 
				{
					/* i believe that did the trick
					//i think it's if x start or ends in the area, and y y starts or ends in area 
					// or x and y start and end out side of area */
					
					//if y i sless than  top of view area ... move to 0, 
					//if data group is larger than view area, 
					if ( list.y >=  this.scrollBox().y ) 
					{
					lister.y = list.y; 
					lister.x = list.x; 
					//lister.scrollPosition = firstLe.height; 
					}
					else
					{
						lister.y = this.scrollBox().y
					}
				}
				else //position by first visible clipped entry 
				{
					lister.dp = list.clipped;// = this.clipListForArea( list, viewArea ) 
					lister.y = firstLe.y; 
					lister.x = list.x; 
				}
				
				//perhaps add the dp here? and simply add or remove them back at they are exposed? 
			}			
		}
		private var currentListerIndex : int  = 0 ; 
		public function getNextLister() : lister2
		{
			this.currentListerIndex++;
			if ( this.currentListerIndex == this.listers.length )
				this.currentListerIndex = 0 ; 
			
			var lister : lister2 = this.listers[this.currentListerIndex] 
			return lister as lister2;
		}
		public function hideListers() : void
		{
			for each ( var lister : lister2 in this.listers ) 
			{
				lister.visible  = false; 
			}
		}		
		
		/**
		 * set the first listentryvo to match they initial y of list 
		 * go through and test if it is in the box 
		 * */
		public function clipListForArea( list :  ListVO , box : Rectangle ) :   Array
		{
			var totalY : Number = list.y; 
			
			var clipped : Array = []
			for each ( var le : ListEntryVO in list.entries ) 
			{
				le.y = totalY
				totalY+= le.height; 
				if (   startsInBox( le, box, 'y' ) ) 
				{
					clipped.push( le ) 
					continue; 
				}
				if (   endsInBox( le, box, 'y' ) ) 
				{
					clipped.push( le ) 
					continue; 					
				}	
				
			}
			/*for each (   le  in list.entries ) 
			{
			le.y = totalY
			totalY+= le.height; 
			}	*/		
			return clipped
		}
		public function startsInBox( list : Object , box :  Rectangle, direction : String = 'x' ) :  Boolean
		{
			if ( direction == 'x' ) 
			{
				if ( list.x  >= box.left   &&    list.x <= box.right    )
				{
					return true 
				}
			}
			else
			{
				if ( list.y  >= box.top    &&    list.y <=   box.bottom   )
				{
					return true
				}
			}
			return false; 
		}
		
		
		public function endsInBox( list : Object , box :  Rectangle, direction : String = 'x' ) :  Boolean
		{
			if ( direction == 'x' ) 
			{
				if ( list.x+list.width  >= box.left   &&    list.x+list.width <= box.right  )   
				{
					return true 
				}
			}
			else
			{
				if ( list.y+list.height   >= box.top   &&    list.y+list.height <=   box.bottom   )
				{
					return true
				}
			}
			return false; 
		}		
		
		public function largerThanBox( list : Object , box :  Rectangle, direction : String = 'x' ) :  Boolean
		{
			if ( direction == 'x' ) 
			{
				if ( list.x  <= box.left   &&   list.x+list.width >= box.right  )  
				{
					return true 
				}
			}
			else
			{
				if ( list.y <= box.top   &&   list.y+list.height >=   box.bottom   )
				{
					return true
				}
			}
			return false; 
		}
		
		public function getVisibleLists( box : Rectangle ) : Array 
		{
			var clipped : Array = []
			for each ( var list : ListVO in this._page.lists )
			{
				var pad : Number = 100; 
 
				trace('clciped length 0', list.x, list.y, list.height, list.width ) 
				var xInRange : Boolean =  ( startsInBox( list, box, 'x' ) || endsInBox( list, box, 'x' ) ) 
				var yInRange : Boolean =  ( startsInBox( list, box, 'y' ) || endsInBox( list, box, 'y' ) ) 					
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
			trace('clipped', clipped.length ) ; 				
			return clipped
		}
		
		public function scrollBox() : Rectangle
		{
			var box : Rectangle = new  Rectangle( this.group.horizontalScrollPosition, this.group.verticalScrollPosition,
				this.viewportWidth, this.viewportHeight ) ;
			return box ; 
		}
		
	}
}