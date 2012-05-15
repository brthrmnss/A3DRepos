package  org.syncon2.utils.openplug.ui.comp.settings
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.syncon.openplug.SBRip.vo.SearchItemVO;
	
	/**
	 * Atttach this to each view, to contrl menu options 
	 * */
	public class SettingMenuConfigVO 
	{
		public var options : Array = [] ; 
		public var includeDefaultItems : Array = null ; 
		public var excludeDefaultItems : Array = null ; 
		public var fx : Function; // = []; 
		/**
		 * will update the valueon every item each time ...
		 * */
		public var radio:Boolean;
		/**
		 * ditpached when help should be shown 
		 * */
		public static var HELP:String='help';
		public var fxCallWhenChanged:Function;
		
		static public  function create(  options : Array, fx : Function, 
										 includes :   Array=null, exludes : Array=null) : SettingMenuConfigVO 
		{
			var m : SettingMenuConfigVO = new SettingMenuConfigVO(); 
			var opts : Array = []; 
			for each ( var  str : String in options )
			{
				var item : SettingMenuItemVO = new SettingMenuItemVO
				item.label = str; 
				item.parent = m;
				opts.push( item ) 
			}
			m.options = opts; 
			m.includeDefaultItems = includes
			m.excludeDefaultItems = exludes
			m.fx = fx
			return m ; 
		}
		
		public function process( dp : ArrayCollection, defaultItems : ArrayCollection ) : void
		{
			if ( this.options.length == 0 ) 
				return; 
			dp.disableAutoUpdate()
			dp.removeAll(); 
			for each ( var o : SettingMenuItemVO in this.options ) 
			{
				dp.addItem( o ) ; 
			}
			
			var blank :SettingMenuItemVO = new SettingMenuItemVO(); 
			blank.noAction = true; 
			dp.addItem( blank ) 
			
			for each ( var oitem :   Object in defaultItems.toArray() ) 
			{
				dp.addItem( oitem ) ; 
			}
			dp.enableAutoUpdate()
			
		}
		
		public function clicked(  item : SettingMenuItemVO ) : void
		{
			if ( this.options.length == 0 ) 
				return; 
			 
			for each ( var o : SettingMenuItemVO in this.options ) 
			{
				if ( radio ) 
				{
					o.update()
				}
				if ( o.alwaysRefresh )
				{
					o.update(); 
				}
			}
			
		 	if ( fxCallWhenChanged != null ) 
				this.fxCallWhenChanged()
			
		}
		
		/**
		 * Replace the targeting object
		 * */
		public function updateObj(obj:Object):void
		{
			for each ( var o : SettingMenuItemVO in this.options ) 
			{
				o.obj = obj; 
			}
			for each (   o   in this.options ) 
			{
					o.update(); 
			}
		}
	}
}