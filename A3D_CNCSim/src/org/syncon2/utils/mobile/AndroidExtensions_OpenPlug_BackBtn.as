//@terrypaton1//
//@xavivives//

package org.syncon2.utils.mobile
{
	
	
	/**
	 * Same as original, no ports 
	 * */
	public class AndroidExtensions_OpenPlug_BackBtn
	{
		
  
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function register( ): void
		{	
/*			asContext = ctxt; 
			asObject = thiz; 	*/
		}
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function register1( s : String ): void
		{	
			/*			asContext = ctxt; 
			asObject = thiz; 	*/
		}
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function register2( s : String ): void
		{	
			/*		 what is fix here? will notfire 	*/
		}
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function quit( ): void
		{	
		}
		
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function volumeUp( ): void
		{	
		}
		
		
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function volumeDown( ): void
		{	
		}
		
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function getVolume( ): void
		{	
		}
		
		public var callback : Function; 
		public function set backKeyPressed(value:Boolean):void 
		{
			trace('in flex', 'backPressed')
		}
		
		public function set keyPressed(value: int):void 
		{
			trace('in flex', 'keyPressed')
			if ( this.callback != null ) 
			{
				this.callback( value ) 
			}
		}
	}
}