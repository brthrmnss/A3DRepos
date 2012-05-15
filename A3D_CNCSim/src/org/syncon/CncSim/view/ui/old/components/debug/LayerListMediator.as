package org.syncon.CncSim.view.ui.old.components.debug
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.controller.EditProductCommandTriggerEvent;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.model.ViridConstants;
	import org.syncon.CncSim.vo.ImageLayerVO;
	import org.syncon.CncSim.vo.LayerBaseVO;
	
	public class LayerListMediator extends Mediator 
	{
		[Inject] public var ui :  LayerList;
		[Inject] public var model : NightStandModel;
		private var lastLayerRemoved:LayerBaseVO;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.LAYERS_CHANGED, 
				this.onLayersChanged );	
			onLayersChanged(null)
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LAYER_CHANGED, 
				this.onLayerChanged);	
			this.onLayerChanged( null ) 
			this.ui.addEventListener( LayerList.CHANGE_LIST, this.onSelectLayer ) 
			this.ui.addEventListener( LayerList.REMOVE_LAYER, this.onRemoveLayer ) 
			this.calculateCost(); 
			
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LAYER_CHANGED, 
				this.onCurrentLayerChanged);	
			this.onCurrentLayerChanged( null ) 
			
		}
		
		protected function onCurrentLayerChanged(e:NightStandModelEvent):void
		{
			this.ui.list.selectedItem = this.model.currentLayer;
			var i : int = this.ui.list.dataProvider.getItemIndex( this.model.currentLayer ); 
			/*if ( i == -1 ) 
			throw 'how this happen?, why did you select this? if not in list?';*/
			this.ui.list.selectedIndex = i ; 
			this.calculateCost(); 
			trace('clear layer' ) ;
			this.lastLayerRemoved = null; 
		}
		
		protected function onRemoveLayer(event:CustomEvent):void
		{
			var layer :  LayerBaseVO = event.data as LayerBaseVO
			this.lastLayerRemoved = layer; 
			this.dispatch( new EditProductCommandTriggerEvent (
				EditProductCommandTriggerEvent.REMOVE_LAYER, layer) ) ; 
			trace('remove layer', layer.name ) ; 
			this.calculateCost(); 
			
		}
		
		private function onLayersChanged(e:NightStandModelEvent):void
		{
			if ( this.ui.list.dataProvider != this.model.layers ) 
				this.ui.list.dataProvider = this.model.layers; 
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
			var name : String = this.model.currentLayer.name; 
			if ( i == -1 ) 
				throw 'how this happen?, why did you select this? if not in list?';
			this.ui.list.selectedIndex = i ; 
			this.calculateCost(); 
		}		
		
		/**
		 * Check if the last layer remove is this current layer, if so, 
		 * do not select it ...
		 * */
		public function onSelectLayer ( e : CustomEvent ) : void
		{
			var layer : LayerBaseVO = e.data as LayerBaseVO;
			
			if ( this.lastLayerRemoved == layer ) 
			{
				trace('show layer','wait',  layer.name ) 
				this.lastLayerRemoved = null; 
				return; 
			}
			
			//don't show empty image layers it is confusing for user 
			//if layer is empty show pick image popup instead .....
			//move this to a better place
			if ( layer is  ImageLayerVO )
			{
				var img : ImageLayerVO = layer as ImageLayerVO; 
				if ( img.url == '' || img.url == null ) 
				{
					if ( img.image_source == ViridConstants.IMAGE_SOURCE_CLIPART )
					{
					var event : Event = new NightStandModelEvent(
						NightStandModelEvent.SHOW_EMPTY_LAYER, img ) 
					this.dispatch(event ) ;
					if ( event.isDefaultPrevented() ) 
					{
						this.ui.list.selectedItem = null; 	//why set it to null?
						this.onCurrentLayerChanged(null); //reset to current layer for time being ...
						//preferablly switch to layer you're going too ... then switch back?
						return; 
					}
					}
					else if ( img.image_source == ViridConstants.IMAGE_SOURCE_UPLOAD )
					{
						  event   = new NightStandModelEvent(
							NightStandModelEvent.SHOW_EMPTY_LAYER, img ) 
						this.dispatch(event ) ;
						if ( event.isDefaultPrevented() ) 
						{
							this.ui.list.selectedItem = null; 	
							this.onCurrentLayerChanged(null); 
							return; 
						}
					}
				}
			}
			
			//auot select so it is visible ... 
			this.model.showLayer( layer ) ; 
			this.model.currentLayer = layer; 
			//this.ui.list.selectedItem = this.model.currentLayer //redundant
			trace('show layer', layer.name ) ; 
			this.calculateCost(); 
		}
		
		private function calculateCost():void
		{
			var total : Number = 0
			total += this.model.baseItem.price; 
			for each ( var l : LayerBaseVO in this.model.layersVisible.toArray() )  
			{
				if ( l.visible ) 
				{
					total += l.cost; 
				}
			}
			
			this.ui.txtCost.text = '$'+total.toFixed(2); 
			//this.model.currentFace.configured_price = total; 
		}
		
	}
}