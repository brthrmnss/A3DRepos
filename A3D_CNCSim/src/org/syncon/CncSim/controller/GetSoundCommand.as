package  org.syncon.CncSim.controller
{
	
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.CncSim.model.NightStandConstants;
	import org.syncon.CncSim.model.NightStandModel;
	
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	
	
	public class GetSoundCommand extends Command
	{
		[Inject] public var model:NightStandModel;
		[Inject] public var event:GetSoundTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == GetSoundTriggerEvent.GET_SOUND ) 
			{
				this.loadSound()
			}				
			
		}
		
		private var ui : UIComponent;  
		private function loadSound():void
		{
			if ( event.url.slice(0,4 ).toString().toLowerCase() == 'http' ) 
				return; 
			if ( NightStandConstants.flex == false  ) 
				return; 
			
			var req:URLRequest = new URLRequest("http://localhost:8888/read_file");
			//req.method = URLRequestMethod.POST;
			
			var postData:URLVariables = new URLVariables();
			postData.file_name =event.url; //encoder.flush();
			postData.path = 'G:\\My Documents\\work\\flex4\\Mobile2\\TalkingClock\\bin-debug'//encoder.flush();
			//postData.readAs
			req.data = postData;
			
			this.event.urlReq = req; 
			/*var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, loader_complete2);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.onReadFault, false, 0, true  ) */
			//loader.load(req);
			//fxRead = fx; 			
			
			/*var config : NightStandConfigVO = NightStandConstants.FileLoader.readObjectFromFile( event.url, this.loadConfigPart2, event.path ) as NightStandConfigVO;*/
		}
		static public function generateUrlRequest( url :  Object  = '') : URLRequest
		{
			var req:URLRequest = new URLRequest("http://localhost:8888/read_file");
			//req.method = URLRequestMethod.POST;
			
			var postData:URLVariables = new URLVariables();
			postData.file_name = url//encoder.flush();
			postData.path = 'G:\\My Documents\\work\\flex4\\Mobile2\\TalkingClock\\bin-debug'//encoder.flush();
			//postData.readAs
			req.data = postData;
			
			return req; 
		}
		
	}
}