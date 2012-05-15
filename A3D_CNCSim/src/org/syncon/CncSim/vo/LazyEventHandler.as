package  org.syncon.CncSim.vo
{
	import flash.utils.Dictionary;
	
	
	/**
	 * */
	public class LazyEventHandler 
	{
		public var target : Object; 
		public function init( tar : Object ) : void
		{
			this.target = tar; 
		}
		private var events :  Dictionary = new Dictionary(true);  
		public function addEv(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true  ): void
		{
			var fx : Function = events[type] 
			if ( fx != null  ) 
			{
				return; 
			}
			events[type]  = listener; 
			target.addEventListener(type, listener, useCapture,priority, useWeakReference ) ; 
		}
		/***
		 * supposed the capture thing ... by storing it on dictionary 
		 * */
		public function unmapAll() : void{
			for ( var k : Object in this.events ) 
			{
				var fxListener : Function = this.events[k]; 
				target.removeEventListener( k, fxListener); //, useCapture,priority, useWeakReference ) ; 
				delete this.events[k]
			}
			this.events = null; 
			this.target = null; 
		}
		
		
		
		
	}
}