package   org.syncon.Customizer.controller
{
	import flash.events.Event;
	import flash.utils.ByteArray;

	/**
	 * */
	public class InitMainContextCommandTriggerEvent extends Event
	{
		
		
		public static const INIT:String = 'InitMainContextCommand.init..';
		public static const INIT2:String = 'InitMainContextCommand.init.2.';
		public static const INIT3_MAKEUP_FLEX_DATA:String = 'INIT3_MAKEUP_FLEX_DATA.init.2.';
		public static const CREATE_CLIP_ART_LIBRARY:String = 'CREATE_CLIP_ART_LIBRARY.init.2.';
		public static const EXIT_APP:String = 'EXIT_APP.init.2.';
		
		/*public var fxResult : Function;
		public var fxFault : Function; */
		public var showAds : Boolean = false;
		public var flex: Boolean = false ;
		public var data : Object = null; 
		public function InitMainContextCommandTriggerEvent(type:String, loadAds : Boolean = true,
														   flex : Boolean = false ,  data : Object = null,  fxR : Function=null, fxF : Function = null ) 
		{	
			/*this.fxResult = fxR
			this.fxFault = fxF; */
			this.showAds = loadAds; 
			this.flex = flex; 
			this.data = data; 
			super(type, true);
		}
		
		/**
		 * Maps user store commands 
		 * */
		static public function mapCommands(commandMap :  Object, command : Object ) : void
		{
			
			var types : Array = [
				InitMainContextCommandTriggerEvent.INIT, 
				InitMainContextCommandTriggerEvent.INIT2,
				InitMainContextCommandTriggerEvent.INIT3_MAKEUP_FLEX_DATA,
				InitMainContextCommandTriggerEvent.CREATE_CLIP_ART_LIBRARY,			
				InitMainContextCommandTriggerEvent.EXIT_APP
			]
			for each ( var commandTriggerEventString : String in types ) 
			{
				commandMap.mapEvent(commandTriggerEventString,  command, InitMainContextCommandTriggerEvent, false );			
			}
		}		
		
	}
}