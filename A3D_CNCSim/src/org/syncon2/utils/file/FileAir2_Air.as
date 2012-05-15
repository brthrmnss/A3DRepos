package  org.syncon2.utils.file
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import org.syncon2.utils.services.utils.RequestURL;
	import org.syncon2.utils.services.utils.SendRequest;
	
	/**
	 * Wrapper for a server ....
	 * classes should not implement this directly, use LoadFiles_Air instead
	 * this hides any OS specific oddities of FS from user
	 * */
	public class FileAir2_Air  
	{
		static public var baseAddressOfProxyServer : String =  'http://localhost:7126/'
		//static public var baseFolder : File = File.applicationStorageDirectory
		static public var baseFolder_writeOverride :  File// = File.applicationDirectory; 
		private var  fxRead : Function; 
		/**
		 * 1/19/12: instead of using baseFolder, just used this 
		 * baseFolders should be resolve elswhere. 
		 * This class expect absolute paths 
		 * */
		static public var startFile : File=   File.applicationStorageDirectory
		
		public   function read( folder : String,  filename : String, fx : Function ):void
		{
			//new File()
			//var f : File = File.applicationDirectory
			trace( this.debugName, 'read1', path, file, folder, filename ) ; 
			var path :String= this.joinPath(folder, filename ) 
			//var b : Object = baseFolder 
			trace( this.debugName, 'read2', path, file, folder, filename ) ; 
			file = new File(); 
			var file:File =  File.applicationStorageDirectory.resolvePath(path);
			var path_ : String= file.nativePath
			trace( this.debugName, 'read3', path, file, folder, filename ) ; 
			if(file.exists) {
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				var str:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
				fileStream.close();
				fx( str )
				return;
			}
			trace('could not load file FileAir2_Air ... 42', folder, filename )
			fx( null) 
		}
		
		private function joinPath(folder:String, filename:String): String
		{
			if ( folder == null ) 
				folder = '' 
			if ( folder == '' ) 
				return filename 
			var newPath : String = folder+ '/' + filename
			return newPath;
		}
		
		private var  fxWritten : Function; 
		
		public function write(contents : String, folder : String, filename:String, fx : Function=null ):void
		{
			var path :String= this.joinPath(folder, filename ) 
			var file:File = startFile.resolvePath(path);
			if ( baseFolder_writeOverride != null ) 
			{
				file = baseFolder_writeOverride.resolvePath(path);
			}
			try 
			{
				file = new File(file.nativePath );
			}
			catch ( e : Error )  {}
			if ( file.exists == false && file.isDirectory )
				file.createDirectory()
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			//contents = contents.replace(/\r/g, File.lineEnding);
			contents = contents.replace(/\r/g, '\n');
			fileStream.writeUTFBytes(contents);
			fileStream.close();
			
			if ( fx != null )  	fx( contents )
		}
		
		
		private var  fxDownloadFile : Function; 
		
		public function downloadFileTo(url : String, dir : String, filename:String, fx : Function=null ):void
		{
			
			var path :String= this.joinPath(dir, filename ) 
			this.lastParams= [url, dir, filename, fx, path]
			var file:File = startFile.resolvePath(path);
			//file.deleteFile()
			
			//throw 'fix this'; 
			//File , add path and save
			
			/*var pss :   RequestURL = new RequestURL(); 
			var params : Object = {}; 
			pss.request(url, params, onDownloadFileResult2 , onDownloadFileFault2 ); 
			fxDownloadFile = fx; */
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, this.onDownloadFileResult2 )
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.onDownloadFileFault2 )
			var req:URLRequest = new URLRequest(url);
			loader.load(req);
			
			this.loader_ = loader; 
		}
		
		private function onDownloadFileResult2(e: Event):void
		{
			
			trace('onDownloadFileResult2', "Upload complete", this.lastParams[4]);
			/*this.saveFile()*/
			var air:File = File.applicationStorageDirectory.resolvePath(this.lastParams[4]);
			trace('onDownloadFileResult2', "Upload complete...", air.nativePath);			
			var fs:FileStream = new FileStream();
			fs.open(air, FileMode.WRITE);
			fs.writeBytes(e.currentTarget.data);
			fs.close();
			
			this.cleanLoader()
			this.lastParams[3](air.nativePath ); 
		}
		
		private function cleanLoader():void
		{
			// TODO Auto Generated method stub
			loader_.removeEventListener(Event.COMPLETE, this.onDownloadFileResult2 )
			loader_.removeEventListener(IOErrorEvent.IO_ERROR, this.onDownloadFileFault2 )
		}
		
		private function saveFile():void
		{
			// TODO Auto Generated method stub
			trace('onDownloadFileResult2', "saveFile")
		}
		
		private function onDownloadFileFault2(e:Object):void
		{
			trace('onDownloadFileFault2', 'upload error'); 
			
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
			/*var b : ByteArray = event.currentTarget.data; 
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
			}*/
			var data2 : Object
			fxReadDir( data2  ) ;
		}
		
		private var fxReadDir:Function;
		private var lastParams:Array;
		private var loader_:URLLoader;
		private var debugName:  String = 'FileAir2_Air';
		
		
		
		
		public function getProxy(url:String) : URLRequest
		{
			var req:URLRequest = new URLRequest(baseAddressOfProxyServer+"play_sound");
			var postData:URLVariables = new URLVariables();
			postData.file_name //=event.url; //encoder.flush();
			postData.path //= this.
			postData.url = url
			//postData.readAs
			req.data = postData;
			return req; 
		}
		
		
		public function deleteFile( dir : String, filename:String, fx : Function=null ):void
		{
			trace( this.debugName, 'deleteFile', dir, fx, startFile ) ; 
			var path :String= this.joinPath(dir, filename ) 
			var file:File = startFile.resolvePath(path);
			trace( this.debugName, 'deleteFile', file, file.nativePath ) ;
			
			file.deleteFile()
			if ( fx != null ){ 
				fx( filename ) ; 
			}
		}
		
		public function getDirectoryListing( dir :String, fx : Function=null ):void
		{
			trace( this.debugName, 'getDirectoryListing', dir, fx, startFile ) ; 
			var folder:File = new File(); //startFile.resolvePath(dir);
			folder = folder.resolvePath( dir ) ; 
			trace( this.debugName, 'getDirectoryListing', 'folder', folder, folder.nativePath, folder.exists ) //, fx ) ; 
			if ( folder.exists == false ) 
				folder.createDirectory(); 
			trace( this.debugName, 'getDirectoryListing', 'eixts', folder.exists, folder.nativePath ) //, fx ) ; 
			var dirList:Array = folder.getDirectoryListing();
			trace( this.debugName, 'getDirectoryListing', 'listed', dirList.length ) ;//, fx ) ; 
			var directories:Array  = [] ;
			dirList.sortOn('name' )
			trace( this.debugName, 'getDirectoryListing', 'sorted' )//, dirList.length ) ;
			for each ( var d : File in dirList ) 
			{
				if ( d == null ) 
				{
					trace( this.debugName, 'getDirectoryListing', 'bad on' )//',d.name, d.nativePath ) ;
					continue; 	
				}
				trace( this.debugName, 'getDirectoryListing', 'listing',d.name, d.nativePath ) ;
				directories.push(d.name)
			}
			trace( this.debugName, 'getDirectoryListing', 'done..', dirList.length )
			trace( this.debugName, 'getDirectoryListing', 'done..>',   fx, directories) ;//, fx ) ; 
			if ( fx != null ) 
				fx(directories)
			trace( this.debugName, 'getDirectoryListing', 'done...', dirList.length ) ;//, fx ) ; 
		}
		
		public function getSubDirectories( dir :String, fx : Function=null ):void
		{
			var folder:File = startFile.resolvePath(dir);
			var dirList:Array = folder.getDirectoryListing();
			var directories:Array  = [] ;
			dirList.sortOn('name' )
			for each ( var d : File in dirList ) 
			{
				if ( d.isDirectory ) 
					directories.push(d.name)
			}
			
			
			if ( fx != null ) 
				fx(directories)
		}
		
		/**
		 * ??? mistake why is this here? 
		 * 8/147/11
		 * 
		 * */
		/*public function get baseFolderr () : File
		{
		return baseFolder; 
		}
		
		*/
	}
}