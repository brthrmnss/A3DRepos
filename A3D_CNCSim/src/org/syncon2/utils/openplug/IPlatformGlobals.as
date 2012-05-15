package  org.syncon2.utils.openplug
{
	import flash.events.Event;
	
	
	public interface IPlatformGlobals  
	{
		//function set ELIPS ( b : Boolean ) : void
		function get  ELIPS (   ) :  Boolean
		
		//function set flex ( b : Boolean ) : void
		function get  flex (   ) :  Boolean
			/**
			 * On phone or on computer? 
			 * */
		function get  onComputer (   ) :  Boolean
		
		function addPlatformClickEvent(ui : Object, fx : Function ) : void
		function removePlatformClickEvent(ui : Object, fx : Function ) : void
			
		function addPlatformDownEvent(ui : Object, fx : Function ) : void
		function removePlatformDownEvent(ui : Object, fx : Function ) : void
			
		function addPlatformUpEvent(ui : Object, fx : Function ) : void
		function removePlatformUpEvent(ui : Object, fx : Function ) : void
			
		function addPlatformListClickEvent(ui : Object, fx : Function ) : void
		function  removePlatformListClickEvent(ui : Object, fx : Function ) : void
		
		function getItemClickEventData( e : Event ) : Object
		function setFxMediate( f : Function ) : void
		function fxMediate( io : Object ) : void
		function show ( msg : String, title : String='' ) : void
		function setListSelectedIndex ( list :  Object, row : Number, section : Number =-1 ) : void
		function setListScrollPosition ( list : Object, row : Number, section : Number =-1 ) : void
		
			
		function addChkboxClickEvent(ui : Object, fx : Function ) : void
		function removeChkboxClickEvent(ui : Object, fx : Function ) : void
		function chkboxSelected(ui : Object   ) : Boolean
		function chkboxSelect(ui : Object , val : Boolean  ) : void
	}
}