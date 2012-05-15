package  org.syncon.Customizer.vo
{
	import mx.collections.ArrayCollection;
	
	import org.syncon.onenote.onenotehelpers.base.IPageVO;

	/**
	 * 
	 * Contains information to setup this product
	 * */
	public class StoreItemVO  //implements  IPageVO
	{
		public var name :  String = '';
		public var desc :  String = '';
		public var faces : ArrayCollection = new ArrayCollection();
		
		/**
		 * Import fonts for text layers for all faces, can override on face or textlayer level
		 * */
		[Transient] public var  fonts : Array;// = []; 
		/*
		
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
		
		
		
		private var  _lists  :  ArrayCollection  = new ArrayCollection();
		public var color_overlay_layer:Object;
		public var layers:Array = [];
		[Transient]
		public function get lists():ArrayCollection
		{
			return _lists;
		}
		
		public function set lists(value:ArrayCollection):void
		{
			_lists = value;
		}
		*/
		public var price:Number=0;
		public var sku:String;
		public var grand_total:Number;
		/**
		 * price of all the layers that have been configuredd
		 * */
		public var totalConfiguredPrice:Number;
		
		public function export() : void
		{
			
		}
		
	}
}