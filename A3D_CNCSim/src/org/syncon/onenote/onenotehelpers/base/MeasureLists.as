package org.syncon.onenote.onenotehelpers.base   
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.container.ContainerController;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.events.PropertyChangeEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.Group;
	import spark.components.RichText;
	import spark.components.Scroller;
	import spark.components.supportClasses.GroupBase;
	import spark.primitives.Rect;
	
	
	
	/**
	 * Measures all the items sent it, by setting their data and waiting for a resize to be dispatched
	 * this is don't b/ec soizes might be invalidaded, thsi wya w ecan measure teh entire 
	 * page, (or collection of items ) ;  
	 * @author user3
	 * 
	 */
	public class MeasureLists //extends GroupBase
	{
		public var currentIndex : int = 0 ; 
		public var currentList :  IListVO
		
		private var measureFlows : Array = []; 
		public var _measuringTool : IListable; 
		
		
		public var fxDone : Function; 
		public var listsToMeasure : Array; 
		public var measuredLists : Array ; 
		//http://www.oscar-mejia.com/blog/post/tlf-resiable-textflow-container
		public var defaultWidth: Number = 350;
		
		
		/**
		 * Sometimes measuring will fail, this will auto restart it 
		 * 
		 * */
		public var timer_CompletionFault : Timer = new Timer(10000,1); 
		private var debug:Boolean=true;
		/**
		 * Next Measure will wait before sending in next requests
		 * This will prevent memory errors when loading many fixed width and height 
		 * items. 
		 * */
		private var breakUpMeasureRequests:Boolean=true;
		
		
		public function MeasureLists() 
		{
			timer_CompletionFault.addEventListener(TimerEvent.TIMER, this.onFault ) ; 
		}
		
		public function set measuringTool( s :   IListable ) : void
		{
			this._measuringTool = s; 
			_measuringTool.addEventListener(ResizeEvent.RESIZE, this.nextMeasure ) ; 
		}

		public function measureLists( a : Array, fxDone : Function ) : void
		{
			trace('MeasureLists', 'start measure'); 
			var measure : Boolean = false; 
			for each ( var list :  IListVO in a ) 
			{
				if (  isNaN(list.x) || isNaN(list.y) || isNaN(list.width) || isNaN(list.height) ) 
				{
					measure = true ; 
				}
				
			}
			if ( measure == false ) 
			{
				trace('skipping measure'); 
			}
			this.fxDone = fxDone; 
			this.listsToMeasure = a
			if ( this.listsToMeasure.length == 0 )
			{
				this.allDone(); 
				return; 
			}
			this.measureDp()
			this.timer_CompletionFault.start()
		}
		public function onDone() : void
		{
			this.fxDone( measuredLists ) 
		}
		public function onFault(e:Event):void
		{
			//var dbg : Array = [ this.currentIndex, this._measuringTool.lister.dataGroup.contentHeight, 
			//	this.listsToMeasure[this.currentIndex] ] 
			var dbg : Array = [ this.currentList, this._measuringTool,
				this.listsToMeasure, this.listsToMeasure.length]
			trace('MeasureLists', 'failed to measure', this.currentIndex +1, this.currentList.name   )
			//	this.measureDp()
		}
		
		/**
		 * Start measuring
		 * */
		public function measureDp() : void
		{
			this.currentIndex = 0; 
			this.currentList = null
			this.nextMeasure()  
			//_measuringTool.lister.dataGroup.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.nextMeasure);
		}
		public function allDone() : void
		{
			this.timer_CompletionFault.stop(); 
			trace('MeasureLists', 'all done'); 
			//this is so important, otherwise it will bind of loaded data ...
			//cause all sorts of issues 
			this._measuringTool.data = null; 
			//data integrity check ...
			this.onDone();
		}
		public function nextMeasure(e:  Event=null, wait : Boolean = true) :   void
		{
			//stacks can get deep, at which point items fall from memory
			if ( wait && breakUpMeasureRequests ) 
			{
				this._measuringTool['callLater'](this.nextMeasure, [e, false] )
				return;
			}
			trace('MeasureLists', 'nextMeasure', this.currentIndex); 
			//if result 
			if ( e  != null && this.currentList != null  ) 
			{
				/*if (e.source == e.target && e.property == "contentHeight")
				{
				//ok
				}
				else
				{
				return; 
				}		*/
				//check for current target? 
				if ( this._measuringTool.resetting ) 
					return; 
				this.currentList.height =this._measuringTool.height; 
				this.currentList.width = this._measuringTool.width; 
			}			
			
			if ( debug ) 
				trace('MeasureLists', 'nextMeasure','compare',
					this.currentIndex == this.listsToMeasure.length,
					this.currentIndex , this.listsToMeasure.length); 
			//last one
			if ( this.currentIndex == this.listsToMeasure.length -1 ) 
			{
				trace('MeasureLists', 'finsihed measuring'); 
				_measuringTool.removeEventListener( ResizeEvent.RESIZE, this.nextMeasure);
				this._measuringTool.data = null
				this.allDone()
				return ;
			}
			//not the last one 
			var list :  IListVO  = this.listsToMeasure[this.currentIndex] 
			this.currentList = list			
			this.currentIndex ++;
			this._measuringTool.goActive()
			this._measuringTool.data = list.data
			
			//this.setNextOne( list.entries  )
		}
		
		
	}
}