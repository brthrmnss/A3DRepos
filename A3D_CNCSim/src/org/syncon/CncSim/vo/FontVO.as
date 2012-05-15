package  org.syncon.CncSim.vo
{
	import flash.events.EventDispatcher;
	
	/**
	 * Face image
	 * */
	public class FontVO  extends EventDispatcher  
	{
		
		public var name : String = ''; 
		public var description : String = ''; 
		
		
		
		static public var UPDATED : String = 'updatedImaveVO'; 
		public var swf_name:String;
		public var weight:String;
		public var defaultSize:Number;
		
		
	}
}