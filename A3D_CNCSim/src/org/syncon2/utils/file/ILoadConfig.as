package  org.syncon2.utils.file
{
	import flash.net.URLRequest;
	
	public interface ILoadConfig  
	{
		/**
		 * Static property , this is the interface work around
		 * */
		function get appendIndicator() : String 
		/**
		 * post save function to call when saving is complete ... thisis for async support 
		 * */
		function writeObjectToFile(object:Object, fname:String, fxCallbak : Function =null):Boolean
		
		/**
		 * return false if you don't have sync data 
		 * */
		function readObjectFromFile(fname:String, fxCallbak : Function): Object
		
		
		
		
		
		/**
		 * post save function to call when saving is complete ... thisis for async support 
		 * */
		function writeFile(contents : String, dir : String, filename:String, fxCallbak : Function =null):void
		
		/**
		 * return false if you don't have sync data 
		 * */
		function readFile(dir : String, filename:String, fxCallbak : Function): void
		
		
		/**
		 * return false if you don't have sync data 
		 * renameIfExists : Boolean=false 
		 * */
		/**
		 * 
		 * @param url
		 * @param dir
		 * @param filename
		 * @param fxCallbak
		 * @param renameIfExists
		 * @param skipIfExists - will override renameIfExists, will return name and not save , if file is found in same location 
		 * 
		 */
		function downloadFileTo(url : String, dir : String, filename:String, fxCallbak : Function,
								renameIfExists : Boolean=false, skipIfExists : Boolean=false  ): void
		
		/**
		 * return false if you don't have sync data 
		 * */
		function getUrlProxy(url : String ): URLRequest
		
		
		/**
		 * */
		function deleteFile( dir : String, filename:String, fxCallbak : Function=null): void
		
		/**
		 * will return strings of files in folder
		 * */
		function getDirectoryListing( dir : String, fxCallbak : Function=null): void
		
		
		/**
		 * */
		function isDirectory(  filename:String, fxCallbak : Function=null): void			  
		
		
		/**
		 * */
		function getSubDirectories(  dir:String, fxCallbak : Function=null): void			  			  
		
		/**
		 * negation moves files not in that group
		 * */
		function moveFiles(files: Array, folder : String, moveTo : String, fxCallbak : Function, negation : Boolean = false): void
		
		
		
		
		/**
		 * used for flex for ruby server locating ... not imp for air ? 
		 * to set pro use the implementation 
		 * needs to be a static implmeentation ...
		 * i do not undersatnd how this is ok to compile ...
		 * */
		function get   getBaseFolder(  ):String 
		
		/**
		 * GenerateRequestForFile
		 *  in flex, we have a local file definition , that was generated using get base folder
		 * convert that back to something i can send to server and get contents of file
		 * only used b/c we don't want to parse the information differnetly for non air environments
		 * ..which might be a bad idea .... yes it is, ... iwill leave this a sa remind this is wrong 
		 * ... one day we will want to go to flex, so do this conversion on ones own? 
		 * how do you take off the adding of locations? 
		 * your code should be able to handle both for testing purposes 
		 * 
		 * just disable prepend and you have what you needed
		 * */
		//function  GenerateRequestForFile(url : String ) : URLRequest
	}
}