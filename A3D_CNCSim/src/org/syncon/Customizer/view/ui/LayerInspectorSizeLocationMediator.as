package org.syncon.Customizer.view.ui
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.Customizer.model.CustomEvent;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon.Customizer.view.ui.LayerInspector;
	import org.syncon.Customizer.vo.LayerBaseVO;
	import org.syncon.onenote.onenotehelpers.impl.layer_item_renderer;
	
	public class LayerInspectorSizeLocationMediator extends Mediator 
	{
		[Inject] public var ui : LayerInspectorSizeLocation;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			this.ui.addEventListener( LayerInspectorSizeLocation.CHANGED_POSITION, 
				this.onChangedPosition);	
			this.ui.addEventListener( LayerInspectorSizeLocation.CHANGED_SIZE, 
				this.onChangedSize);				
		}
		
		protected function onChangedPosition(event:Event):void
		{
			this.ui.layer.x = this.ui.txtX as Number ; 
			this.ui.layer.y = this.ui.txtY as Number ; 		
			
			this.ui.layer.update(); 
		}
		
		protected function onChangedSize(event:Event):void
		{
			this.ui.layer.height = this.ui.txtHeight as Number ; 
			this.ui.layer.width = this.ui.txtWidth as Number ; 			
			
			this.ui.layer.update(); 
		}
		
 		 
		
	}
}