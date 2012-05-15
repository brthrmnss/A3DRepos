package org.syncon2.utils.openplug
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import openplug.elips.controls.List;
	
	public class PlatformGlobals_Flex implements IPlatformGlobals
	{
		
		public	function get ELIPS( ) : Boolean
		{
			return false; 
		}
		public	function get flex( ) : Boolean
		{
			return true; 
		}
		
		public function get  onComputer (   ) :  Boolean{
			return true; 
		}
		
		public function addPlatformClickEvent(ui : Object, fx : Function ) : void
		{
			ui.addEventListener(MouseEvent.CLICK, fx , false, 0, true )
		}
		public function removePlatformClickEvent(ui : Object, fx : Function ) : void
		{
			ui.removeEventListener(MouseEvent.CLICK, fx ) ;
		}
		
		public function addPlatformDownEvent(ui : Object, fx : Function ) : void
		{
			ui.addEventListener(MouseEvent.MOUSE_DOWN, fx , false, 0, true )
		}
		public function removePlatformDownEvent(ui : Object, fx : Function ) : void
		{
			ui.removeEventListener(MouseEvent.MOUSE_DOWN, fx ) ;
		}
		
		public function addPlatformUpEvent(ui : Object, fx : Function ) : void
		{
			ui.addEventListener(MouseEvent.MOUSE_UP, fx , false, 0, true )
		}
		public function removePlatformUpEvent(ui : Object, fx : Function ) : void
		{
			ui.removeEventListener(MouseEvent.MOUSE_UP, fx ) ;
		}
		
		public function addPlatformListClickEvent(ui : Object, fx : Function ) : void
		{
			ui.addEventListener(ListEvent.ITEM_CLICK, fx , false, 0, true )
		}
		public function removePlatformListClickEvent(ui : Object, fx : Function ) : void
		{
			ui.removeEventListener(ListEvent.ITEM_CLICK , fx ) ;
		}
		public function show( msg : String, title : String ='') : void
		{
			//have another close fx ...
			Alert.show( msg, title ); 
			//ui.removeEventListener(TouchEvent.TOUCH_TAP, fx ) ;
		}
		
		
		public function getItemClickEventData(event : Event ) : Object
		{
			var e :  ListEvent = event as ListEvent; 
			return e.itemRenderer.data; 
		}
		
		private var _fxMediate : Function;
		public function setFxMediate(fx  :  Function ) : void
		{
			this._fxMediate = fx; 
		}
		
		public function fxMediate(ui :  Object ) : void
		{
			this._fxMediate(ui)
		}
		
		public function setListSelectedIndex ( list : Object, row : Number, section : Number =-1 ) : void
		{
			list.selectedIndex = row; 
		}
		public	function setListScrollPosition ( list : Object, row : Number, section : Number =-1 ) : void
		{
			//list.horizontalScrollPosition = row; 
			list.scrollToIndex( row ) 
		}
		
		
		
		
		public function addChkboxClickEvent(ui : Object, fx : Function ) : void
		{
			ui.addEventListener(Event.CHANGE , fx, false, 0, true )
		}
		public function removeChkboxClickEvent(ui : Object, fx : Function ) : void
		{
			ui.removeEventListener(Event.CHANGE , fx ) ;
		}
		public function chkboxSelected(ui : Object   ) : Boolean
		{
			return ui.selected; 
		}
		public function chkboxSelect(ui : Object , val : Boolean ) : void
		{
			ui.selected = val
		}
		
	}
}