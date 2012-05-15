package   org.syncon.Customizer.controller
{
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
 
	public class ExportJSONCommandTriggerEvent extends Event
	{
		public static const EXPORT_JSON:String = 'exportjson';
		public static const EXPORT_NEW_IMAGE:String = 'uploadnewimage';
		public var urlReq :  URLRequest;
		
		public var url : String;
		
		public function ExportJSONCommandTriggerEvent(type:String   , url : String ) 
		{	
			this.url = url
			super(type, true);
		}
		
	 
	}
}