package  org.syncon.CncSim.vo
{
	import flash.events.EventDispatcher;
	
	/**
	 * Face image
	 * */
	public class MeshVO  extends EventDispatcher  
	{
		
		public var name : String = ''; 
		public var description : String = ''; 
		
		static public var UPDATED : String = 'updated_MeshVO'; 
		public var swf_name:String;
		public var weight:String;
		public var defaultSize:Number;
		
		
	}
}