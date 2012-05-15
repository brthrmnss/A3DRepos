package  org.syncon.CncSim.vo
{
	import flash.events.EventDispatcher;
	
	import org.syncon.CncSim.controller.EditProductCommandTriggerEvent;
	
	/**
	 * An action, on a mesh 
	 * for some purpose 
	 * can be exported to gcode()
	 * */
	public class BehaviorVO  extends EventDispatcher  
	{
		
		public var name : String = ''; 
		public var description : String = ''; 
		
		static public var UPDATED : String = 'updateBehaviorVO'; 
		public var swf_name:String;
		public var weight:String;
		public var defaultSize:Number;
		
		public var materials : Array = [] ; 
		public function get points(): Array
		{
			return []; 
		}
		
		public var steps : Array = [] ;
		public var stock : Array = [] ;
		
		
		public var finalMesh : MeshVO; 
		
		
		public var behaviors : Array = [] ; 
		/**
		 * if true, shows up in item renderer as folder
		 * */
		public var container : Boolean = false; 
		
		
		public function get gcode() : Array
		{
			return []; 
		}
		
		public function get aaa() : String 
		{
			return this.name
		}
		
		public function convertToEvent():EditProductCommandTriggerEvent
		{
			var e : EditProductCommandTriggerEvent = new EditProductCommandTriggerEvent(EditProductCommandTriggerEvent.DO_NOTHING); 
			return e; 
		}
	}
}