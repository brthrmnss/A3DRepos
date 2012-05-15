package   org.syncon2.utils.data
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	public class  GoThroughEachLoop
	{
		private var currentIndex:int;
		public function get index() : int { return  this.currentIndex } 
		public function set  index(i : int) :void { this.currentIndex = i } 
		private var songs: Array = []; ;
		private var fxCallAfterSoundCompletePlaying:Function;
		private var fxCallback:Function;
		private var _complete:Boolean=true;
		
		/**
		 * Elips needs these breaks, do not surpress them 
		 * */
		static public var PauseFirstAndLast : Boolean = false
		
		public function get complete():Boolean
		{
			return _complete;
		}
		
		public function set complete(value:Boolean):void
		{
			if ( value == true ) 
			{
				trace('Go Through Each', 'complete', true ) ; 
			}
			_complete = value;
		}
		
		private var timer : Timer  
		private var timeDelay:Number=0;
		public var loop:Boolean = true;
		public var reset:Object;
		public function get items () : Array
		{
			return this.songs.concat(); 
		}
		public function get itemsSource () : Array
		{
			return this.songs;//.concat(); 
		}
		public function set itemsSource ( d : Array ) :void
		{
			this.songs = d
		}
		public function go( arr : Array, fxCallback:Function, fxComplete : Function, timeDelay_ : Number = 0, startNow : Boolean = true    ) : void
		{
			this.complete = false; 
			this.songs = arr; 
			this.fxCallAfterSoundCompletePlaying = fxComplete
			this.fxCallback = fxCallback; 
			this.currentIndex = -1
			
			this.timeDelay = timeDelay_
			
			if ( startNow = false ) 
				return
			
			if ( timeDelay > 0 ) 
			{
				if ( timer != null ) 
					timer.removeEventListener(TimerEvent.TIMER, this.nextTimerComplete ) 
				timer = new Timer(timeDelay,1 )
				timer.addEventListener(TimerEvent.TIMER, this.nextTimerComplete ) 
			}
			
			
			this.nextSound(null, true); //dstart instantly 		
		}
		
		/**
		 * timed lets us star wright away ... but use current index instead ...
		 * */
		private function nextSound(e:Object=null, timed : Boolean = false) : void
		{
			if ( this.currentIndex != -1 && ( this.currentIndex != this.songs.length ) ||  PauseFirstAndLast ) 
			{
				if ( this.songs.length != 0 ) 
				{
					if ( timeDelay != 0 && timed == false  ) 
					{
						this.timer.reset(); 
						this.timer.start();
						return; 
					}
				}
			}
			if ( this.complete ) 
				return; 
			this.currentIndex ++
			if ( this.currentIndex >=  this.songs.length ) 
			{
				if ( this.loop ) 
				{
					this.currentIndex = 0
				}
				else
				{
					this.end(); 
					return;
				}
				
				
			}
			fxCallback(this.songs[this.currentIndex]  ); 
		}
		public function nextTimerComplete(e:TimerEvent) : void
		{
			timer.stop(); 
			this.nextSound(null, true ); 
		}
		
		/***
		 * recieve a parameter just in case return fx send data
		 * */
		public function next(o:Object=null) : void
		{
			this.nextSound(null); 
		}
		
		/**
		 * Terminate looping early , make sure no further indexes can be called
		 * */
		public function end(callFinalFx : Boolean = true ) : void
		{
			if ( this.timer != null ) 	this.timer.stop() ; 
			this.complete = true;  //call complete first so we do not interfere wtih starting again ...
			this.songs = [] ; // 
			
			var fxFinal : Function = fxCallAfterSoundCompletePlaying
			fxCallAfterSoundCompletePlaying = null
			
			//call final fx last to prevent anything that has restarted the loop and reused 
			//this instance from losign variables ...
			if ( callFinalFx )
			{
				if (  fxFinal != null ) 
					fxFinal();
			}
			
			
		}
		
		
		/**
		 * This is a non-moving mode, acts like an array where i can keep asking for the 'nextItem'
		 * */
		public function load( arr : Array  ) : void
		{
			this.complete = false; 
			this.songs = arr; 
			this.currentIndex = -1
		}
		
		public function currentItem() :  Object
		{
			return this.songs[currentIndex] 
		}
		
		public function nextItem(advance  : Boolean = true) :  Object
		{
			var nextIndex : int =  this.currentIndex; 
			nextIndex ++
			if (nextIndex >=  this.songs.length ) 
			{
				
				nextIndex = 0
				
			}
			if ( advance ) 
				this.currentIndex = nextIndex;
			return this.songs[nextIndex] 
		}
		
		public function prevItem(changeIndex  : Boolean = true) :  Object
		{
			var prevIndex : int =  this.currentIndex; 
			prevIndex --
			if (prevIndex <  0 ) 
			{
				
				prevIndex = this.songs.length-1
				
			}
			if ( changeIndex ) 
				this.currentIndex = prevIndex;
			return this.songs[prevIndex] 
		}
		
		public function getItem(offset:int, advance  : Boolean = false) :  Object
		{
			var index : int = this.currentIndex; // = offset
			var diff : int = Math.abs( offset ) //ensure loop occurs x times, even if negative number
			var direction : int = 1; 
			if ( offset < 0   )
			{
				direction = -1 
			}
			for ( var i : int =  0 ; i < diff; i++) 
			{
				index += direction
				if (index >=  this.songs.length ) 
				{
					index = 0
				}
				if (index <  0 ) 
				{
					index = this.songs.length-1
				}
			}
			if ( advance ) 
				this.currentIndex = index;
			return this.songs[index] 
		}
		
		public function last( ) :  Object
		{
			var index : int    = this.songs.length-1
			
			return this.songs[index] 
		}
		public function atEnd( ) :  Boolean
		{
			if ( this.index  == this.songs.length-1 ) 
				return true; 
			
			return false
		}
		
	}
}