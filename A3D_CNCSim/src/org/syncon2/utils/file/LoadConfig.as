package  org.syncon2.utils.file
{
	public class LoadConfig   implements ILoadConfig
	{
		
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
		
		public   function readObjectFromFile(fname:String,  fxCallback : Function ):Object
		{
			var file:File = File.applicationDirectory.resolvePath(fname);
			var dbg : Array = [File.applicationDirectory]
			trace ( 'file exists', file.exists ) ; 
			if(file.exists) { 
				var obj:Object;
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				obj = fileStream.readUTFBytes(fileStream.bytesAvailable ); 
				fileStream.close();
				//return obj;
			} else
			{
			
				file = File.applicationStorageDirectory.resolvePath(fname);
				if(file.exists) {
					var obj:Object;
					var fileStream:FileStream = new FileStream();
					fileStream.open(file, FileMode.READ);
					obj = fileStream.readUTFBytes(fileStream.bytesAvailable ); 
					fileStream.close();
					//return obj;
				}
			}
			//fxCallback(obj);
			//return null;
			return obj; 
		}
		
		
		public   function writeObjectToFile(object:Object, fname:String, fxCallbak : Function=null):Boolean
		{
			var file:File = File.applicationStorageDirectory.resolvePath(fname);
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeObject(object);
			fileStream.close();
			if ( fxCallbak != null ) fxCallbak(); 
			return true; 
		}
		
		
		
	}
}