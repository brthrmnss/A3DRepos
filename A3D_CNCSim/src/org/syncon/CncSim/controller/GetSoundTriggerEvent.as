package   org.syncon.CncSim.controller
{
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
 
	public class GetSoundTriggerEvent extends Event
	{
		public static const GET_SOUND:String = 'getSound...';
		public var urlReq :  URLRequest;
		
		public var url : String;
		
		public function GetSoundTriggerEvent(type:String   , url : String ) 
		{	
			this.url = url
			super(type, true);
		}
		
	 
	}
}