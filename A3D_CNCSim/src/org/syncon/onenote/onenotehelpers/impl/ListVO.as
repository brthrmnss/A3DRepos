package org.syncon.onenote.onenotehelpers.impl   
{
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	
	import org.syncon.onenote.onenotehelpers.base.IListVO;
	
	public class ListVO implements  IListVO
	{
		public var id : int;
		private var _name : String = ''; 
		private var _x : Number; 
		private var _y : Number;	 
		private var _height : Number; 
		private var _width : Number;
		
		private var _loadedIntoLister : Object; 
		private var  _data  :  Object  = new Object();
		
		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		/**
		 * Storage of lister list is being loaded into ... temp ... use dictionary 
		 * */
		public function get loadedIntoLister():Object
		{
			return _loadedIntoLister;
		}

		/**
		 * @private
		 */
		public function set loadedIntoLister(value:Object):void
		{
			_loadedIntoLister = value;
		}

		[Transient]
		public function get data(): Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function set height ( h : Number ) : void
		{
			if ( h < 100 ) 
			{
				trace('small ehight set', 'ListVO' ) ; 
			}
			this._height = h; 
		}
		public function get  height () : Number 
		{
			return this._height  
		}		

		
		/**
		 * cipped dp, temp storage
		 * */
		public var clipped : Array = []
		
		static public function makeRandom (count : int) : ArrayCollection
		{
			var i:int;
			var arr:Array = [];
			for (i=0; i<count; i++) {
				var le : ListEntryVO = new ListEntryVO()
					le.contents = "Item #" + i ;
					for ( var x : int = 0; x < Math.random()*100; x++)
					{
					le.contents += "Item #" + i ;
					}
				arr.push( le);
			}
			return  new ArrayCollection(arr);
		}
		
		static public function make1 (count : int=1) : ArrayCollection
		{
			var i:int;
			var arr:Array = [];
			for (i=0; i<count; i++) {
				var le : ListEntryVO = new ListEntryVO()
				le.contents = "Item #" + i ;
				arr.push( le);
			}
			return  new ArrayCollection(arr);
		}
		
		
	}
}