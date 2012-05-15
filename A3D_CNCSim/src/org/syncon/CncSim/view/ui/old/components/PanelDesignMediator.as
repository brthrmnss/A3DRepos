package  org.syncon.CncSim.view.ui.old.components
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.controller.EditProductCommandTriggerEvent;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.model.ViridConstants;
	import org.syncon.CncSim.vo.ColorLayerVO;
	import org.syncon.CncSim.vo.ImageLayerVO;
	import org.syncon.CncSim.vo.ImageVO;
	import org.syncon.CncSim.vo.LayerBaseVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class  PanelDesignMediator extends Mediator 
	{
		[Inject] public var ui : PanelDesign;
		[Inject] public var model : NightStandModel;
		/**
		 * will not allow creation of new layers.... weill resuse prompt layers
		 * */
		private var inViridMode:Boolean=true;
		private var loadIntoAndSelectImageLayer:ImageLayerVO;
		
		override public function onRegister():void
		{
			this.ui.addEventListener( PanelDesign.ADD_IMAGE,  this.onAddClipArtImage);	
			this.ui.addEventListener( PanelDesign.ADD_UPLOAD_IMAGE,  this.onAddUploadImage);	
			this.ui.addEventListener( PanelDesign.CHANGE_COLOR,  this.onChangeColor);			
			
			this.ui.addEventListener( PanelDesign.CLICKED_DISABLED_BG_PANEL, onGoToColorLayerFromDisabled ) 
			this.ui.addEventListener( PanelDesign.CLICKED_DISABLED_IMAGE_PANEL, onGoToImageUploadLayerFromDisabled ) 
			this.ui.addEventListener( PanelDesign.CLICKED_DISABLED_CLIPART_PANEL, onGoToClipartLayerFromDisabled ) 
				
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.SHOW_EMPTY_LAYER, 
				this.onShowingNullLayer);	
			
			
			eventMap.mapListener(eventDispatcher,  EditProductCommandTriggerEvent.IMAGE_URL_CHANGED,
				this.onUpdateLayerNamesToMatchClipArtName);	
			
			//set default color if defined ... do not make na undo fo rthis ....
			this.model.blockUndoAdding = true; 
			this.setColorFromLayer(); 
			this.model.blockUndoAdding = false; 
		}
		
		private function onUpdateLayerNamesToMatchClipArtName(e:EditProductCommandTriggerEvent):void
		{
			var layer : ImageLayerVO = e.data2 as  ImageLayerVO; 
			var newName : String = this.model.convertClipArtToName( layer.url ) 
			
			if ( newName == '' )
				return
			
			if ( newName != layer.name ) 
			{
				layer.name = newName /*+ ' Clipart'*/; 
				layer.update(); 
			}
			
		}
		
		//use Object b/c uint does not like null...
		protected function onChangeColor(event:CustomEvent, color_ :  Object = null ):void
		{
			if ( color_ ==null ) 
				var color : uint = uint(event.data ) 
			else
				color = uint(color_ )
			var colorLayerName :  String =  'Mask'; 
			colorLayerName =  'Color Layer';
			this.dispatch( new EditProductCommandTriggerEvent (
				EditProductCommandTriggerEvent.CHANGE_LAYER_COLOR,color, colorLayerName ) ) ; 
		}
		/**
		 * normally this layer would be pullsed down intially ..., 
		 * but UI is out of sync on startup 
		 * */
		protected function setColorFromLayer(  ):void
		{
			//this.onChangeColor(null, this.ui.getSelectedColor ) ;
			var colorLayerName :  String =  'Mask'; 
			colorLayerName =  'Color Layer';
			var colorLayer : ColorLayerVO = this.model.getLayerByName( colorLayerName ) as ColorLayerVO
			if(colorLayer == null)return;
			this.ui.selectedColorSwatch.color = colorLayer.color
			
		}
		
		protected function onAddUploadImage(e:CustomEvent):void
		{
			/*
			//select first clip art image
			if ( this.model.currentLayer.subType != ViridConstants.IMAGE_SOURCE_UPLOAD ) 
			{
			var imgLayer : ImageLayerVO = this.model.getEmptyImageLayer( ViridConstants.IMAGE_SOURCE_UPLOAD )
			if ( imgLayer  == null ) 
			return; 
			this.model.currentLayer = imgLayer; 
			}
			*/
			/*	var obj : Object = e.data
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
			'PopupPickImage', [this.onPickedImage], 'done' ) 		
			this.dispatch( event_ ) */
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP,
				'PopupUploadImage', [onUploadedImage], 'showPopup' ) 		
			this.dispatch( event_ ) 
		}
		/**
		 * for teh virid player we will have to resuse existing layers if they are definied 
		 * */
		private function onUploadedImage(  bytes : ByteArray  ) : void
		{
			if ( this.loadIntoAndSelectImageLayer  != null ) 
			{
				this.model.showLayer( loadIntoAndSelectImageLayer  ); 
				this.model.currentLayer =   this.loadIntoAndSelectImageLayer ;// != null ) ; 
				this.loadIntoAndSelectImageLayer = null; 
			}
			
			var currentLayer :  LayerBaseVO = this.model.currentLayer; 
			if ( inViridMode ) 
			{
				//rather than create a new layer, use one of the prompts 
				if (currentLayer == null ||  currentLayer.type != ImageLayerVO.Type || currentLayer.subType != ViridConstants.IMAGE_SOURCE_UPLOAD) 
				{
					var imgLayer  : ImageLayerVO = this.model.getEmptyImageLayer(ViridConstants.IMAGE_SOURCE_UPLOAD)
					//seems wrong to do this here , make intention ... 
					imgLayer.visible = true
					imgLayer.update(); 
					currentLayer = imgLayer;
					this.model.currentLayer = imgLayer; 
				}
				if ( currentLayer.visible == false ) 
				{
					currentLayer.visible = true
					currentLayer.update(); 
					currentLayer.updateVisibility();
				}
			}
			
			//reset the resizing parameters so the image is resized to fit the product in the center again ....
			this.model.currentLayer.repositionedOnce = false
			this.model.currentLayer.horizStartAlignment = LayerBaseVO.ALIGNMENT_CENTER
			this.model.currentLayer.vertStartAlignment = LayerBaseVO.ALIGNMENT_CENTER
			this.resetCurrentLayer() ; 
			
			//upload to me,  if i am current layer 
			if (  this.ui.layer == this.model.currentLayer ) 
			{
				this.dispatch( new EditProductCommandTriggerEvent (
					EditProductCommandTriggerEvent.CHANGE_IMAGE_URL,  null, bytes  ) ) ; 
				this.model.calculateProductPrice();
				return; 
			}
			//add to new layer 
			this.dispatch( new EditProductCommandTriggerEvent (
				EditProductCommandTriggerEvent.ADD_IMAGE_LAYER, null, bytes ) ) ;
			this.model.calculateProductPrice();
		}
		private function onAddText(e:  CustomEvent): void
		{
			var obj : Object = e.data
			this.dispatch( new EditProductCommandTriggerEvent (
				EditProductCommandTriggerEvent.ADD_TEXT_LAYER, e) ) ; 
		}		
		
		private function onAddClipArtImage(e:  CustomEvent): void
		{
			/*
			//select first clip art image
			if ( this.model.currentLayer.subType != ViridConstants.IMAGE_SOURCE_CLIPART ) 
			{
			var imgLayer : ImageLayerVO = this.model.getEmptyImageLayer( ViridConstants.IMAGE_SOURCE_CLIPART )
			if ( imgLayer  == null ) 
			return; 
			this.model.currentLayer = imgLayer; 
			}
			*/
			//var obj : Object = e.data
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupPickImage', [this.onPickedImage], 'showPopup' ) 		
			this.dispatch( event_ ) 
		}		
		
		/**
		 * for teh virid player we will have to resuse existing layers if they are definied 
		 * */
		private function onPickedImage( e : ImageVO ) : void
		{
			
			if ( this.loadIntoAndSelectImageLayer  != null ) 
			{
				this.model.showLayer( loadIntoAndSelectImageLayer  ); 
				this.model.currentLayer =   this.loadIntoAndSelectImageLayer ;// != null ) ; 
				this.loadIntoAndSelectImageLayer = null; 
			}
			
			var currentLayer :  LayerBaseVO = this.model.currentLayer; 
			
			
			
			if ( inViridMode ) 
			{
				//rather than create a new layer, use one of the prompts 
				if (currentLayer == null ||  currentLayer.type != ImageLayerVO.Type  || currentLayer.subType != ViridConstants.IMAGE_SOURCE_CLIPART ) 
				{
					var imgLayer  : ImageLayerVO = this.model.getEmptyImageLayer(ViridConstants.IMAGE_SOURCE_CLIPART)
					//seems wrong to do this here , make intention ... 
					imgLayer.visible = true
					imgLayer.update(); 
					imgLayer.updateVisibility();
					this.model.currentLayer = imgLayer; 
					currentLayer = this.model.currentLayer
				}
				if ( currentLayer.visible == false ) 
				{
					currentLayer.visible = true
					currentLayer.update(); 
					currentLayer.updateVisibility();
				}
			}
			
			
			//reset the resizing parameters so the image is resized to fit the product in the center again ....
			this.model.currentLayer.repositionedOnce = false
			this.model.currentLayer.horizStartAlignment = LayerBaseVO.ALIGNMENT_CENTER
			this.model.currentLayer.vertStartAlignment = LayerBaseVO.ALIGNMENT_CENTER
			
			this.resetCurrentLayer() ; 
			//if a prompt layer, change the source, do not add a new one 
			//08-29-11 ,even if it ws not a prompt layer you would still not add a new one ..
			// reuse what ever is loaded if it is valid
			//if ( this.model.currentLayer.prompt_layer && this.ui.layer == this.model.currentLayer ) 
			if (  this.ui.layer == this.model.currentLayer ) 
			{
				this.dispatch( new EditProductCommandTriggerEvent (
					EditProductCommandTriggerEvent.CHANGE_IMAGE_URL, e.url) ) ; 
				this.model.calculateProductPrice()
				return; 
			}
			this.dispatch( new EditProductCommandTriggerEvent (
				EditProductCommandTriggerEvent.ADD_IMAGE_LAYER, e.url) ) ;
			this.model.calculateProductPrice()
		}
		/**
		 * set all properties back to initial state so it stayes in teh center
		 * */
		private function resetCurrentLayer():void
		{
			this.model.currentLayer.x = 0   ;
			this.model.currentLayer.y = 0; 
			this.model.currentLayer.rotation = 0 ; 
		}		
		
		public function onShowingNullLayer( e : NightStandModelEvent ) : void
		{
			//09/16/11 .. do not show poups to add images ..
			return
			var layer : LayerBaseVO = e.data as LayerBaseVO; 
			if ( layer is ImageLayerVO ) 
			{
				var imgLayer : ImageLayerVO = layer as ImageLayerVO
			}
			if ( imgLayer == null ) 
				return; 
			
			e.preventDefault(); 
			
			this.loadIntoAndSelectImageLayer = imgLayer; 
			if ( imgLayer.image_source == ViridConstants.IMAGE_SOURCE_CLIPART )
			{
				this.onAddClipArtImage(null)
			}
			else if ( imgLayer.image_source == ViridConstants.IMAGE_SOURCE_UPLOAD )
			{
				this.onAddUploadImage(null)
			}
			
		}
		
		
		public function onGoToColorLayerFromDisabled( e : Event ) : void
		{
			var colorLayer : LayerBaseVO = this.model.getLayerByName( 'Color Layer'); 
			var layers : Array =  this.model.getLayersByType2( ColorLayerVO.Type  ) 
			if ( layers.length >  0 ) 
				colorLayer  = layers[0] as LayerBaseVO
			this.model.currentLayer = colorLayer 
		}
		
		public function onGoToImageUploadLayerFromDisabled( e : Event ) : void
		{
			var layers : Array =  this.model.getLayersByType2( ImageLayerVO.Type, 
				ViridConstants.IMAGE_SOURCE_UPLOAD  ) 
			if ( layers.length >  0 ) 
			{
				var selectLayer: LayerBaseVO  = layers[0] as LayerBaseVO
				this.model.currentLayer = selectLayer 
			}
		}
		
		public function onGoToClipartLayerFromDisabled( e : Event ) : void
		{
			var layers : Array =  this.model.getLayersByType2( ImageLayerVO.Type,
				ViridConstants.IMAGE_SOURCE_CLIPART  ) 
			if ( layers.length >  0 ) 
			{
				var selectLayer  : LayerBaseVO = layers[0] as LayerBaseVO
				this.model.currentLayer = selectLayer 
			}
		}
		
		
		
		
		
	}
}