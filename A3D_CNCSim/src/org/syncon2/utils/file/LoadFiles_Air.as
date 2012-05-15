package org.syncon2.utils.file
{
	import flash.net.URLRequest;
	
	public class LoadFiles_Air implements ILoadConfig
	{
		
		public function get appendIndicator() : String 
		{
			return '.***'
		}
		
		public function readObjectFromFile(fname:String, fxCallbak : Function ):Object
		{
			throw 'have disabled these functions, use json, do you need them? '
			/*var fileAir : FileAir = new FileAir(); 
			fileAir.read(fname, fxCallbak)*/
			return false; 
		}
		
		
		
		public function writeObjectToFile(object:Object, fname:String, fxCallbak : Function=null):Boolean
		{
			throw 'have disabled these functions, use json, do you need them? '
			/*var fileAir : FileAir = new FileAir(); 
			fileAir.write( fname, object , 'writeObject' ) */
			return false; 
		}
		
		
		/**
		 * I think this is ignored? else why is it here?
		 * FileAir2_AirHas same setting seems to be more relevant
		 * this might be a festiage of the flex pattern ...can we narrow it to use just 1? 
		 * (erdirect from the other)
		 * 1/19/12: blocked this set your own or none
		 * */
		//static public var baseFolder : String = '????G:/My Documents/work/flex4/Mobile2/RosettaStoneBuilder_Flex/bin-debug/assets'
		static public var baseFolder : String = '';
		public function readFile(dir : String, filename:String, fxCallbak : Function ):void
		{
			var fileAir : FileAir2_Air = new FileAir2_Air();
			trace(this.debugName, 'readFile', dir, filename );
			/*if ( dir == '' ) dir =  baseFolder 
			if ( dir.indexOf(':') == -1 ) 
			dir = baseFolder + '/' +  dir   		*/		
			dir =this.fixDir( dir) ; 
			fileAir.read(dir, filename, fxCallbak)
		}
		
		public function writeFile(contents : String, dir : String, filename:String, fxCallbak : Function=null):void
		{
			var fileAir : FileAir2_Air = new FileAir2_Air(); 
			/*if ( dir == '' ) 
			{
			dir = getDir(filename)
			filename = getFileName(filename)
			}
			if ( dir == '' ) dir =  baseFolder 
			if ( dir.indexOf(':') == -1 ) 
			dir = baseFolder + '/' +  dir   */
			dir =this.fixDir( dir ) ;  
			fileAir.write(  contents,dir, filename, fxCallbak ) 
		}
		
		/**
		 * skipIfExists is not implmented ...should be .. tha'ts how you can give away this progrma ...
		 * */
		public function downloadFileTo(url : String, dir : String, filename:String, fxCallbak : Function, renameIfExists : Boolean=false, skipIfExists : Boolean = false ):void
		{
			var fileAir : FileAir2_Air = new FileAir2_Air();
			dir = this.fixDir(dir); 
			fileAir.downloadFileTo(url, dir, filename, fxCallbak)
		}
		
		private function fixDir(dir:String ):String
		{
			if ( dir == '' ) dir =  baseFolder 
			if ( dir.indexOf(':') == -1 && doNotCheckForColon == false )
			{
				if (  baseFolder != null && baseFolder != ''  ) 
					dir = baseFolder + '/' +  dir
			}
			return dir;
		}
		
		public function getUrlProxy(url : String ):URLRequest
		{
			var fileAir : FileAir2_Air = new FileAir2_Air(); 
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
		
		private function getDir(filename:String):String
		{
			if ( filename.indexOf('/') == -1 ) 
				return ''
			var split : Array = filename.split('/'); 
			//if no '.' complain
			var dir : String = split.slice( 0, split.length-2).join('/');
			return dir;
		}
		
		
		
		
		public function deleteFile( dir : String, filename:String, fxCallbak : Function=null ):void
		{
			var fileAir : FileAir2_Air = new FileAir2_Air();
			dir = this.fixDir(dir); 
			fileAir.deleteFile( dir, filename, fxCallbak)
		}
		
		private var debugName:  String = 'LoadFiles_Air';
		static public var doNotCheckForColon:Boolean=true;
		
		
		
		public function getDirectoryListing( dir : String, fxCallbak : Function=null ):void
		{
			var fileAir : FileAir2_Air = new FileAir2_Air();
			trace(this.debugName,'getDirectoryListing', dir ) 
			trace(this.debugName,'getDirectoryListing', 'base folder', baseFolder ) 
			dir = this.fixDir(dir); 
			trace(this.debugName,'getDirectoryListing','pt2',  dir ) 
			fileAir.getDirectoryListing( dir , fxCallbak)
		}
		
		
		
		public function isDirectory(   filename:String, fxCallbak : Function=null ):void
		{
			var fileAir : FileAir2_Air = new FileAir2_Air();
		}
		
		
		public function getSubDirectories( dir : String,  fxCallbak : Function=null ):void
		{
			var fileAir : FileAir2_Air = new FileAir2_Air();
			dir = this.fixDir(dir); 
			fileAir.getSubDirectories( dir , fxCallbak)
		}
		
		public function get getBaseFolder(   ): String
		{
			//return baseFolder;
			return FileAir2_Air.startFile.nativePath
		}
		/*	
		public function downloadFileTo(url : String, dir : String, filename:String, fxCallbak : Function, renameIfExists : Boolean=false ):void
		{
		throw 'didnt care to implement it for air flex-only now flex'; 
		}*/
		public function moveFiles(files: Array, dir : String, moveTo : String, fxCallbak : Function, negation : Boolean = false): void
		{
			throw 'not implemented'
			/*var fileAir : FileAir2 = new FileAir2();
			dir = fixFolderForGlobalPath( dir ) 
			fileAir.moveFiles(files , dir , moveTo, fxCallbak , negation )*/
		}
		
		
	}
}