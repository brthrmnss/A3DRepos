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
	
	public class FileAir  
	{
		public   function read(name:String , fx : Function ):void
		{
			var req:URLRequest = new URLRequest("http://localhost:8888/read_file");
			//req.method = URLRequestMethod.POST;
			
			var postData:URLVariables = new URLVariables();
			postData.file_name =name//encoder.flush();
			//postData.path = 'bredddde'//encoder.flush();
			//postData.readAs
			req.data = postData;
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, loader_complete2);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.onReadFault, false, 0, true  ) 
			loader.load(req);
			fxRead = fx; 
		}
		
		protected function onReadFault(event:IOErrorEvent):void
		{
			trace("read fault ");
			fxRead(null ) ; 
		}
		
		private function loader_complete2(event:Event):void
		{
			var b : ByteArray = event.currentTarget.data; 
			trace("read file ");
			// Retrieve the loaded data. We know it's a ByteArray, so let's cast it as well.
			var data : ByteArray = b
				b.bytesAvailable
					var dbg : Array = [ b.bytesAvailable]
			//	data.readBytes( data, 
			try{
				data.position = 0 ; 
				// Use the ByteArray.readObject method to reconstruct the object.
				var obj : Object = data.readObject() //as NightStandConfigVO;
				// Cast the object and assign it to our data container.
				//dataObject = obj// as SimpleDataVO;
				var bbb : ByteArray = new ByteArray()
					bbb.writeObject( obj ) ; 
					bbb.position = 0 ; 
					var d : Array = [ bbb.readObject() ] 
				
				
				var data2 :  Object = JSON.decode( obj.toString() ) 
				trace( data2 ) ; 
				
				
			}
			catch(e:Error )
			{
				trace(e); 
			}
			fxRead( data2  ) ;
		}
		
		private var  fxRead : Function; 
		
		
		public function write(name : String, data : Object, writeMethod : String = '', fx : Function=null ):void
		{
			var req:URLRequest = new URLRequest("http://localhost:8888/upload_file");
			req.method = URLRequestMethod.POST;
			
			var postData:URLVariables = new URLVariables();
			postData.file_name = name ///encoder.flush();
			
			var byteArray : ByteArray = new ByteArray();
			byteArray.writeObject( data );
			JSON
			
			postData.contents = byteArray;
			//postData.contents = data;
			 // postData.writeMethod = 'writeBytes'; 
			  postData.writeMethod = 'writeObject'; 
			 //postData.writeMethod = 'writeUTFBytes'; 
			var data2 : String = JSON.encode( data ) 
			postData.contents = data2;
			req.data = postData;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, loader_complete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.onIOErrorUpload ); 
			loader.load(req);
			fxWritten = fx; 
		}
		
		
		private function loader_complete(event:Event):void
		{
			trace("Upload complete");
			if ( fxWritten != null ) 
				fxWritten( event.currentTarget ) ; 
		}
		
		private var  fxWritten : Function; 
		
		protected function onIOErrorUpload(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
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
		
		protected function onReadDirectoryFault(event:IOErrorEvent):void
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
		
		
		
		
	}
}