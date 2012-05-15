package  org.syncon.CncSim.vo
{
	public class TextLayerVO  extends  LayerBaseVO
	{
		
		static public const PROP_TEXT_ALIGN : String = 'PROP_TEXT_ALIGN' ; 
		static public const PROP_VERTICAL_TEXT_ALIGN : String = 'PROP_VERTICAL_TEXT_ALIGN'; 
		/**
		 * when the text is changed ...
		 * */
		static public const PROP_UPDATED_TEXT : String = 'PROP_UPDATED_TEXT'; 
		public var text : String = ''; 
		
		public static var Type:String= 'TEX';
		private var _fontSize:int = 12;
		
		public function get fontSize():int
		{
			return _fontSize;
		}
		
		public function set fontSize(value:int):void
		{
			/*if  ( this.currentFace != null ) 
			{
				this.currentFace.updateFontSize( value )
			}
			if ( !  isNaN(this.overrideFontSize ) ) 
				value = this.overrideFontSize
					//update('fontSize'); 
				*/	
					
			_fontSize = value;
		}
		
		public var fontFamily : String;// = ''; 
		public var color:*;
		public var sizingSettings: String;
		/**
		 * maxChars must be set for this to work.
		 * */
		public static var SIZING_AUTO_SIZE: String = 'sizingAuto';
		public var maxChars: int = -1 ;
		public var minFontSize: Number = -1 ;
		public var maxFontSize: Number = -1 ;
		public var default_text:String= 'Add Text';
		//public var orientation:String ="Horizontal";
		[Transient] public var  fonts : Array = []; 
		
		public function incrementFontSize (  ww : Number, hh : Number, fontSizeT : Number ) : void
		{
			if ( this.locked == false ) 
				return; 
			if ( this.sizingSettings == TextLayerVO.SIZING_AUTO_SIZE ) 
			{
				if ( this.text == '' ) 
				{
					fontSize = this.maxFontSize; 
					update('fontSize'); 
					this.checkSizeOnAllLayers(); 
					return;
				}
				if ( this.verticalText == false ) 
				{
					trace('font size', fontSizeT, ww, hh ) ; 
					if ( ww*1.1 > this.width ) 
					{
						trace('down font'); 
						fontSize =fontSizeT-1
						ratio  = ww /width
						ratio =  Math.round( ratio )
						if (ratio > 1 ) 
						{
							if ( fontSize-(ratio*ratio*2 ) > this.minFontSize ) 
								fontSize =fontSize-(ratio*ratio*2 )
						}							
						fontSize = Math.max( fontSize, this.minFontSize )
						update('fontSize'); 
					}
					else
					{
						//if great than 75%, it's within margin of error
						if ( ww >= this.width*.75 ) 
						{
							this.checkSizeOnAllLayers(); 
							return; 
						}
						trace('up font'); 
						fontSize =fontSizeT+1
						//smudge
						var ratio :  Number =  width / ww; 
						ratio =  Math.round( ratio )
						if ( ratio > 1 ) 
						{
							fontSize =fontSize+(ratio*ratio)
						}
						fontSize = Math.min( fontSize, this.maxFontSize )
							if ( fontSize == this.maxFontSize ) 
							{
								this.checkSizeOnAllLayers(); 
							}
						update('fontSize'); 
					}
				}
				
				
				if ( this.verticalText == true ) 
				{
					trace('font size', fontSizeT, ww, hh ) ; 
					if ( hh*1.1 > this.height ) 
					{
						trace('down font'); 
						fontSize =fontSizeT-1
						ratio  = hh /height
						ratio =  Math.round( ratio )
						if (ratio > 1 ) 
						{
							fontSize =fontSize-(ratio*ratio*2 )
						}							
						fontSize = Math.max( fontSize, this.minFontSize )
						update('fontSize'); 
					}
					else
					{
						//if great than 75%, it's within margin of error
						if ( hh >= this.height*.75 ) 
						{
							this.checkSizeOnAllLayers()
							return; 
						}
						trace('up font'); 
						fontSize =fontSizeT+1
						//smudge
						var ratio :  Number =  height / hh; 
						ratio =  Math.round( ratio )
						if ( ratio > 1 ) 
						{
							fontSize =fontSize+(ratio*ratio)
						}
						fontSize = Math.min( fontSize, this.maxFontSize )
						if ( fontSize == this.maxFontSize ) 
						{
							this.checkSizeOnAllLayers(); 
						}
						update('fontSize'); 
					}
				}
			}
		}
		
		private function checkSizeOnAllLayers():void
		{
			if  ( this.currentFace != null ) 
			{
				this.currentFace.updateFontSize( this.fontSize )
			}
			/*
			if ( !  isNaN(this.overrideFontSize ) ) 
				value = this.overrideFontSize
					//update('fontSize'); 
			*/		
		}
		
		/**
		 * if set, set layers to this size .... 
		 * */
		public var overrideFontSize : Number 
		
		/**
		 * Adjusts the font size based on autosizing option
		 * offBy, how much larger is this text than what it is supposed to be?
		 * */
		public function setFontSize ( offBy : Number = 0) : void
		{
			if ( this.sizingSettings == TextLayerVO.SIZING_AUTO_SIZE ) 
			{
				if ( offBy == 0  ) 
					return; 
				
				//offBy = Math.floor( offBy*100 ) /100
				newFontSize = this.maxFontSize * offBy 
				newFontSize = Math.max(newFontSize, this.minFontSize ) ; 
				newFontSize2 = int( newFontSize ); 
				if ( fontSize ==  newFontSize2   )
					return; 
				fontSize =newFontSize2
				/*if ( !  isNaN(this.overrideFontSize ) ) 
				fontSize = this.overrideFontSize*/
				update('fontSize'); 
				
				
				/*this.currentFace.updateFontSize( this )*/
			}
			
			if ( this.sizingSettings == TextLayerVO.SIZING_AUTO_SIZE && 7==9 ) 
			{
				if ( this.maxChars <= 0 ) 
					throw 'Max Chars for layer "' + this.name + '" is too small: ' + this.maxChars
				if ( this.maxChars <  this.text.length  ) 
					throw 'Text input for layer "' + this.name + '" is too large: ' + this.text +
						' ' + this.maxChars + ' check import settings ' ;						
				var steps :  Number =( this.maxFontSize - this.minFontSize)/this.maxChars; 
				var dbg : Array = [this.maxFontSize - this.minFontSize, this.maxFontSize, this.minFontSize]
				var charCount : int = this.text.length; 
				var newFontSize : Number = this.maxFontSize - charCount*steps
				/*this.dispatch( new EditProductCommandTriggerEvent ( 
				EditProductCommandTriggerEvent.CHANGE_FONT_SIZE, newFontSize 
				) )  */
				var newFontSize2 : int = int( newFontSize ); 
				if ( fontSize ==  newFontSize2   )
					return; 
				if ( newFontSize2  <= 0 ) 
					throw 'Font Size for layer  ' + this.name + ' is too small: ' + this.fontSize
				fontSize =newFontSize2
				update('fontSize'); 
			}
		}
		
		//static public const PROP_HORIZ_TEXT_ALIGN_ : String = 'PROP_TEXT_ALIGN' ; 
		//static public const PROP_TEXT_ALIGN : String = 'PROP_TEXT_ALIGN' ; 
		public var horizontalTextAlignment : String = 'center'; 
		public var verticalTextAlignment : String = 'middle'; 
		
		public var verticalText : Boolean = false; 
		private var _displayText : String = ''; 
		
		/**
		 * Thsi is the setting that the textinput uses to show text ... 
		 * */
		public function get displayText():String
		{
			return _displayText;
		}
		
		/**
		 * @private
		 */
		public function set displayText(value:String):void
		{
			_displayText = value;
		}
		
		
		public function adjustDisplayText () : void
		{
			if ( this.verticalText )
			{
				var newText: String = ''; 
				for ( var i : int= 0; i < this.text.length ; i++ )
				{
					var char :  String = this.text.charAt( i ) 
					newText += char 
					if ( i != this.text.length -1 )
					{
						newText += '\n'
					}
				}
				this.displayText =  newText
				//
			}
			else
			{
				this.displayText = this.text; 
			}
			
		}
		
		
		public override function  get type():String
		{
			return Type;
		}
		
		override public function get displayName():String
		{
			if ( this.nameHidden != null && this.visible == false ) 
				return this.nameHidden
			return [this.name , '(', this.text, ')' ].join(' ');
		}
		
		
		override  public function clone() : LayerBaseVO
		{
			var textLayer : TextLayerVO = new TextLayerVO()
			this.copyPropsTo(textLayer)  
			textLayer.text = this.text; 
			textLayer.fontSize = this.fontSize
			textLayer.fontFamily = this.fontFamily
			textLayer.color = this.color
			textLayer.sizingSettings = this.sizingSettings
			textLayer.maxChars = this.maxChars
			textLayer.minFontSize = this.minFontSize
			textLayer.maxFontSize = this.maxFontSize
			textLayer.default_text = this.default_text
			//textLayer.orientation = this.orientation
			textLayer.verticalText = this.verticalText; 
			textLayer.verticalTextAlignment = verticalTextAlignment; 
			textLayer.horizontalTextAlignment = horizontalTextAlignment; 
			textLayer.displayText = this.displayText
			textLayer.fonts = this.fonts
			return textLayer; 
		}
	}
}