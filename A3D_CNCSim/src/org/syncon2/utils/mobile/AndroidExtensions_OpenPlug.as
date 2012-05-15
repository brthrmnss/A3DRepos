//@terrypaton1//
//@xavivives//

package org.syncon2.utils.mobile
{
	
	
	/**
	 * Same as original, no ports 
	 * */
	public class AndroidExtensions_OpenPlug
	{
		
		 
		/**
		 * Quickly display error from this class ... very lazy, but convient 
		 * */
		static public var FxError : Function;  
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function setRingtone(url:String):void
		{		
		}
		
		/**
		 * Sent url of asset relative from top of apk file...
		 * */
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function setNotification(url:String):void
		{
		}
		
		/**
		 * Sent url of asset relative from top of apk file...
		 * */
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function setAlarm(url:String):void
		{
		}
		
		/**
		 * Sent url of asset relative from top of apk file...
		 * */
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function goToStore(query:String='', pub:String=''):void
		{
		}
		
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function rateApp(apppackage:String):void
		{
		}
		
		[ElipsPlatformExtension(platforms="Android 1.6")]
		public function shareApp(subject : String,text : String, intentName : String):void
		{
		}
		
		[ElipsPlatformExtension(platforms="Android 1.6")]
		public function sendEmail(subject:String, body:String, intentName : String, file:String=''):void
		{
		}
	}
}