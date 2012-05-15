package   org.syncon2.utils.data
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	public class  GoThroughEach 
	{
		private var currentIndex:int;
		public function get index() : int { return  this.currentIndex } 
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
		public function go( arr : Array, fxCallback:Function, fxComplete : Function, timeDelay_ : Number = 0    ) : void
		{
			this.complete = false; 
			this.songs = arr; 
			this.fxCallAfterSoundCompletePlaying = fxComplete
			this.fxCallback = fxCallback; 
			this.currentIndex = -1
			
			this.timeDelay = timeDelay_
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
				this.end(); 
				return;
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
		
		public function insertNext( o : Object ) : void
		{
			this.songs.splice( this.currentIndex+1, 0, o ) ; 
		}
		
		public function goBackOne() : void
		{
			if ( this.currentIndex > 0 ) 
			{
				this.currentIndex--; 
				this.currentIndex--; 
			}
			 this.next(); 
		}
	}
}