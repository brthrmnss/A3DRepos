package  org.syncon.CncSim.vo
{
	import flash.events.EventDispatcher;

	/**
	 * Stores clip art images
	 * */
	public class ImageVO  extends EventDispatcher
	{
		public var hiSpeedMode : Boolean = true; 
		
		public var name : String = ''; 
		public var url : String  = ''; 
		
		static public var UPDATED : String = 'updatedImaveVO'; 
		
	}
}