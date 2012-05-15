//@terrypaton1//
//@xavivives//

package org.syncon2.utils.mobile
{
	
	
	/**
	 * Same as original, no ports 
	 * */
	public class AndroidExtensions_OpenPlug2
	{
		
		
		/**
		 * Quickly display error from this class ... very lazy, but convient 
		 * */
		static public var FxError : Function;  
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function currentVolume( ): Number
		{	
			return 0
		}
		
		/**
		 * Sent url of asset relative from top of apk file...
		 * */
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function volumeUp( ):void
		{
		}
		
		/**
		 * Sent url of asset relative from top of apk file...
		 * */
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function volumeDown():void
		{
		}
		 
		/**
		 * Sent url of asset relative from top of apk file...
		 * */
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function changeVolumeIntent():void
		{
			//http://stackoverflow.com/questions/623225/android-go-to-settings-screen
			//startActivityForResult(new Intent(android.provider.Settings.ACTION_SOUND_SETTINGS, 0);

			//http://stackoverflow.com/questions/4178989/android-development-change-media-volume
		}
		
		
		
	}
}