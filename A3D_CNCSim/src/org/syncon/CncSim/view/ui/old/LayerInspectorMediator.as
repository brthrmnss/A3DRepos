package org.syncon.CncSim.view.ui.old
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.view.ui.old.LayerInspector;
	import org.syncon.CncSim.vo.ProductVO;
	
	public class LayerInspectorMediator extends Mediator 
	{
		[Inject] public var ui : LayerInspector;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			this.ui.addEventListener( PriceList.UPDATE_JSON, 
				this.onUpdateJSON);	
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LAYER_CHANGED, 
				this.onLayersChanged);	
			this.onLayersChanged( null ) 
		}
		
		private function onLayersChanged(param0:Object):void
		{
			this.ui.layer = this.model.currentLayer; 
		}
		
		private function onUpdateJSON(e:  CustomEvent): void
		{
			 
			//var product :  ProductVO = e.data as ProductVO()
			//	product.name = 'foo'; 
		}		
		
		
		
	}
}