package org.syncon.onenote.onenotehelpers.base  
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import spark.components.supportClasses.ItemRenderer;
	import spark.components.supportClasses.ListBase;
	
	public class QMultipleSelectionEvent extends Event
	{
		public static const SELECTED:String = 'MS_selected';
		public static const SELECTING:String = 'MS_selecting';		
		
		public var data: Object;
		public static var DRAG_START:String = 'MS_DRAG_START';
		public static var DRAG_END:String = 'MS_DRAG_END';
		public function QMultipleSelectionEvent(type:String, _data:Object = null)
		{
			super(type,true);
			data = _data;
		}
		
	}
}