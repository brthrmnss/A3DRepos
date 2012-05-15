package org.syncon2.utils.file
{
	import flash.net.URLRequest;
	
	public class LoadConfig_Flex implements ILoadConfig
	{
		
		public function get appendIndicator() : String 
		{
			return '.***'
		}
		
		public function readObjectFromFile(fname:String, fxCallbak : Function ):Object
		{
			var fileAir : FileAir = new FileAir(); 
			fileAir.read(fname, fxCallbak)
			return false; 
			/*	var file:File = File.applicationStorageDirectory.resolvePath(fname);
			
			if(file.exists) {
			var obj:Object;
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			obj = fileStream.readObject();
			fileStream.close();
			return obj;
			}
			return null;*/
		}
		public function get getBaseFolder(   ): String
		{
			return baseFolder; // FileAir2_Air.baseFolder.nativePath
		}
		
		
		public function writeObjectToFile(object:Object, fname:String, fxCallbak : Function=null):Boolean
		{
			var fileAir : FileAir = new FileAir(); 
			fileAir.write( fname, object , 'writeObject' ) 
			return false; 
		}
		
		
		
		static public var baseFolder : String = 'G:/My Documents/work/flex4/Mobile2/RosettaStoneBuilder_Flex/bin-debug/assets'
		
		public function readFile(dir : String, filename:String, fxCallbak : Function ):void
		{
			var fileAir : FileAir2 = new FileAir2(); 
			if ( dir == '' ) dir =  baseFolder 
			if ( dir.indexOf(':') == -1 ) 
				dir = baseFolder + '/' +  dir   	
			if (filename.indexOf(':') !=  -1 ) 
				dir = ''
			fileAir.read(dir, filename, fxCallbak)
		}
		
		public function writeFile(contents : String, dir : String, filename:String, fxCallbak : Function=null):void
		{
			var fileAir : FileAir2 = new FileAir2(); 
			if ( dir == '' ) 
			{
				dir = getDir(filename)
				filename = getFileName(filename)
			}
			if ( dir == '' ) dir =  baseFolder 
			if ( dir.indexOf(':') == -1 ) 
				dir = baseFolder + '/' +  dir   
			fileAir.write(  contents,dir, filename, fxCallbak ) 
		}
		
		
		public function downloadFileTo(url : String, dir : String, filename:String, fxCallbak : Function,
									   renameIfExists : Boolean=false, skipIfExists : Boolean = false  ):void
		{
			var fileAir : FileAir2 = new FileAir2();
			if ( dir == '' ) dir =  baseFolder 
			if ( dir.indexOf(':') == -1 ) 
				dir = baseFolder + '/' +  dir   				
			fileAir.downloadFileTo(url, dir, filename, fxCallbak, renameIfExists,skipIfExists)
		}
		
		public function getUrlProxy(url : String ):URLRequest
		{
			var fileAir : FileAir2 = new FileAir2(); 
			return fileAir.getProxy( url) 
		}		
		
		/**
		 * i fflex we alwas y apply the base folder on the directyory 
		 * */
		
		
		
		private function getFileName(filename:String):String
		{
			if ( filename.indexOf('/') == -1 ) 
				return filename
			var split : Array = filename.split('/'); 
			//if no '.' complain
			var last : String = split[split.length-1]
			return last;
		}
		/**
		 * this will not work o na directory ... 
		 * if you send directoy it will give you parent 
		 * */
		static public function getDir(filename:String):String
		{
			if ( filename.indexOf('/') == -1 ) 
				return ''
			var split : Array = filename.split('/'); 
			//if no '.' complain
			//if ( split[split.length-1]
			//		if ( lastSection.indexOf(
			var clipOff : int = 1; 
			if ( filename.charAt( filename.length -1 ) == '/' ) 
				clipOff = 2
			var dir : String = split.slice( 0, split.length-clipOff).join('/');
			return dir;
		}
		
		
		
		public function deleteFile( dir : String, filename:String, fxCallbak : Function=null ):void
		{
			var fileAir : FileAir2 = new FileAir2();
			if ( dir == '' ) dir =  baseFolder 
			if ( dir.indexOf(':') == -1 ) 
				dir = baseFolder + '/' +  dir   				
			fileAir.deleteFile( dir, filename, fxCallbak)
		}
		
		
		public function getDirectoryListing( dir : String, fxCallbak : Function=null ):void
		{
			var fileAir : FileAir2 = new FileAir2();
			if ( dir == '' ) dir =  baseFolder 
			if ( dir.indexOf(':') == -1 ) 
				dir = baseFolder + '/' +  dir   	
			fileAir.getSubFiles( dir , fxCallbak)
		}
		
		
		
		public function isDirectory(   filename:String, fxCallbak : Function=null ):void
		{
			var fileAir : FileAir2 = new FileAir2();
		}
		
		
		public function getSubDirectories( dir : String,  fxCallbak : Function=null ):void
		{
			var fileAir : FileAir2 = new FileAir2();
			if ( dir == '' ) dir =  baseFolder 
			if ( dir.indexOf(':') == -1 ) 
				dir = baseFolder + '/' +  dir   				
			fileAir.getSubDirectories( dir , fxCallbak)
		}
		
		public function fixFolderForGlobalPath( dir : String ) : String
		{
			if ( dir == '' ) dir =  baseFolder 
			if ( dir.indexOf(':') == -1 ) 
				dir = baseFolder + '/' +  dir   		
			return dir 
		}
		
		public function moveFiles(files: Array, dir : String, moveTo : String, fxCallbak : Function, negation : Boolean = false): void
		{
			var fileAir : FileAir2 = new FileAir2();
			dir = fixFolderForGlobalPath( dir ) 
			fileAir.moveFiles(files , dir , moveTo, fxCallbak , negation )
		}
		
		
	}
}