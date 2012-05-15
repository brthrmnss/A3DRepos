package org.syncon.CncSim.view.ui.old
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.view.ui.old.LayersList;
	import org.syncon.CncSim.vo.LayerBaseVO;
	
	public class LayersListMediator extends Mediator 
	{
		[Inject] public var ui : LayersList;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.LAYERS_CHANGED, 
				this.onLayersChanged );	
			onLayersChanged(null)
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LAYER_CHANGED, 
				this.onLayerChanged);	
			this.onLayerChanged( null ) 
			this.ui.addEventListener( LayersList.CHANGE_LIST, this.onSelectLayer ) 
		}
		
		private function onLayersChanged(e:NightStandModelEvent):void
		{
			if ( this.ui.list.dataProvider != this.model.layersVisible ) 
				this.ui.list.dataProvider = this.model.layersVisible; 
		}
		
		/**
		 * do not try to select locked layers which will not be here
		 * */
		
		
		private function onLayerChanged(e: NightStandModelEvent): void
		{
			if ( this.model.currentLayer == null ) 
			{
				this.ui.list.selectedIndex = -1;
				return
			}
			if ( this.model.currentLayer.showInList == false ) 
				return; 
			if ( this.ui.list.selectedItem == this.model.currentLayer ) 
				return; 
			this.ui.list.selectedItem = this.model.currentLayer;
			var i : int = this.ui.list.dataProvider.getItemIndex( this.model.currentLayer ); 
			if ( i == -1 ) 
				throw 'how this happen?, why did you select this? if not in list?';
			this.ui.list.selectedIndex = i ; 
		}		
		
		public function onSelectLayer ( e : CustomEvent ) : void
		{
			this.model.currentLayer = e.data as LayerBaseVO;
			this.ui.list.selectedItem = this.model.currentLayer
			//this.model.objectHandles.selectionManager.setSelected( this.model.currentLayer.model ) ; 
		}
		
	}
}