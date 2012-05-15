package  org.syncon2.utils.services.utils
{
	import flash.events.Event;

	public class ServiceBlocker  
	{
		public function blockIfNotFxFalse( fxToEnableBlocking : Function, allowEventOfType  : Array, retryTimeMs : Number, 
					 maxRestries : int = -1 ):void
		{
			
		}
		
		/**
		 * if the event type is bloccked b/c fxToEnableBlocking return false, 
		 * will return true 
		 * 
		 * 
		 * */
		public function checkBlocking(eventType : String , fxExecute : Function) :  Boolean
		{
			//if in list return true
			if  ( true == false ) 
			{
				
			}
			return false; 
		}
		
		
		public function ifEventTypeInXAddToBlocking(   notifyTypes  : Array, fxAddEventTo : Function, fxRemoveEventFrom : Function ):void
		{
			
		}
		
		/**
		 * if the event type is bloccked b/c fxToEnableBlocking return false, 
		 * will return true 
		 * 
		 * 
		 * */
		public function checkBlockingNotifyStart(event :  Event ) :  void
		{
			 //if in notify list add to add function 
		}
		public function checkBlockingNotifyDone(event :  Event ) :  void
		{
			//if in motify list, call remove function 
		}		
		
		
		
	}
}