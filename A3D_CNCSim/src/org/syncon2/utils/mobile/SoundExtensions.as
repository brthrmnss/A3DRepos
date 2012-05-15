package org.syncon2.utils.mobile
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class SoundExtensions
	{
		/**
		 * Quickly display error from this class ... very lazy, but convient 
		 * */
		static public var CallBack : Function;  
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function loadSoundFile( url : String): int
		{	
			return 0
		}
 
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function loadMediaPlayerSound( url : String):  Boolean
		{	
			return true
		}		
		
		static public var init : Boolean = false ;
		public var dispatcher:EventDispatcher = new EventDispatcher();
		static public var AUDIO_FILE_ENDED: String = 'AUDIO_FILE_ENDED' ;
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function initSoundSystem(  ):  Boolean
		{	
			return true
		}		
		
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function playAudioEndCallback(  ):  void
		{	
			return  
		}	
		
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function pauseSoundFile(i : int  ):  void
		{	
			return  
		}	
		
		
		
		
		
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function stopSoundFile( soundId : int  ):  void
		{	
			return  
		}	
		
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function playSoundFile( soundId : int  ):  void
		{	
			return  
		}	
		
		[ElipsPlatformExtension(platforms="Android 1.6")]	
		public function setVolumeSoundFile(currentSoundId:int, volume:int):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function unloadSoundFile(currentSoundId:int):void
		{
			// TODO Auto Generated method stub
			
		}

		
		
		/**
		 * call this keydwon
		 * */
		
		public function set soundDone(value: int):void 
		{
			trace('in flex', 'soundDone')
			/*if ( this.callback != null ) 
			{
			this.callback( value ) 
			}*/
			this.dispatcher.dispatchEvent( new Event(SoundExtensions.AUDIO_FILE_ENDED) ) 
		}
		
		
	}
}