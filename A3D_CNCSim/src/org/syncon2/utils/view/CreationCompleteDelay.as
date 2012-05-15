package org.syncon2.utils.view
{
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	/**
	 make flex textfields respond to enter key without using forms 
	 */
	public class CreationCompleteDelay
	{
		private var ui : UIComponent;
 
		public function CreationCompleteDelay(ui_:Object =null)
		{
			this.ui = ui_ as UIComponent
			this.ui.addEventListener(FlexEvent.CREATION_COMPLETE , this.onCreationComplete ) ; //.KEY_DOWN, this.keyDown, false, 0, true)
		}
		
		public function testI( prop : String, val : Object ) : Boolean
		{
			if ( this.creationComplete ) 
			{
				return false; 				
			}
			this.props.push( [prop, val ]  ) 
			return true 
		}		
		
		private var creationComplete:Boolean;
		private var props:Array=[];
		
		public function onCreationComplete(e:Event): void
		{
			this.creationComplete = true
				this.release(); 
		}
		
		
		public function release(  ) : void
		{
			/*if ( this.creationComplete ) 
			{
				return false; 				
			}*/
			for each ( var prop : Array in this.props ) 
			{
				this.ui[prop[0]] = prop[1]
			}
			
		}		
		
	}
}