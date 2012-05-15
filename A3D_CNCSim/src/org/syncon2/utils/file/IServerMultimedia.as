package org.syncon2.utils.file
{
	import flash.net.URLRequest;
	
	import org.syncon2.utils.services.utils.SendRequest;
	
	public interface IServerMultimedia// implements ILoadConfig
	{
		
		
		//must clone IConfig ...
		/**
		 * keep base folder upatded
		 * */
		/*static public var fxGetBaseFolder  : Function; 
		
		static public var _baseFolder : String = 'G:/My Documents/work/flex4/Mobile2/RosettaStoneBuilder_Flex/bin-debug/assets'
		*/
			
		  function set  baseFolder(   s: String) : void
		  function get baseFolder(   ): String
		
		  function get getBaseFolder(   ): String
		 
		  function downloadVideoFileTo(url : String, dir : String, filename:String,
											fxCallbak : Function, fxFault : Function=null, renameIfExists : Boolean=false ):void
		
		  function downloadVideoFileTo_(url : String, dir : String, filename:String, fx : Function=null , 
										fxFault : Function=null,
											 rename_if_used : Boolean = false, audio_only : Boolean = false ):void
		
	}
}