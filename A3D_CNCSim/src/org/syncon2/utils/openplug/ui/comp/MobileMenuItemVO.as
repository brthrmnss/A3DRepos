package  org.syncon2.utils.openplug.ui.comp
{
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	
	public class MobileMenuItemVO 
	{
		 public var fxClick :  Function; 
		 /**
		 * if set will send to fxString
		 * */
		 public var fxClickData : String ;
		 
		 public var label : String
		 public var desc : String 
		 public var noAction:Boolean;
	}
}