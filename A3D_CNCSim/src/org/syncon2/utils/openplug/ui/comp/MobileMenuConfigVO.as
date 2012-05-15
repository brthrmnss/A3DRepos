package  org.syncon2.utils.openplug.ui.comp
{
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Atttach this to each view, to contrl menu options 
	 * */
	public class MobileMenuConfigVO 
	{
		public var options : Array = [] ; 
		public var includeDefaultItems : Array = null ; 
		public var excludeDefaultItems : Array = null ; 
		public var fx : Function; // = []; 
		
		static public  function create(  options : Array, fx : Function, 
										 includes :   Array=null, exludes : Array=null) : MobileMenuConfigVO 
		{
			var m : MobileMenuConfigVO = new MobileMenuConfigVO(); 
			var opts : Array = []; 
			for each ( var  str : String in options )
			{
				var item : MobileMenuItemVO = new MobileMenuItemVO
				item.label = str; 
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
			for each ( var o : MobileMenuItemVO in this.options ) 
			{
				dp.addItem( o ) ; 
			}
			
			var blank :MobileMenuItemVO = new MobileMenuItemVO(); 
			blank.noAction = true; 
			dp.addItem( blank ) 
			
			for each ( var oitem :   Object in defaultItems.toArray() ) 
			{
				dp.addItem( oitem ) ; 
			}
			dp.enableAutoUpdate()
			
		}
		
	}
}