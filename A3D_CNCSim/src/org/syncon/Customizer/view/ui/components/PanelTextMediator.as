package org.syncon.Customizer.view.ui.components
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.Customizer.controller.EditProductCommandTriggerEvent;
	import org.syncon.Customizer.model.CustomEvent;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon.Customizer.view.ui.LayerInspector;
	import org.syncon.Customizer.vo.FontVO;
	import org.syncon.Customizer.vo.LayerBaseVO;
	import org.syncon.Customizer.vo.TextLayerVO;
	import org.syncon.onenote.onenotehelpers.impl.layer_item_renderer;
	import org.syncon.Customizer.view.ui.smallComponents.FontDropDownItemRenderer;
	
	public class PanelTextMediator extends Mediator 
	{
		[Inject] public var ui : PanelText;
		[Inject] public var model : NightStandModel;
		private var dictFonts:Dictionary;
		
		override public function onRegister():void
		{
			
			this.ui.addEventListener( PanelText.CHANGE_FONT_SIZE, 
				this.onChangeFontSize); 
			this.ui.addEventListener( PanelText.CHANGE_COLOR, 
				this.onChangeColor);				
			this.ui.addEventListener( PanelText.CHANGE_FONT_FAMILY, 
				this.onChangeFontFamily);	
			this.ui.addEventListener( PanelText.CHANGE_TEXT_ALIGN, 
				this.onChangeTextAlign);	
			this.ui.addEventListener( PanelText.CHANGED_TEXT, 
				this.onChangeText );	
			this.ui.addEventListener( PanelText.DATA_CHANGED, 
				this.onDataChanged );	
			onDataChanged(null)
			
			this.ui.addEventListener( FontDropDownItemRenderer.GET_FONT_FAMILY_FOR, 
				this.onGetFontFamilyFor );				
			/*this.ui.dropDown_FontSelect.skin.addEventListener( FontDropDownItemRenderer.GET_FONT_FAMILY_FOR, 
				this.onGetFontFamilyFor );	*/	
		}
		
		protected function onDataChanged(event:Event):void
		{
			this.ui.txt.prompt = this.layer.default_text; 
			this.onChangeText(null); 
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
		
		public function get layer () : TextLayerVO 
		{
			return this.ui.layer; 
		}
		protected function onChangeText(event:Event):void
		{
			/*	if ( this.layer.text == '' && this.layer.default_text!= ''  ) 
			{*/
			
			/*		}*/
			
			if ( this.layer.displayText == this.ui.txt.text ) 
				return; //invalid, this happens because change event is occuring when i set the font back? 
			
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
			if ( this.layer.propChanged == 'fontFamily' )
			{
				this.updateFontList(); 
			}
			this.layer.update(); 
			
		}
		
		
		/**
		 * if check box selected, go to the left
		 * */
		protected function onChangeTextAlign(event:CustomEvent):void
		{
			if ( event.data ==  false ) 
			{
				this.dispatch( new EditProductCommandTriggerEvent ( 
					EditProductCommandTriggerEvent.CHANGE_TEXT_ALIGN, 'left' 
				) )  
			}
			else
			{
				this.dispatch( new EditProductCommandTriggerEvent ( 
					EditProductCommandTriggerEvent.CHANGE_TEXT_ALIGN, 'right' 
				) )  
			}
		}
		
		protected function onChangeFontSize(event:CustomEvent):void
		{
			//surpress duplicates on on commit 
			if ( this.layer.fontSize == event.data ) 
				return; 
			this.dispatch( new EditProductCommandTriggerEvent ( 
				EditProductCommandTriggerEvent.CHANGE_FONT_SIZE, event.data 
			) )  
			/*		this.ui.layer.fontSize = int(  event.data ); 
			this.ui.layer.update('fontSize'); */
		}
		
		protected function onChangeColor(event:CustomEvent):void
		{
			this.dispatch( new EditProductCommandTriggerEvent ( 
				EditProductCommandTriggerEvent.CHANGE_COLOR, event.data 
			) )  
		}
		
		protected function onChangeFontFamily(event:CustomEvent):void
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
				EditProductCommandTriggerEvent.CHANGE_FONT_FAMILY,fontName
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
			}
			
		}
		
		
		/**
		 * go through select fonts, case insensitive and make matches
		 * */
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
				if ( f.name.toLowerCase() ==  this.ui.layer.fontFamily.toLowerCase() )
				{
					foundFound = f; 	
				}
				if ( f.swf_name != null && f.swf_name.toLowerCase() ==  this.ui.layer.fontFamily.toLowerCase() )
				{
					foundFound = f; 	
				}
				
			}
			this.ui.dropDown_FontSelect.selectedItem = foundFound; //this.ui.layer.fontFamily; 
			
			if ( this.model.fxIsEngraveLayer( this.layer ) ) 
			{
				this.ui.fontSize.includeInLayout = false; 
				//this.ui.fontSelect.width = this.holderDropdown.width; 
			}
			else
			{
				//this.ui.fontSelect.width = this.holderDropdown.width - 50 - 10; 
				this.ui.fontSize.selectedItem  = this.layer.fontSize; 
				this.ui.fontSize.includeInLayout = true; 
			}
			//hide font row if no fonts ... can't b/c of size issue
			/*this.ui.rowFonts.visible = true; 
			if ( fonts.length == 0 ) 
			{
			this.ui.rowFonts.visible = false; 
			}*/
		}
		
		
		
	}
}