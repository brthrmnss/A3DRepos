package   org.syncon.Customizer.controller
{
	
	import flash.events.Event;
	
	public class TestImportViridJSONCommandTriggerEvent extends Event
	{
		public static const TEST_IMPORT_VIRID_JSON:String = 'TEST_importViridjson';
		
		public var str : String;
		
		public function TestImportViridJSONCommandTriggerEvent(type:String   , str : String='' ) 
		{	
			this.str = str
			super(type, true);
		}
		
		
	}
}