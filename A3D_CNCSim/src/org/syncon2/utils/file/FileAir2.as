package  org.syncon2.utils.file
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import org.syncon2.utils.services.utils.SendRequest;
	
	public class FileAir2  
	{
		static public var baseAddressOfProxyServer : String =  'http://localhost:7126/'
		
		private var  fxRead : Function; 
		
		public   function read( folder : String,  file : String, fx : Function ):void
		{
			var pss :  SendRequest = new SendRequest(); 
			var params : Object = {}; 
			params.file = file
			params.folder = folder
			this.randomize(params); 
			pss.request(baseAddressOfProxyServer+'gf', params, loader_complete2 , onReadFault ); 
			fxRead = fx; 
		}
		
		protected function onReadFault(event: Object):void
		{
			trace("read fault ");
			fxRead(null ) ; 
		}
		
		private function loader_complete2(data:String):void
		{
			fxRead( data  ) ;
		}
		
		
		
		
		private var  fxWritten : Function; 
		
		public function write(contents : String, dir : String, filename:String, fx : Function=null ):void
		{
			var pss :   SendRequest = new SendRequest(); 
			var params : Object = {}; 
			params.file = filename
			params.folder =dir
			params.contents = contents
			
			pss.requestPost( baseAddressOfProxyServer+'sf', params, onSaveFileResult , onSaveFileFault ); 
			fxWritten = fx; 
		}
		
		private function onSaveFileResult(data:String):void
		{
			trace("Upload complete");
			if ( fxWritten != null ) 
				fxWritten( data ) ; 
		}
		
		private function onSaveFileFault(e:Object):void
		{
			trace('upload error'); 
			
		} 
		
		
		private var  fxDownloadFile : Function; 
		
		public function downloadFileTo(url : String, dir : String, filename:String, fx : Function=null ,
									   rename_if_used : Boolean = false, skipIfExists : Boolean = false  ):void
		{
			var pss :   SendRequest = new SendRequest(); 
			var params : Object = {}; 
			params.file = filename
			params.folder =dir
			params.url = url
			this.randomize(params); 
			params.rename_if_used = rename_if_used 
			params.skip_if_exists = skipIfExists 
			pss.request( baseAddressOfProxyServer+'download_file', params, onDownloadFileResult , onDownloadFileFault ); 
			fxDownloadFile = fx; 
			this.lastParams = params; 
		}
		
		private function onDownloadFileResult(data:String):void
		{
			trace("FileAir2", 'onDownloadFileResult');
			if ( fxDownloadFile != null ) 
				fxDownloadFile( data ) ; 
		}
		
		private function onDownloadFileFault(e:Object):void
		{
			trace('upload error'); 
			
		} 
		
		
		
		private var  fxDeleteFile : Function; 
		
		public function deleteFile( dir : String, filename:String, fx : Function=null ):void
		{
			var pss :   SendRequest = new SendRequest(); 
			var params : Object = {}; 
			params.file = filename
			lastFilename = filename; 
			params.folder =dir
			pss.request( baseAddressOfProxyServer+'delete_file', params, onDeleteFileResult , onDeleteFileFault ); 
			fxDeleteFile = fx; 
		}
		
		private function onDeleteFileResult(data:String):void
		{
			trace("Upload onDeleteFileResult");
			if ( fxDeleteFile != null ) 
				fxDeleteFile( data ) ; 
		}
		
		private function onDeleteFileFault(e:Object):void
		{
			trace('upload onDeleteFileFault', lastFilename); 
			
		} 
		
		
		private var  fxMoveFiles : Function; 
		
		public function  moveFiles(files: Array, folder : String, moveTo : String, fxCallbak : Function, negation : Boolean = false): void
		{
			var pss :   SendRequest = new SendRequest(); 
			var params : Object = {}; 
			params.files = files.join(', ');
			//params.files2 = files
			//params.files2 = [files]
			//params.file3 = ['g', '4', 'ggggggg.jpg']
			//lastFilename = files; 
			params.folder =folder
			params.move_to =moveTo
			params.negation = negation; 
			this.lastParams = params; 
			pss.request( baseAddressOfProxyServer+'move_files', params, onMoveFilesResult , onMoveFilesFault, true ); 
			fxMoveFiles = fxCallbak; 
		}
		
		private function onMoveFilesResult(data:String):void
		{
			trace(debugTag,"onMoveFilesResult");
			if ( fxMoveFiles != null ) 
				fxMoveFiles( data ) ; 
		}
		
		private function onMoveFilesFault(e:Object):void
		{
			trace(debugTag, 'onMoveFilesFault', this.lastParams.toString()); 
		} 
		
		/*
		public   function readObjectFromFile(fname:String):Object
		{
		var file:File = File.applicationStorageDirectory.resolvePath(fname);
		
		if(file.exists) {
		var obj:Object;
		var fileStream:FileStream = new FileStream();
		fileStream.open(file, FileMode.READ);
		obj = fileStream.readObject();
		fileStream.close();
		return obj;
		}
		return null;
		}
		*/
		
		
		public   function readDirectory(folder:String , fx : Function ):void
		{
			var req:URLRequest = new URLRequest("http://localhost:8888/read_folder");
			//req.method = URLRequestMethod.POST;
			
			var postData:URLVariables = new URLVariables();
			postData.folder =folder//encoder.flush();
			postData.random = (new Date).getTime()
			req.data = postData;
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, readDirectory_complete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.onReadDirectoryFault, false, 0, true  ) 
			loader.load(req);
			fxReadDir = fx; 
		}
		
		protected function onReadDirectoryFault(event:Object):void
		{
			trace("read dir fault ");
			fxReadDir(null ) ; 
		}
		
		private function readDirectory_complete(event:Event):void
		{
			var b : ByteArray = event.currentTarget.data; 
			trace("read dir ");
			var data : ByteArray = b
			try{
				var obj : Object = data.readObject() 
				var data2 :  Object = JSON.decode( obj.toString() ) 
				//trace( data2 ) ; 
			}
			catch(e:Error )
			{
				trace(e); 
			}
			fxReadDir( data2  ) ;
		}
		
		private var fxReadDir:Function;
		
		
		
		
		public function getProxy(url:String) : URLRequest
		{
			var req:URLRequest = new URLRequest(baseAddressOfProxyServer+"play_sound");
			var postData:URLVariables = new URLVariables();
			postData.file_name //=event.url; //encoder.flush();
			postData.path //= this.
			postData.url = url
			postData.random = (new Date).getTime()
			//postData.readAs
			req.data = postData;
			return req; 
		}
		
		
		public var cmd : String = ''; 
		public var fxResult : Function
		public var fxPreProc : Function		
		private var lastFilename:String;
		private var debugTag:Object='FileAir2';
		/**
		 * For debugging, see last sent params
		 * */
		private var lastParams:Object;
		public function getSubDirectories( dir :String, fx : Function=null ):void
		{
			var pss :   SendRequest = new SendRequest(); 
			var params : Object = {}; 
			params.folder =dir
			this.randomize(params); 
			cmd = 'get_sub_dirs'
			fxPreProc = JSON_decode
			pss.request( baseAddressOfProxyServer+cmd, params, autoResult , autoFault ); 
			fxResult = fx; 
		}
		
		public function getSubFiles( dir :String, fx : Function=null ):void
		{
			var pss :   SendRequest = new SendRequest(); 
			var params : Object = {}; 
			params.folder =dir
			this.randomize(params); 
			cmd = 'get_sub_files'
			fxPreProc = JSON_decode
			pss.request( baseAddressOfProxyServer+cmd, params, autoResult , autoFault ); 
			fxResult = fx; 
		}
		
		public function randomize(params:Object):void
		{
			params.random = (new Date).getTime()
		}
		
		private function JSON_decode(str:String):  Object
		{
			// TODO Auto Generated method stub
			return JSON.decode( str  ) 
		}
		
		private function autoResult(data: Object):void
		{
			trace("Upload "+cmd);
			if ( fxPreProc != null ) data = this.fxPreProc(data) ; 
			if ( fxResult != null ) 
				fxResult( data ) ; 
		}
		
		private function autoFault(e:Object):void
		{
			trace('upload '+cmd); 
			
		} 
		
		
		
	}
}