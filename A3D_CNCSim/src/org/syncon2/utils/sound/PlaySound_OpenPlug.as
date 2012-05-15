package org.syncon2.utils.sound
{
	import flash.events.Event;
	
	import openplug.elips.controls.Alert;
	import openplug.elips.services.SystemAPI;
	
	import org.syncon2.utils.mobile.SoundExtensions;
	import org.syncon2.utils.openplug.Constants;
	
	public class  PlaySound_OpenPlug implements  IPlaySound
	{
		public function set fxCallAfterSoundCompletePlaying ( fx : Function ) : void
		{
			this._fxCallAfterSoundCompletePlaying = fx; 
		}
		private var _fxCallAfterSoundCompletePlaying:Function;
		private var addedEventListner:Boolean=false;
		private var currentSoundId:int=-1;
		private var cpu:Boolean=false;
		private var oldUrl:String; 
		public var SoundAPI2 :  SoundExtensions = new SoundExtensions()
		/**
		 * so we can plsy sound twice
		 * */
		public function  get  fxCallAfterSoundCompletePlaying (  ) : Function
		{
			return this._fxCallAfterSoundCompletePlaying  
		}
		
		public function playSound( s : Object, fxCallAfterSoundCompletePlaying_ : Function = null ) : void
		{
			this.playSound2( s.url ); 
			this.fxCallAfterSoundCompletePlaying = fxCallAfterSoundCompletePlaying_			
		}
		public function playSound2(url : String , times : int = 1, x : Object = null, fxDone : Function = null ) : void
		{
			if ( SoundExtensions.init == false ) 
			{
				this.SoundAPI2.initSoundSystem();
			}
			if ( url ==  '' ) 
			{
				trace('PlaySound_OpenPlug', 'playSound2','sound is empty')
				return; 
			}
			//PlatformGlobals.show('play ' + url ) ; 
			/*if ( currentSoundId !=  -1 ) 
			this.stopSound();*/
			//url = "G:/My Documents/work/mobile3/SoundBoardEllips/bin-debugassets/sub/gow/sounds/Baird - No shit.mp3"
			
			if ( this.cpu ) 
			{
				
				var pattern2:RegExp = new RegExp("\\", "gi");
				url = url.replace(pattern2, '/' )
				var pattern:RegExp = /(\)/g; 
				url = url.replace(pattern, '/' )
				pattern  = /\\/g
				url = url.replace(pattern, '/' )
				Alert.show(url, 'url' ) ; 
				
				var soundID:int = SoundAPI2.loadSoundFile(url);
				if ( soundID == -1 ) 
				{
					//try agin 
					trace( 'again 1', soundID ); 
					soundID = SoundAPI2.loadSoundFile(url);
					/*trace( 'again 2', soundID ); 
					soundID = SoundAPI2.loadSoundFile(url);*/
				}
				//if same url, id is -1, but the current sound is playing ... replay it ...
				if ( oldUrl == url && soundID == -1 &&  this.currentSoundId != -1 )
				{
					trace( 'replay', soundID, currentSoundId ) ; 
					this.stopSound();
					soundID = SoundAPI2.loadSoundFile(url);
					SoundAPI2.playSoundFile(currentSoundId);
					return; 
				}
				else
				{
					if ( this.currentSoundId != -1 )
					{
						if ( soundID !=  -1 ) 
							this.stopSound();
						//	SoundAPI2.stopSoundFile(currentSoundId);
					}
				}
				oldUrl = url; 
				trace( 'play', soundID, currentSoundId ) ; 
				currentSoundId = soundID; 
				SoundAPI2.playSoundFile(soundID);
			}
			else
			{
				/*if ( this.currentSoundId != -1 )
				{
				//if ( soundID !=  -1 ) 
				this.stopSound();
				//	SoundAPI2.stopSoundFile(currentSoundId);
				}
				soundID = SoundAPI2.loadSoundFile(url);
				if ( soundID == -1 ) 
				{
				//try agin 
				trace( 'again 1', soundID ); 
				soundID = SoundAPI2.loadSoundFile(url);
				}
				Alert.show(soundID.toString(), 'play'); 
				SoundAPI2.playSoundFile(soundID);*/
				
				
				if ( this.currentSoundId != -1 )
				{
					//if ( soundID !=  -1 ) 
					this.stopSound();
					//	SoundAPI2.stopSoundFile(currentSoundId);
				}
				if ( Constants.debug1 ) 
				{
					Constants.PlatformGlobals.show(  url, 'url'); 
				}
				trace(this.debugTag,  url.charAt(0), url  ) 
				//remove initial slash?
				/*if ( url.charAt(0) == "/" ) 
				{
					url = url.slice(1, url.length )
				}*/
				trace(this.debugTag,url ) 
				soundID = SoundAPI2.loadSoundFile(url);
				
				if ( soundID == -1 ) 
				{
					//try agin 
					
					trace( 'again 1', soundID ); 
					soundID = SoundAPI2.loadSoundFile(url);
					/*trace( 'again 2', soundID ); 
					soundID = SoundAPI2.loadSoundFile(url);*/
				}
				/*			
				soundID = SoundAPI2.loadSoundFile(url);
				trace( 'after 1', soundID ); 
				if ( soundID == -1 ) 
				{
				//try agin 
				trace( 'again 1', soundID ); 
				soundID = SoundAPI2.loadSoundFile(url);
				}*/
				
				//Alert.show(soundID.toString(), 'play'); 
				//SoundAPI2.playSoundFile(soundID);
				if ( Constants.debug1 ) 
				{
					Constants.PlatformGlobals.show(  soundID.toString(), 'soundID'); 
				}
				
				SoundAPI2.playSoundFile(soundID);
				this.currentSoundId= soundID
				SoundAPI2.setVolumeSoundFile( this.currentSoundId, volume ) 
				//	PlatformGlobals.show('play sound sound '  + this.currentSoundId  )
			}
			
			this.fxCallAfterSoundCompletePlaying = fxDone; 
			//SoundAPI2.pauseSoundFile(soundID);
			//soundID = SoundAPI2.loadSoundFile(url);
			/*	trace( '1', soundID ); 
			soundID = SoundAPI2.loadSoundFile(url);
			trace( '2', soundID ); 
			soundID = SoundAPI2.loadSoundFile(url);
			trace( '3', soundID ); */
			
			if ( addedEventListner == false  ) 
			{
				addedEventListner = true
				SoundAPI2.dispatcher.addEventListener(SoundExtensions.AUDIO_FILE_ENDED, onSoundComplete);
				SystemAPI.dispatcher.addEventListener(SystemAPI.AUDIO_FILE_ENDED, onSoundComplete);
			}
		}
		
		protected function onSoundComplete(event:Event):void
		{
			//PlatformGlobals.show('stop sound '  + this.currentSoundId  )
			this.stopSound(); 
			if ( fxCallAfterSoundCompletePlaying != null ) 
				fxCallAfterSoundCompletePlaying(event); 
			
		}
		
		public function stopSound():void{
			if ( this.currentSoundId != -1 )
			{
				trace( 'stop', currentSoundId ) ; 
				SoundAPI2.stopSoundFile(currentSoundId);
				SoundAPI2.unloadSoundFile(currentSoundId);
				this.currentSoundId = -1
			}
		}
		
		
		private var currentIndex:int;
		public var chainList : Array = []; 
		public function chainUp( arr : Array ) : void{
			this.currentIndex = 0 ; 
			this.chainList = arr; 
			this.playNextSound()
			//this.cleanUP()
		}
		
		private function playNextSound():void
		{
			if ( this.currentIndex >= this.chainList.length) 
			{
				//this.dispatch( new Event('done');
				this.stopSound(); 
				return; 
			}
			var current : String = this.chainList[this.currentIndex]
			this.playSound(  current, this.onPlaybackComplete ) ; // 'a.mp3' ); //current+this.suffix ) ; 
			return ;
		}
		protected function onPlaybackComplete(event:Event):void
		{
			//trace('finisehd' )
			this.stopSound(); 
			this.currentIndex++
				this.playNextSound()
		}
		
		static private var volume : int = 99 
		private var debugTag: String = 'PlaySound_OpenPlug';
		public function setVolume( v : int) : void
		{
			volume = v; 
			SoundAPI2.setVolumeSoundFile( this.currentSoundId, volume ) 
		}
	}
}