package   org.syncon.CncSim.controller
{
	import flash.events.Event;

	/**
	 * */
	public class ExecutePlanCommandTriggerEvent extends Event
	{
		
		
		public static const PLAY:String = 'ExecutePlanCommandTriggerEvent.run.';
		public static const STOP:String = 'ExecutePlanCommandTriggerEvent.pause.';
		public static const PAUSE:String = 'ExecutePlanCommandTriggerEvent.stop.';
		public static const GO_TO_LINE:String = 'ExecutePlanCommandTriggerEvent.goToLine.2.';
		
		/*public var fxResult : Function;
		public var fxFault : Function; */
		public var data : Object = null; 
 
		public function ExecutePlanCommandTriggerEvent(type:String,  data : Object = null,  fxR : Function=null, fxF : Function = null ) 
		{	
			this.data = data; 
			super(type, true);
		}
		
		/**
		 * Maps user store commands 
		 * */
		static public function mapCommands(commandMap :  Object, command : Object ) : void
		{
			
			var types : Array = [
				ExecutePlanCommandTriggerEvent.PLAY, 
				ExecutePlanCommandTriggerEvent.STOP,
				ExecutePlanCommandTriggerEvent.PAUSE,
				ExecutePlanCommandTriggerEvent.GO_TO_LINE,			
			]
			for each ( var commandTriggerEventString : String in types ) 
			{
				commandMap.mapEvent(commandTriggerEventString,  command, ExecutePlanCommandTriggerEvent, false );			
			}
		}		
		
	}
}