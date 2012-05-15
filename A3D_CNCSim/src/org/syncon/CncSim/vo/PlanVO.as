package  org.syncon.CncSim.vo
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * contains multiple nested behaviors 
	 * */
	public class PlanVO  extends EventDispatcher  
	{
		
		public var name : String = ''; 
		public var description : String = ''; 
		
		static public var UPDATED : String = 'updateBehaviorVO'; 
		public var swf_name:String;
		public var weight:String;
		public var defaultSize:Number;
		public var behaviors:ArrayCollection;
		
		public function loadBehaviors( value :  Array ) : void
		{
			this.behaviors = new ArrayCollection( value ); 
		}
		
		//public function 
	}
}