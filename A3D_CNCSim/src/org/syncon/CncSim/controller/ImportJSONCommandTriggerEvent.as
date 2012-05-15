package   org.syncon.CncSim.controller
{
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
 
	public class ImportJSONCommandTriggerEvent extends Event
	{
		public static const IMPORT_JSON:String = 'importjson';
		
		public var str : String;
		
		public function ImportJSONCommandTriggerEvent(type:String   , str : String ) 
		{	
			this.str = str
			super(type, true);
		}
		
	 
	}
}