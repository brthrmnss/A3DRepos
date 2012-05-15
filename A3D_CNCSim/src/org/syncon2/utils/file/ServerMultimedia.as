package org.syncon2.utils.file
{
	import flash.net.URLRequest;
	
	import org.syncon2.utils.services.utils.SendRequest;
	
	public class ServerMultimedia  implements IServerMultimedia 
	{
		
		
		//must clone IConfig ...
		/**
		 * keep base folder upatded
		 * */
		static public var fxGetBaseFolder  : Function; 
		
		static public var _baseFolder : String = 'G:/My Documents/work/flex4/Mobile2/RosettaStoneBuilder_Flex/bin-debug/assets'
		
			
		public function set  baseFolder(   s: String) : void
		{
			  _baseFolder = s
		}
		public function get baseFolder(   ): String
		{
			if ( fxGetBaseFolder != null ) 
				return fxGetBaseFolder()
			return _baseFolder; // FileAir2_Air.baseFolder.nativePath
		}
		
		public function get getBaseFolder(   ): String
		{
			return baseFolder; // FileAir2_Air.baseFolder.nativePath
		}
		
  
		 
		public function downloadVideoFileTo(url : String, dir : String, filename:String,
											fxCallbak : Function,	 fxFault :  Function = null, renameIfExists : Boolean=false ):void
		{
			var fileAir : FileAir2 = new FileAir2();
			if ( dir == '' ) dir =  baseFolder 
			if ( dir.indexOf(':') == -1 ) 
				dir = baseFolder + '/' +  dir   				
			downloadVideoFileTo_(url, dir, filename, fxCallbak, fxFault,renameIfExists)
		}
		
		
		
		private var  fxDownloadFile : Function; 
		
		private var  fxDownloadFault : Function; 
		
		public function downloadVideoFileTo_(url : String, dir : String, filename:String, fx : Function=null , 
											 fxFault :  Function = null,
											 rename_if_used : Boolean = false, audio_only : Boolean = false ):void
		{
			var fileAir : FileAir2 = new FileAir2();
			var pss :   SendRequest = new SendRequest(); 
			var params : Object = {}; 
			params.file = filename
			params.folder =dir
			params.url = url
			params.audio_only = audio_only
			fileAir.randomize(params); 
			params.rename_if_used = rename_if_used 
			pss.request( FileAir2.baseAddressOfProxyServer+'download_video', params, onDownloadFileResult , onDownloadFileFault ); 
			fxDownloadFile = fx; 
			fxDownloadFault = fxFault; 
		}
		
		private function onDownloadFileResult(data:String):void
		{
			trace("Upload complete");
			if ( fxDownloadFile != null ) 
				fxDownloadFile( data ) ; 
		}
		
		private function onDownloadFileFault(e:Object):void
		{
			trace('upload error'); 
			if ( fxDownloadFault != null ) 
				fxDownloadFault(  ) ; 
			
			
		} 
		
		
		
	}
}