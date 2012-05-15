package  org.syncon.Customizer.vo
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import spark.components.ViewMenuItem;
	
	
	public class MenuItemsVO 
	{
		//[ StageOrientation.DEFAULT, StageOrientation.UNKNOWN, StageOrientation.UPSIDE_DOWN]
		/**
		 * stores reference to viewmenuitem for flex safe complitation 
		 * set at startup 
		 * */
		//static public    var ItemClass: Class;
		private var ui:Object;
		private var dict: Dictionary = new Dictionary(true); ;
		private var fxCall:Function;
		
		public function test() : void
		{
			
		}
		
		/**
		 * listen for added to stage, or setup now if possible 
		 * */
		public function init( buttons : Array , ui : Object = null , callAtEndFx_ : Function = null ):void
		{
			var items : Vector.<ViewMenuItem> = new Vector.<ViewMenuItem>
			//var items : Array = []; 
			for each ( var o : Array in buttons ) 
			{
				var btn :   ViewMenuItem = new ViewMenuItem()
					btn.percentWidth = 100
				btn.label = o[0]
				dict[btn]=o[1]
				btn.addEventListener(MouseEvent.CLICK, this.onClick, false, 0, true ) 
				items.push( btn ) ; 
			}
			
			ui.viewMenuItems = items; 
			
		}
		
		
		
		public function initSimple( buttons : Array , ui : Object = null , callAtEndFx_ : Function = null ):void
		{
			var items : Vector.<ViewMenuItem> = new Vector.<ViewMenuItem>
			//var items : Array = []; 
			for each ( var lbl : String in buttons ) 
			{
				var btn :   ViewMenuItem = new ViewMenuItem()
				btn.label = lbl
				btn.addEventListener(MouseEvent.CLICK, this.onClick, false, 0, true ) 
				items.push( btn ) ; 
			}
			
			ui.viewMenuItems = items; 
			fxCall = callAtEndFx_
		}
		
		
		protected function onClick(event: MouseEvent):void
		{
			if ( fxCall != null )
			{
				fxCall( event.currentTarget.label ) 
					return; 
			}
			var fx : Function = this.dict[event.currentTarget] 
			try {
				if ( fx != null ) fx()
			}
			catch ( e : Error ) 
			{
				if ( fx != null ) fx(event)
			}
		}
		
	}
}