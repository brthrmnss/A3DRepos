package   org.syncon.TalkingClock.controller
{
	
	import flash.events.Event;
	import flash.utils.ByteArray;
 
	public class CopyOfConfigCommandTriggerEvent extends Event
	{
		public static const LOAD_CONFIG:String = 'loadConfig';
		public static const SAVE_CONFIG:String = 'saveCnofig';
		public static var SAVE_AND_LOAD_CONFIG:String= 'saveAndLoadConfig';
		public var url : String;
		public var password : String;		
		
		public var fxResult : Function;
		public var fxFault : Function; 

		
		public function ConfigCommandTriggerEvent(type:String   , fxR : Function=null, fxF : Function = null ) 
		{	
			this.fxResult = fxR
			this.fxFault = fxF; 
			super(type, true);
		}
		
		
		static public function mapCommands(commandMap :  Object, command : Object ) : void
		{
			var types : Array = [
				ConfigCommandTriggerEvent.LOAD_CONFIG, 
				ConfigCommandTriggerEvent.SAVE_CONFIG,
				SAVE_AND_LOAD_CONFIG
			]
			for each ( var commandTriggerEventString : String in types ) 
			{
				commandMap.mapEvent(commandTriggerEventString,  command, ConfigCommandTriggerEvent, false );			
			}
		}		
		
	}
}