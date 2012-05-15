package  org.syncon.Customizer.view.ui.components
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.Customizer.controller.EditProductCommandTriggerEvent;
	import org.syncon.Customizer.model.CustomEvent;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon.Customizer.vo.FontVO;
	import org.syncon.Customizer.vo.ItemRendererHelpers;
	import org.syncon.Customizer.vo.LayerBaseVO;
	import org.syncon.Customizer.vo.TextLayerVO;
	import org.syncon.Customizer.view.ui.smallComponents.FontDropDownItemRenderer;
	
	public class  PanelEngraveMediator extends Mediator 
	{
		[Inject] public var ui : PanelEngrave;
		[Inject] public var model : NightStandModel;
		private var dictFonts:Dictionary;
		
		override public function onRegister():void
		{
			/*this.ui.addEventListener( engrave_panel.ADD_TEXT,  this.onAddText);	
			this.ui.addEventListener( MainMenuBar.ADD_IMAGE,  this.onAddImage);	
			this.ui.addEventListener( MainMenuBar.UNDO,  this.onUndo);	
			this.ui.addEventListener( MainMenuBar.REDO,  this.onRedo);	
			
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.UNDOS_CHANGED, 
			this.checkUndoButtons);	
			this.checkUndoButtons(); 
			*/
			/*
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.BASE_ITEM_CHANGED, 
			this.onLoadLocations);	
			this.onLoadLocations(); */
			
			this.ui.addEventListener( PanelEngrave.CHANGED_TEXT, 
				this.onTextChanged );	
			
			this.ui.addEventListener( PanelText.DATA_CHANGED, 
				this.onDataChanged );	
			onDataChanged(null)
			this.ui.addEventListener( FontDropDownItemRenderer.GET_FONT_FAMILY_FOR, 
				this.onGetFontFamilyFor );			
			
			
			
			this.ui.addEventListener( PanelText.CHANGE_FONT_FAMILY, 
				this.onFontChanged );	
			//onFontChanged(null)
		}
		
		protected function onTextChanged(event:Event):void
		{
			/*
			this.layer.text = this.ui.txt.text; 
			this.updateLayer(); 
			*/
			
			var e : EditProductCommandTriggerEvent = new EditProductCommandTriggerEvent(
				EditProductCommandTriggerEvent.CHANGE_TEXT, this.ui.txt.text, 
				this.layer ) 
			e.fxPost = this.updateLayer;
			this.dispatch( e )
				; 
		}
		
		public function updateLayer() : void
		{
			//update price
			//adjust font size if necessary 
			//transform display text if necessary 
			this.layer.setFontSize(); 
			this.layer.adjustDisplayText()
			this.model.calculateProductPrice();
			
			this.layer.update(); 
		}
		
		public var layer : TextLayerVO = new TextLayerVO(); 
		private function onFontChanged(event: CustomEvent):void
		{
			var font : FontVO= event.data as FontVO
			var fontName : String = font.name; 
			if ( font.swf_name != null && font.swf_name != '' ) 
				fontName = font.swf_name; 
			/*
			this.dispatch( new EditProductCommandTriggerEvent ( 
			EditProductCommandTriggerEvent.CHANGE_FONT_FAMILY, fontName 
			) )  
			*/
			this.ui.txt.setStyle('fontFamily', fontName ) ; 
			this.ui.dropDown_FontSelect.setStyle('fontFamily', fontName ) ; 
			
			this.dispatch( new EditProductCommandTriggerEvent ( 
				EditProductCommandTriggerEvent.CHANGE_FONT_FAMILY_PRODUCT, fontName 
			) )  
		}
		public function onGetFontFamilyFor(e:CustomEvent):void
		{
			var font : FontVO= dictFonts[e.data] as FontVO
			var fontName : String = font.name; 
			if ( font.swf_name != null && font.swf_name != '' ) 
				fontName = font.swf_name; 
			
			if ( fontName != null )
			{
				e.preventDefault()
				e.data = fontName
				e.stopPropagation()
			}
			
		}
		
		public var s : ItemRendererHelpers = new ItemRendererHelpers(null)
		protected function onDataChanged(event:Event):void
		{
			layer = this.ui.layer as TextLayerVO
			s.listenForObj( layer, LayerBaseVO.UPDATED, this.onUpdatedLayer ) ; //we have to 
			//do this so we can catch it the first time ...  it if was not set initially 
			this.updateFontList(); 
			
			this.dictFonts = new Dictionary(true)
			for each ( var font : FontVO in layer.fonts ) 
			{
				dictFonts[font.name] = font
			}
			if ( this.layer.fontFamily != '' || this.layer.fontFamily != null ) 
			{
				this.ui.txt.setStyle('fontFamily', this.layer.fontFamily ) ;
				this.ui.dropDown_FontSelect.setStyle('fontFamily', this.layer.fontFamily ) ;
			}
		}
		
		private function onUpdatedLayer(e:Event=null):void
		{
			if ( layer == null ) 
				return; 
			
			if ( this.layer.propChanged == 'fontFamily' )
			{
				this.updateFontList(); 
			}
		}
		
		private function updateFontList():void
		{
			var fonts : Array = this.ui.layer.fonts; 
			//y do this 
			//this.ui.dropDown_FontSelect.labelFunction = this.labelForDropDown; 
			this.ui.dropDown_FontSelect.labelField = 'name' ; 
			this.ui.dropDown_FontSelect.dataProvider = new ArrayList( fonts ) ; 
			var foundFound : FontVO; 
			for each ( var f : FontVO in fonts ) 
			{
				if ( f.name ==  this.ui.layer.fontFamily )
				{
					foundFound = f; 	
				}
				if ( f.swf_name != null && f.swf_name ==  this.ui.layer.fontFamily )
				{
					foundFound = f; 	
				}
				
			}
			this.ui.dropDown_FontSelect.selectedItem = foundFound; //this.ui.layer.fontFamily; 
			
		}
		
		public function labelForDropDown( f : FontVO ) :  String
		{
			return f.name; 
		}
		/*
		private function onLoadLocations(e:Event=null):void
		{
		this.ui.list.dataProvider = new ArrayCollection( this.model.locations ) ; 
		
		}*/
		
		/*	
		protected function onRedo(event:Event):void
		{
		// TODO Auto-generated method stub
		var op : IOperation = this.model.undo.popRedo()
		op.performRedo()
		this.model.undo.pushUndo( op ) ; 
		//this.model.undo.redo(); 
		this.checkUndoButtons()
		}
		
		protected function onUndo(event:Event):void
		{
		// TODO Auto-generated method stub
		//	this.model.undo.undo()
		var op : IOperation = this.model.undo.popUndo()
		op.performUndo()
		this.model.undo.pushRedo( op ) ; 
		this.checkUndoButtons()
		}
		
		private function checkUndoButtons(e:Event=null):void
		{
		var dbg : Array = [this.model.undo.canUndo()] 
		//this.ui.btnRedo.enabled = this.model.undo.canRedo() 
		this.ui.btnUndo.enabled = this.model.undo.canUndo() 
		}
		
		private function onAddText(e:  CustomEvent): void
		{
		var obj : Object = e.data
		this.dispatch( new EditProductCommandTriggerEvent (
		EditProductCommandTriggerEvent.ADD_TEXT_LAYER, e) ) ; 
		}		
		
		private function onAddImage(e:  CustomEvent): void
		{
		var obj : Object = e.data
		var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
		'PopupPickImage', [this.onPickedImage], 'done' ) 		
		this.dispatch( event_ ) 
		}		
		
		private function onPickedImage( e : ImageVO ) : void
		{
		this.dispatch( new EditProductCommandTriggerEvent (
		EditProductCommandTriggerEvent.ADD_IMAGE_LAYER, e.url) ) ; 
		}
		*/
	}
}