package  org.syncon2.utils.openplug
{
	import flash.events.Event;
	
	
	public class ElipsBugs  
	{
		 
		public function MathFloorIsWrong( ) : void
		{
			trace( Math.floor( -.001 ) ); 
			trace( Math.floor( -1.001 ) ); 
			trace( Math.floor( .001 ) ); 
			trace( Math.floor( 1.001 ) ); 
		}
	}
}