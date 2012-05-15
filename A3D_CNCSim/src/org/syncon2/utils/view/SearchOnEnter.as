package org.syncon2.utils.view
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.core.UIComponent;
	/**
	 make flex textfields respond to enter key without using forms 
	 */
	public class SearchOnEnter
	{
		private var ui : UIComponent;
		private var onlyRespondTo:Object;
		/**
		 * setup event listered 
		 * @param ui
		 * @param fx
		 * @param onlyRespondToTextField - recommend, if you want to limit responses
		 * 
		 */
		public function SearchOnEnter(ui_:UIComponent, fx:Function, onlyRespondToTextField:Object = null)
		{
			this.fx = fx
			this.onlyRespondTo = onlyRespondToTextField
			this.ui = ui_
			this.ui.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDown, false, 0, true)
		}
		
		public function refresh(ui_:UIComponent, fx:Function, onlyRespondToTextField:Object = null) : void
		{
			this.fx = fx
			this.onlyRespondTo = onlyRespondToTextField
			ui.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDown ); //, false, 0, true)
			this.ui = ui_
			this.ui.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDown, false, 0, true)			
			
		}		
		
		private var fx:Function;
		
		public function keyDown(e:KeyboardEvent): void
		{
			var ee:Keyboard
			var ui:UIComponent = e.currentTarget as UIComponent
			
			if (onlyRespondTo != null && ui != null)
			{
				var focus:Object = ui.getFocus()
				
				if (ui != this.onlyRespondTo)
					return;
			}
			
			//maybe check for focus ???
			if (e.keyCode == Keyboard.ENTER)
			{
				this.fx()
			}
			return;
		}
	}
}