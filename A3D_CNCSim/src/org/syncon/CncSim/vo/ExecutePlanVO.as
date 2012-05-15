package  org.syncon.CncSim.vo
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Plan runner .. not a VO
	 * bundles functionality off the model 
	 * */
	public class ExecutePlanVO 
	{
		/*
		public var name : String = ''; 
		public var description : String = ''; 
		*/
		static public const UPDATED : String = 'update.ExecutePlanVO'; 
		
		static public const PLAYING : String = 'update.PLAYING'; 
		static public const PAUSED : String = 'update.PAUSED'; 
		static public const STOPPED : String = 'update.STOPPED'; 
		
		private var currentIndex : int = 0  ; 
		private var _currentState:String='';
		public var fxStateChanged:Function;
		public var fxProcessBehavior:Function;

		/**
		 * I can guess you'll have all the settings under the ohod stored here
		 * have to adjust the percentage speed like in mach3 
		 * trigger verifies? 
		 * */
		public var speedRatio : Number = 0 ; 
		public var gapBetweenSteps : Number = 0 
		public var plan:PlanVO;
		
		private function get currentState():String
		{
			return _currentState;
		}

		private function set currentState(value:String):void
		{
			_currentState = value;
			if ( fxStateChanged != null ) 
				this.fxStateChanged( value ) ; 
		}

		
		public function isPlaying():Boolean
		{
			return this.currentState == PLAYING
		}
		public function isPaused():Boolean
		{
			return this.currentState == PAUSED
		}
		public function isStopped():Boolean
		{
			if ( this.currentState == '' ) 
			{
				return true; 
			}
			return this.currentState == STOPPED
		}
		
		public function play(startAt : int = 0 ):void
		{
			this.currentIndex = startAt-1; 
			this.goToNextLine(); 
			this.currentState = PLAYING 
		}
		
		private function goToNextLine():void
		{
			this.currentIndex++; 
			if ( this.currentIndex >= this.plan.behaviors.length ) 
			{
				this.end();
				return; 
			}
			var item : Object = this.plan.behaviors.getItemAt( this.currentIndex ) ; 
			var behavior : BehaviorVO  = item as BehaviorVO
			if ( behavior != null ) 
				this.doBehavior( behavior )
			else
				this.end(); 
		}
		
		private function doBehavior(behavior:BehaviorVO):void
		{
			// TODO Auto Generated method stub
			if ( this.fxProcessBehavior != null ) 
				this.fxProcessBehavior( behavior ) ; 
		}
		
		private function end():void
		{
			this.currentState = STOPPED 
		}
/*		
		public var  dispatchEvent : Function ; 
		
		public function fxProcessBehavior( b  : BehaviorVO ) : void{
			this.dispatchEvent() 
		}
		
		public function fxStateChanged( s : String ) : void{
			this.dispatchEvent( new 
		}*/
		public function goToNextOne() : void
		{
			this.goToNextLine(); 
		}
	}
}