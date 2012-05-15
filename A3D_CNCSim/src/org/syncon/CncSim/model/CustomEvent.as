package org.syncon.CncSim.model
{
	import flash.events.Event;
	/**
	 * General event class than has a custom payload
	 * */
	public class CustomEvent extends Event
	{
		
		public var data: Object;
		
		public function CustomEvent(type:String, _data:Object = null, bubbles : Boolean = true)
		{
			data = _data;
			super(type,  bubbles, true );
		}
	 
	}
}