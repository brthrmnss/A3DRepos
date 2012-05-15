package   org.syncon.CncSim.controller
{
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
 
	public class ImportViridJSONCommandTriggerEvent extends Event
	{
		public static const IMPORT_JSON:String = 'importViridjson';
		
		public var str : String;
		
		public function ImportViridJSONCommandTriggerEvent(type:String   , str : String ) 
		{	
			this.str = str
			super(type, true);
		}
		
	 
	}
}