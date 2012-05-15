package org.syncon2.utils.openplug.controller
{
	import flash.events.Event;
	
	/**
	 * 
	 * */
	public class CallNativeCommandTriggerEvent extends Event
	{
		public static var STOP_ALL_SOUNDS:String = 'Stop All Sounds'; 
		public static var SET_RINGTONE:String = 'Set Ringtone'; 		
		public static var REPORT_PROBLEM:String = 'Report a problem'; 
		public static var RATE:String = 'Rate'; 
		public static var MORE: String = 'More Applications' 
		public static var ABOUT:String = 'About'; 
		public static var PLAY_ALL:String = 'Play All';
		public static var SHARE :  String = 'Share'
		public static var QUIT:String = 'Quit'; 
		
		
		public static const PROCESS:String = 'PROCESS_NATIVE_COMMAND..';
		
		public var data : Object = null; 
		public var command :  String = null; 
		public function CallNativeCommandTriggerEvent(type:String, command : String, data : Object = null
		) 
		{	
			this.command = command; 
			this.data = data; 
			super(type, true);
		}
		
		
	}
}