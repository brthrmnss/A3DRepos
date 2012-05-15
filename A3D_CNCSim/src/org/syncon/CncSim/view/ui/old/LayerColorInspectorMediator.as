package org.syncon.CncSim.view.ui.old
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.controller.EditProductCommandTriggerEvent;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	
	public class LayerColorInspectorMediator extends Mediator 
	{
		[Inject] public var ui : LayerColorInspector;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			
			this.ui.addEventListener( LayerColorInspector.CHANGE_COLOR, 
				this.onChangeColor);				
			
		}
		
		protected function onChangeColor(event:CustomEvent):void
		{
			this.dispatch( new EditProductCommandTriggerEvent ( 
				EditProductCommandTriggerEvent.CHANGE_COLOR, event.data 
			) )  
		}
		
	}
}