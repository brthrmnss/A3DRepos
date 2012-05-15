package  org.syncon.Customizer.view.ui.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.Customizer.controller.EditProductCommandTriggerEvent;
	import org.syncon.Customizer.model.CustomEvent;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon.Customizer.model.NightStandModelEvent;
	
	public class DesignViewMediator extends Mediator 
	{
		[Inject] public var ui : DesignView;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			/*eventMap.mapListener(eventDispatcher, NightStandModelEvent.BASE_ITEM_CHANGED, 
			this.onBaseItemChanged);	
			this.onBaseItemChanged( null ) 
			*/
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.FACE_CHANGED, 
				this.onFaceChanged);	
			this.onFaceChanged( null ) 
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.LAYERS_CHANGED, 
				this.onLayersChanged);				
			
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.PRESENTATION_MODE_CHANGED, 
				this.onPreviewModeChanged);	
			//wait until face is loaded so we can override th emask alpha 
			//face changed is distapched before the view has loadeded it 
			eventMap.mapListener(eventDispatcher,EditProductCommandTriggerEvent.FACE_LOADED, 
				this.onFaceLoaded);	
			this.onFaceLoaded( null ) 
				
			this.model.viewer = this.ui.viewer22
			this.ui.viewer22.groupBg.visible = false; 
			this.ui.viewer22.bgBorder.alpha = 0; // = false; 
			this.ui.viewer22.scroller.addEventListener(MouseEvent.CLICK, this.onClickBg ) ; 
		}
		
		protected function onClickBg(event:MouseEvent):void
		{
			if ( event.target != this.ui.viewer22.workspace ) 
				return; 
			if ( this.model.allowSelectingBgToClearSelection == false ) 
				return; 
			this.model.objectHandles.selectionManager.clearSelection()
			//desleect from list ...
			this.model.currentLayer = null; 
		}
		
		private function onLayersChanged(e:Object):void
		{
			// TODO Auto Generated method stub
			//this.onBaseItemChanged(null); 
			this.ui.viewer22.controller.displayDp(); 
		}
		/*
		private function onBaseItemChanged(param0:Object):void
		{
		this.ui.viewer22.controller.dataProvider  = this.model.baseItem; 
		//this.ui.list.dataProvider = this.model.layers; 
		}
		*/
		private function onFaceChanged(param0:Object):void
		{
			//this.ui.viewer22.controller.dataProvider  = this.model.currentFace; 
			//this.ui.list.dataProvider = this.model.layers; 
		}
		
		/**
		 * wait until face is completely loaded, to ensure base layers are set ...
		 * */
		private function onFaceLoaded(e:Event):void
		{
			this.onPreviewModeChanged(); 
			this.ui.viewer22.controller.dataProvider  = this.model.currentFace; 
		}
		
		private var oldSelections :  Array = []
		private var oldMaskAlpha : Number ; 
		/**
		 * When IN preview mode ...
		 * */
		private function onPreviewModeChanged(e:Event=null):void
		{
			//unselect all 
			//remove background on engraves
			//mask opacity 100%
			if ( this.model.previewMode ) 
			{
				oldSelections  = this.model.objectHandles.selectionManager.currentlySelected
				this.model.objectHandles.selectionManager.clearSelection()
				if ( this.ui.viewer22.maskBg.alpha != 0 ) 
					this.oldMaskAlpha = this.ui.viewer22.maskBg.alpha  
				this.ui.viewer22.maskBg.alpha = 0.0
			}
			else
			{
				for each ( var o : Object in oldSelections ) 
				{
					this.model.objectHandles.selectionManager.setSelected( o )
				}
				if ( ! isNaN( this.oldMaskAlpha ) ) 
				this.ui.viewer22.maskBg.alpha = this.oldMaskAlpha 
			}
		}
		
	}
}