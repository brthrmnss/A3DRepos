package org.syncon2.utils.openplug.ui.comp.menu
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Atttach this to each view, to contrl menu options 
	 * */
	public class  BottomMenuConfigVO 
	{
		public var options : Array = [] ; 
		public var includeDefaultItems : Array = null ; 
		public var excludeDefaultItems : Array = null ; 
		public var fx : Function; // = []; 
		/**
		 * will update the valueon every item each time ...
		 * */
		public var radio:Boolean;
		public static var CHANGE_WIDTH: String = 'changeWidthOfItem';
		public static var SELECT:String= 'select';
		
		static public  function create(  labels : Array,icons : Array, fx : Function ) : BottomMenuConfigVO 
		{
			var m : BottomMenuConfigVO = new BottomMenuConfigVO(); 
			var opts : Array = []; 
			for   ( var  i : int = 0; i < labels.length ; i++ )// : String in labels )
			{
				var str : String = labels[i]  
				var icon : String = icons[i]  
				var item : BottomMenuItemVO = new BottomMenuItemVO
				item.label = str; 
				item.pic = icon; 
				item.parent = m;
				opts.push( item ) 
			}
			m.options = opts; 
			/*
			m.includeDefaultItems = includes
			m.excludeDefaultItems = exludes
			m.fx = fx*/
			return m ; 
		}
		
		public function process( dp : ArrayCollection, defaultItems : ArrayCollection ) : void
		{
			if ( this.options.length == 0 ) 
				return; 
			dp.disableAutoUpdate()
			dp.removeAll(); 
			for each ( var o : BottomMenuItemVO in this.options ) 
			{
				dp.addItem( o ) ; 
			}
			
			var blank :BottomMenuItemVO = new BottomMenuItemVO(); 
			blank.noAction = true; 
			dp.addItem( blank ) 
			
			for each ( var oitem :   Object in defaultItems.toArray() ) 
			{
				dp.addItem( oitem ) ; 
			}
			dp.enableAutoUpdate()
			
		}
		
		public function clicked(  item : BottomMenuItemVO ) : void
		{
			if ( this.options.length == 0 ) 
				return; 
			 
			for each ( var o : BottomMenuItemVO in this.options ) 
			{
				if ( radio ) 
				{
					o.update()
				}
			}
			
		 
			
		}
	}
}