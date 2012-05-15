package org.syncon.Customizer.view.ui
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.Customizer.controller.EditProductCommandTriggerEvent;
	import org.syncon.Customizer.model.CustomEvent;
	import org.syncon.Customizer.model.NightStandModel;
	
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