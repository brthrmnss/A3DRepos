package org.syncon.Customizer.view.ui
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.Customizer.controller.EditProductCommandTriggerEvent;
	import org.syncon.Customizer.model.CustomEvent;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon.Customizer.view.ui.LayerInspector;
	import org.syncon.Customizer.vo.LayerBaseVO;
	import org.syncon.onenote.onenotehelpers.impl.layer_item_renderer;
	
	public class LayerTextInspectorMediator extends Mediator 
	{
		[Inject] public var ui : LayerTextInspector;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			this.ui.addEventListener( LayerTextInspector.CHANGE_FONT_SIZE, 
				this.onChangeFontSize);	
			this.ui.addEventListener( LayerTextInspector.CHANGE_COLOR, 
				this.onChangeColor);				
			this.ui.addEventListener( LayerTextInspector.CHANGE_FONT_FAMILY, 
				this.onChangeFontFamily);					
		}
		
		protected function onChangeFontSize(event:CustomEvent):void
		{
			this.dispatch( new EditProductCommandTriggerEvent ( 
				EditProductCommandTriggerEvent.CHANGE_FONT_SIZE, event.data 
			) )  
			/*		this.ui.layer.fontSize = int(  event.data ); 
			this.ui.layer.update('fontSize'); */
		}
		
		protected function onChangeColor(event:CustomEvent):void
		{
			this.dispatch( new EditProductCommandTriggerEvent ( 
				EditProductCommandTriggerEvent.CHANGE_COLOR, event.data 
			) )  
		}
		
		protected function onChangeFontFamily(event:CustomEvent):void
		{
			this.dispatch( new EditProductCommandTriggerEvent ( 
				EditProductCommandTriggerEvent.CHANGE_FONT_FAMILY, event.data 
			) )  
		}
		
		
		
		
		
	}
}