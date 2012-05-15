package org.syncon.onenote.onenotehelpers.impl   
{
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import org.syncon.onenote.onenotehelpers.base.IPageVO;
	
	
	
	[RemoteClass(alias="PageVO")]
	public class PageVO  implements  IPageVO
	{
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
		
		public var name : String = '';
		[Bindable] public var description : String = '';
		[Transient] [Bindable] public var selected : Boolean = false; 
		public var section_id : int = 0;
		public var notebook_id : int = 0 ;
		
		/*  
		public function clone() :        CategoryVO  
		{ 
		var ee :    ShelpersObjs
		var q : CategoryVO = new CategoryVO(); q =   ShelpersObjs.clone(q, this ) as CategoryVO
		return q
		} 		
		*/
		
		
		 private var  _lists  :  ArrayCollection  = new ArrayCollection();
		 [Transient]
		 public function get lists():ArrayCollection
		 {
			 return _lists;
		 }
		 
		 public function set lists(value:ArrayCollection):void
		 {
			 _lists = value;
		 }
		
		[Transient] public var layout : Canvas; //  : has_many;
		
		public function export()  : Object
		{
			var exported : Object = {}
			exported.name = this.name; 
			return exported; 
		}
		
		
		public function import2(o:Object)  :  void
		{
			this.name = o.name; 
		}				
		
	}
}