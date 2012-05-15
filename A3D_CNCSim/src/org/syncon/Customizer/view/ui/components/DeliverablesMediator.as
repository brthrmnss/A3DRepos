package  org.syncon.Customizer.view.ui.components
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.Customizer.model.CustomEvent;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon.Customizer.model.NightStandModelEvent;
	import org.syncon.Customizer.view.apps.Deliverable;
	import org.syncon.Customizer.view.ui.LayerInspector;
	import org.syncon.Customizer.vo.ProductVO;
	
	public class DeliverablesMediator extends Mediator 
	{
		[Inject] public var ui : Deliverable;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			/*this.ui.addEventListener( PriceList.UPDATE_JSON, 
				this.onUpdateJSON);	*/
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LAYER_CHANGED, 
				this.onLayersChanged);	
			this.onLayersChanged( null ) 
				
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.PRESENTATION_MODE_CHANGED, 
				this.onPresentationModeChanged);	
			
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.GO_TO_IMAGE_PANEL, 
				this.onGoToImagePanel);	
			this.onGoToImagePanel( null ) 
			
				
		}
		
		private function onPresentationModeChanged(e:Event):void
		{
			if ( this.model.previewMode ) 
			{
				
				this.ui.panels.enabled = false; 
				this.ui.panels.alpha = 0.3
				//this.ui.transformationStage
				this.ui.layerList.enabled = false; 
				this.ui.layerList.alpha = 0.3
			}
			else
			{
				this.ui.panels.enabled = true; 
				this.ui.panels.alpha = 1
				//this.ui.transformationStage
				this.ui.layerList.enabled = true; 
				this.ui.layerList.alpha = 1

			}
		}
		
		private function onLayersChanged(param0:Object):void
		{
			if ( this.model.previewMode )
				return;
			if ( this.model.currentLayer == null ) 
			{
				this.ui.currentState = 'normal' 
				//this.ui.designPanel.hideImageOptions();//overkill
			}
			this.ui.layer = this.model.currentLayer; 
		}
		
		private function onGoToImagePanel(param0:Object):void
		{
			/*
			if ( this.model.previewMode )
				return;
			if ( this.model.currentLayer == null ) 
			{
				this.ui.currentState = 'normal' 
				//this.ui.designPanel.hideImageOptions();//overkill
			}
			this.ui.layer = this.model.currentLayer; 
			*/
			/*if ( this.model.previewMode )
				return;*/
			/*if ( this.model.currentLayer == null ) 
			{
				this.ui.currentState = 'normal' 
			}
			this.ui.layer = this.model.currentLayer; */
			this.ui.currentState = 'normal' 
			this.ui.designPanel.enableImagePanels(); 
		}
		
		
		
		private function onUpdateJSON(e:  CustomEvent): void
		{
			 
			//var product :  ProductVO = e.data as ProductVO()
			//	product.name = 'foo'; 
		}		
		
		
		
	}
}