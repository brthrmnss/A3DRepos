package  org.syncon.Customizer.vo
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import org.syncon.Customizer.model.ViridConstants;
	import org.syncon.onenote.onenotehelpers.base.IPageVO;
	
	/**
	 * Face image
	 * */
	public class FaceVO  extends EventDispatcher  implements  IPageVO
	{
		
		public var name : String = ''; 
		/*	public var url : String  = ''; */
		public var description : String = ''; 
		
		/**
		 * Image to show in background 
		 * */
		public var base_image_url : String = ''; 
		
		/**
		 * Image to show with obscure color layer mask 
		 * */
		public var image_color_overlay : String = ''; 
		public var image_mask : String = ''; 
		
		public var more_info_url : String = ''; 
		
		
		public var limits : Object   = { };
		
		/**
		 * Import fonts for text layers
		 * */
		[Transient] public var  fonts : Array;// = []; 
		
		public var oldMinTextSize : Number; 
		public function updateFontSize(  newSize : Number ) : void
		{
			//when there is 1 layer, do not run this at all ... need a newer safer way...
			/*if ( this.layers.length == 1 ) 
			{
				for each (   l  in this.layers ) 
				{
					if ( l.subType == ViridConstants.SUBTYPE_ENGRAVE ) 
					{
						t  = l as TextLayerVO; 
						t.overrideFontSize = minT
						this.oldMinTextSize = minT
						t.fontSize = minT
						t.update('fontSize')
					}
				}
			}*/
			var minT : Number = newSize 
			//what is min size 
			for each ( var l : LayerBaseVO in this.layers ) 
			{
				if ( l.subType == ViridConstants.SUBTYPE_ENGRAVE ) 
				{
					var t  :TextLayerVO = l as TextLayerVO; 
					if ( t.text == '' ) //this will surpress 'hidden' layers ... which should be removed from import
						continue; 
					if (  isNaN(minT ) ||  t.fontSize < minT  )
					{
						minT = t.fontSize; 
					}
				}
			}
			
			
			if( minT != this.oldMinTextSize  ) 
			{
				for each (   l  in this.layers ) 
				{
					if ( l.subType == ViridConstants.SUBTYPE_ENGRAVE ) 
					{
						  t  = l as TextLayerVO; 
						t.overrideFontSize = minT
						this.oldMinTextSize = minT
						t.fontSize = minT
						t.update('fontSize')
					}
				}
			}
		
		//update if changed 
	}
	
	static public var UPDATED : String = 'updatedImaveVO'; 
	
	private var _layers : ArrayCollection = new ArrayCollection(); 
	[Transient]
	public function get layers():ArrayCollection
	{
		return _layers;
	}
	
	public function set layers(value:ArrayCollection):void
	{
		_layers = value;
	}
	
	
	
	private var _height : Number; 
	public function set height ( h : Number ) : void
	{
		this._height = h; 
	}
	public function get  height () : Number 
	{
		return this._height  
	}		
	
	private var _width : Number;
	public function get width():Number
	{
		return _width;
	}
	
	public function set width(value:Number):void
	{
		_width = value;
	}
	
	private var _scrollX :  Number = 0; 
	public function get scrollX():Number
	{ return _scrollX; }
	public function set scrollX(value:Number):void
	{ _scrollX = value; }
	
	private var _scrollY :  Number = 0; 		
	public function get scrollY():Number
	{ return _scrollY; }
	public function set scrollY(value:Number):void
	{ _scrollY = value; }
	
	
	
	//private var  _lists  :  ArrayCollection  = new ArrayCollection();
	public var color_overlay_layer:Object;
	//public var layers:Array = [];
	/**
	 * Stores layers that were loade via json 
	 * */
	public var layersToImport: Array ;//= null//[] ; ;
	
	/**
	 * Can the user remove the prompt layers included here? 
	 * */
	public var can_remove_prompt_layers:Boolean;
	public var image_mask_alpha:Number=0.1;
	
	/**
	 * had item been loaded before? 
	 * */
	public var imported:Boolean;
	public var price:Number;
	/**
	 * when importing will be selected first ...
	 * */
	[Transient] public var importFirstLayerSelection:LayerBaseVO;
	/**
	 * this layer is stored and reselected when switching faces
	 * */
	[Transient] public var currentLayer:LayerBaseVO;
	/**
	 * expects collective layer types 
	 * */
	public var collectiveLayerPrices: Array = [];
	/**
	 * Price of all the layer stha thave been configured
	 * */
	public var priceConfiguredLayers:int;
	[Transient]
	public function get lists():ArrayCollection
	{
		return _layers;
	}
	
	public function set lists(value:ArrayCollection):void
	{
		_layers = value;
	}
}
}