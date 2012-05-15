package org.syncon.Customizer.view.ui.components.debug
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.Customizer.controller.EditProductCommandTriggerEvent;
	import org.syncon.Customizer.model.CustomEvent;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon.Customizer.model.NightStandModelEvent;
	import org.syncon.Customizer.model.ViridConstants;
	import org.syncon.Customizer.vo.ImageLayerVO;
	import org.syncon.Customizer.vo.LayerBaseVO;
	
	public class UndoListMediator extends Mediator 
	{
		[Inject] public var ui :  UndoList;
		[Inject] public var model : NightStandModel;
		private var lastLayerRemoved:LayerBaseVO;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.LAYERS_CHANGED, 
				this.onLayersChanged );	
			onLayersChanged(null)
		/*	eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LAYER_CHANGED, 
				this.onLayerChanged);	
			this.onLayerChanged( null ) 
			this.ui.addEventListener( LayerList.CHANGE_LIST, this.onSelectLayer ) 
			this.ui.addEventListener( LayerList.REMOVE_LAYER, this.onRemoveLayer ) 
			this.calculateCost(); 
			*/
		/*	eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LAYER_CHANGED, 
				this.onCurrentLayerChanged);	
			this.onCurrentLayerChanged( null ) */
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.UNDOS_CHANGED, 
				this.onUndosChanged);	
		}
		
		private function onUndosChanged(e:Event):void
		{
			//this.ui.list.ensureIndexIsVisible( this.model.undoList.length-1 ) ;
			this.ui.list.scroller.verticalScrollBar.value = this.ui.list.dataGroup.contentHeight - this.ui.list.dataGroup.height;
		}		
		 
		private function onLayersChanged(e:NightStandModelEvent):void
		{
			if ( this.ui.list.dataProvider != this.model.undoList ) 
				this.ui.list.dataProvider = this.model.undoList; 
		}
		
	 
		
	}
}