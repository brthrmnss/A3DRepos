package org.syncon.Customizer.view.ui
{
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;
	
	import flash.events.EventDispatcher;

	
	/** 
	 * This is an example and not part of the core ObjectHandles library. 
	 **/

	public class SimpleDataModel extends EventDispatcher implements IResizeable, IMoveable
	{
		[Bindable] public var x:Number = 10;
		[Bindable] public var y:Number  = 10;
		[Bindable] public var height:Number = 50;
		[Bindable] public var width:Number = 50;
		[Bindable] public var rotation:Number = 0;
		[Bindable] public var isLocked:Boolean = false;
	}
}