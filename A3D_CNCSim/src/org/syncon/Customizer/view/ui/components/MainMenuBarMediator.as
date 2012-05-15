package  org.syncon.Customizer.view.ui.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.undo.IOperation;
	
	import mx.collections.ArrayList;
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.Customizer.controller.EditProductCommandTriggerEvent;
	import org.syncon.Customizer.controller.ExportJSONCommandTriggerEvent;
	import org.syncon.Customizer.model.CustomEvent;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon.Customizer.model.NightStandModelEvent;
	import org.syncon.Customizer.model.ViridConstants;
	import org.syncon.Customizer.view.ui.Toolbar;
	import org.syncon.Customizer.vo.ColorLayerVO;
	import org.syncon.Customizer.vo.ImageLayerVO;
	import org.syncon.Customizer.vo.ImageVO;
	import org.syncon.Customizer.vo.LayerBaseVO;
	import org.syncon.Customizer.vo.TextLayerVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class  MainMenuBarMediator extends Mediator 
	{
		[Inject] public var ui : MainMenuBar;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			this.ui.addEventListener( MainMenuBar.ADD_TEXT,  this.onAddText);	
			this.ui.addEventListener( MainMenuBar.ADD_IMAGE,  this.onAddImage);	
			this.ui.addEventListener( MainMenuBar.UNDO,  this.onUndo);	
			this.ui.addEventListener( MainMenuBar.REDO,  this.onRedo);	
			this.ui.addEventListener( MainMenuBar.EXPORTJSON, this.onJSONEXPORT);
			this.ui.addEventListener( MainMenuBar.GO_TO_BACKGROUND_PANEL, this.onGoToBackgroundPanel );
			
			this.ui.addEventListener( MainMenuBar.ON_PREVIEW, this.onPreview );
			
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.UNDOS_CHANGED, 
				this.checkUndoButtons);	
			this.checkUndoButtons(); 
			
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.UNDOS_CHANGED, 
				this.unselectSaveButtonBcProductChanged);	
			
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.FACE_CHANGED, 
				this.onFaceChanged);	
			this.onFaceChanged(); 
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.LAYERS_CHANGED, 
				this.onLayersChanged);	
			this.onLayersChanged(); 		
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.PRESENTATION_MODE_CHANGED, 
				this.onPresentationModeChanged);	
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LAYER_CHANGED, 
				this.onCurrentLayerChanged);	
			this.onCurrentLayerChanged( null ) 
		}
		
		
		
		public function onPreview(e:Event):void
		{
			this.model.previewMode = ! this.model.previewMode; 
			if ( this.model.previewMode ) 
			{
				this.ui.btnPreview.toolTip = "Leave Preview Mode"
					
				for ( var i : int = 0 ; i < this.ui.holderMainMenuBar.numElements ; i ++ ) 
				{
					var uic : UIComponent = this.ui.holderMainMenuBar.getChildAt( i ) as UIComponent; 
					if ( uic != this.ui.btnPreview ) 
					{
						uic.alpha = 0.6
						uic.enabled = false
					}
				}
				this.ui.callLater( this.ui.stage.addEventListener, [MouseEvent.CLICK, this.onClickStageDuringPreviewMode] )
				/*
				this.ui.stage.addEventListener(MouseEvent.CLICK, this.onClickStageDuringPreviewMode ) ; 
				*/
			}
			else
			{
				this.ui.btnPreview.toolTip = "Preview Design"
				this.ui.stage.removeEventListener(MouseEvent.CLICK, this.onClickStageDuringPreviewMode ) ; 
				for (   i  = 0 ; i < this.ui.holderMainMenuBar.numElements ; i ++ ) 
				{
					uic   = this.ui.holderMainMenuBar.getChildAt( i ) as UIComponent; 
					uic.alpha = 1
					uic.enabled = true
				}
			}
			
		}
		
		/**
		 * listens for stage to be clicked to leave preview mode
		 * */
		protected function onClickStageDuringPreviewMode(event:MouseEvent):void
		{
			this.onPreview(null); 
		}
		/**
		 * if currentLayer changed highlight the correct mainMenuButton
		 * */
		private function onCurrentLayerChanged(e:Event):void
		{
			if(this.ui.lastBtnSelected != null){
				this.ui.lastBtnSelected.selected = false;
			}
			var layer:LayerBaseVO = this.model.currentLayer; 
			if ( layer is TextLayerVO ) 
			{
				var txtLayer : TextLayerVO = layer as TextLayerVO; 
				if ( txtLayer.subType == ViridConstants.SUBTYPE_ENGRAVE ) 
				{
					this.ui.btnEngrave.selected = true;
					this.ui.lastBtnSelected = this.ui.btnEngrave;
				}
				else
				{
					this.ui.btnText.selected = true;
					this.ui.lastBtnSelected = this.ui.btnText;
				}
			}	
			if ( layer is ImageLayerVO )
			{
				this.ui.btnImage.selected = true;
				this.ui.lastBtnSelected = this.ui.btnImage;
			}
			if ( layer is ColorLayerVO ) 
			{
				this.ui.btnBackground.selected = true;
				this.ui.lastBtnSelected = this.ui.btnBackground;	
			}
			
			
		}
		
		/**
		 * if specific layer added ... do the thing ...
		 * */
		private function onLayersChanged(e:Event=null):void
		{
			this.rebuildMainMenuBar()
			
		}
		
		protected function onGoToBackgroundPanel(event:Event):void
		{
			var colorLayer : LayerBaseVO = this.model.getLayerByName( 'Color Layer'); 
			var layers : Array =  this.model.getLayersByType( ColorLayerVO  ) 
			if ( layers.length >  0 ) 
				colorLayer  = layers[0] as LayerBaseVO
			this.model.currentLayer = colorLayer 
			//this.ui.parentDocument.currentState = "normal" ;
		}
		protected function onGoToEngravePanel(event:Event):void
		{
			var engraveLayer : LayerBaseVO = this.model.getLayerByName( 'Color Layer'); 
			engraveLayer = this.model.getNextLayer(0, true, this.model.fxIsEngraveLayer ) ; 
			this.model.currentLayer = engraveLayer 
			//this.ui.parentDocument.currentState = "normal" ;
		}
		
		private function onPresentationModeChanged(e:Event):void
		{
			if ( this.model.previewMode ) 
			{
				
				
			}
			else
			{
				this.ui.btnPreview.selected = false;
				
			}
		}
		
		/**
		 * regieerate menu bar
		 * */
		private function onFaceChanged(e:Object=null):void
		{
			
			this.rebuildMainMenuBar()
		}
		
		private function rebuildMainMenuBar():void
		{
			// TODO Auto Generated method stub
			this.ui.btnText.includeInLayout = false; 
			this.ui.btnBackground.includeInLayout = false; 
			this.ui.btnImage.includeInLayout =  false;
			this.ui.btnEngrave.includeInLayout = false;
			this.ui.btnText.visible = false; 
			
			 
			this.ui.btnBackground.visible = false; 
			this.ui.btnImage.visible =  false;
			this.ui.btnEngrave.visible = false; 			
			//return
			var layers : Array = this.model.layersVisible.toArray()
			for ( var i : int =0 ; i < layers.length; i++ )
			{
				var layer : LayerBaseVO = layers[ i] as LayerBaseVO; 
				if ( this.model.fxIsEngraveLayer( layer ) ) 
				{
					this.ui.btnEngrave.includeInLayout = true; 
					this.ui.btnEngrave.visible = true; 
					continue; 
				}
				if ( layer.type == TextLayerVO.Type ) 
				{
					this.ui.btnText.includeInLayout = true; 
					this.ui.btnText.visible = true; 	
					continue; 
				}
				if ( layer.type == ImageLayerVO.Type  ) //&& subtype != null 
				{
					/*this.ui.btnBackground.includeInLayout = true; 
					this.ui.btnBackground.visible = true; 
					*/
					this.ui.btnImage.includeInLayout =  true; 
					this.ui.btnImage.visible =  true; 
					continue; 
				}
				if ( layer.type == ColorLayerVO.Type ) 
				{
					this.ui.btnBackground.includeInLayout = true; 
					this.ui.btnBackground.visible = true; 
					continue; 
				}
				
			}
			/**/
			var measureWdith : Number = 0 ; 
			var numVisibleElements : int = 0 ; 
			for (   i  = 0 ; i < this.ui.holderMainMenuBar.numElements ; i ++ ) 
			{
				var uic : UIComponent = this.ui.holderMainMenuBar.getChildAt( i ) as UIComponent; 
				if ( uic.includeInLayout ) 
				{
					measureWdith+=uic.width
					numVisibleElements++
				}
			}
			trace('width of buttons', measureWdith ) ; 
			
			var diff : Number = this.ui.width -measureWdith; 
			var newGap : Number = diff/numVisibleElements; 
			//newGap += 4+5+4
		//	if ( re
			//newGap -= 5
			newGap -= 2
			this.ui.holderMainMenuBar.gap = newGap; 
			//this.ui.holderMainMenuBar.gap = 0
			/**/
		}
		
		protected function onJSONEXPORT(event:Event):void
		{
			// TODO Auto-generated method stub
			var trgevent : ExportJSONCommandTriggerEvent = new ExportJSONCommandTriggerEvent(
				ExportJSONCommandTriggerEvent.EXPORT_JSON, '');
			this.dispatch(trgevent);
			//9-9-11: strange request, keep button on forever, until something is changed
			if(this.model.lastSaveSuccess)
			{
				this.ui.btnSave.selected = true; 
				this.model.notify('Product Saved', 'Notification'); 
			}
		}
		/**
		 * keep save highlted until they change something 
		 * ... what about when they select the other buttons: if a problem 
		 * make this a 'togglemode' button so it will not become curren tselected when clicked
		 * */
		protected function unselectSaveButtonBcProductChanged(event:Event):void
		{
			this.ui.btnSave.selected = false; 
		}
		
		protected function onRedo(event:Event):void
		{
			// TODO Auto-generated method stub
			if ( this.model.undo.canRedo() == false ) 
				return; 
			var op : IOperation = this.model.undo.popRedo()
			op.performRedo()
			this.model.undo.pushUndo( op ) ; 
			//this.model.undo.redo(); 
			this.checkUndoButtons()
		}
		
		protected function onUndo(event:Event):void
		{
			if ( this.model.undo.canUndo() == false ) 
				return; 
			var op : IOperation = this.model.undo.popUndo()
			op.performUndo()
			this.model.undo.pushRedo( op ) ; 
			var x : Object = this.model.undo.peekUndo()
			this.checkUndoButtons()
		}
		
		private function checkUndoButtons(e:Event=null):void
		{
			var dbg : Array = [this.model.undo.canUndo()] 
			var x : Object = this.model.undo.peekUndo()
			/*this.ui.btnRedo.enabled = this.model.undo.canRedo() */
			this.ui.btnUndo.enabled = this.model.undo.canUndo() 
			return;
		}
		
		private function onAddText(e:  Event): void
		{
			//blocked by default 
			var txtLayer  : TextLayerVO = this.model.getEmptyTextLayer();
			txtLayer = this.model.getATextLayer(); 
			//seems wrong to do this here , make intention ... 
			if(txtLayer != null){//m:added check to avoid nullrefrence
				txtLayer.visible = true
				txtLayer.update(); 
				
				this.model.currentLayer = txtLayer; 
				return; 
				/*var obj : Object = e.data
				this.dispatch( new EditProductCommandTriggerEvent (
					EditProductCommandTriggerEvent.ADD_TEXT_LAYER, e) ) ; */
			}
		}		
		
		private function onAddImage(e:  CustomEvent): void
		{
			if(this.model.currentLayer != null && this.model.currentLayer.type != ImageLayerVO.Type)
				this.model.currentLayer = null;
			
			this.dispatch(  new NightStandModelEvent( NightStandModelEvent.GO_TO_IMAGE_PANEL )  ) 
		}		
/*		
		private function onAddImage(e:  CustomEvent): void
		{
			var obj : Object = e.data
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupPickImage', [this.onPickedImage], 'showPopup' ) 		
			this.dispatch( event_ ) 
		}		
		
		private function onPickedImage( e : ImageVO ) : void
		{
			this.dispatch( new EditProductCommandTriggerEvent (
				EditProductCommandTriggerEvent.ADD_IMAGE_LAYER, e.url) ) ; 
		}*/
		
	}
}