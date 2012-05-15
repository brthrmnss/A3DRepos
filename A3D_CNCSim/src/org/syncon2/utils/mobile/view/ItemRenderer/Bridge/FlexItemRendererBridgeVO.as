package org.syncon2.utils.mobile.view.ItemRenderer.Bridge
{
	import flash.events.Event;
	
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	
	import spark.components.List;

	public class FlexItemRendererBridgeVO  
	{
		
		private var ui:Object;
		public function test() : void
		{
			
		}
		
		/**
		 * listen for added to stage, or setup now if possible 
		 * */
		public function setupStageListeners(e:Event=null, ui : Object = null , callAtEndFx_ : Function = null ):void
		{
			if ( ui != null ) 
					this.ui = ui ;
			if ( callAtEndFx_ != null ) 
			this.callAtEndFx = callAtEndFx_
			if ( this.ui.stage == null ) 
			{
				this.ui.addEventListener(Event.ADDED_TO_STAGE, this.setupStageListeners, false, 0, true ) ; 
				return
			}
			this.ui.removeEventListener(Event.ADDED_TO_STAGE, this.setupStageListeners )
			this.ui.addEventListener(Event.REMOVED_FROM_STAGE, this.removeStageListeners, false, 0, true ) ; 
			//this.ui.stage.addEventListener('orientationChange', this.stageOrientationChange,false, 0, true ) ;
			//stageOrientationChange(null)
		}
		
		private var  callAtEndFx : Function
		
		private function removeStageListeners(e:Event=null):void
		{
			this.ui.stage.removeEventListener(Event.REMOVED_FROM_STAGE, this.removeStageListeners )
			//this.ui.stage.removeEventListener('orientationChange', this.stageOrientationChange  ) ; 
		}
		
 
		
		private var oldClass :  IFactory; 
		/**
		 * Warning requires a data property 
		 * */
		public function onSetupIR(e: Object ) : void
		{
			e.stopImmediatePropagation(); 
			e.data = oldClass ; 
		}
		
		
		public function init(enable : Boolean, ui : UIComponent, list:List):void
		{
			if ( enable == false )
			{
				return; 
			}
			this.ui = ui; 
			this.oldClass =  list.itemRenderer
			ui.addEventListener( FlexMobileItemRendererBridge.SETUP, this.onSetupIR ) ; 
			this.ui.addEventListener(Event.REMOVED_FROM_STAGE, this.removeStageListeners, false, 0, true ) 
			var clas : ClassFactory = new ClassFactory(FlexMobileItemRendererBridge )
			list.itemRenderer = clas
		}
	}
}