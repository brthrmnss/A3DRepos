package org.syncon2.utils.modules
{
	import org.syncon2.utils.sound.IPlaySound;
	
	public class  PlaySound  
	{
		
		static public var PlaySound : IPlaySound; 
		/*public function playSound( s : SoundVO, fxCallAfterSoundCompletePlaying_ : Function = null ) : void
		{
		PlaySound.playSound( s, fxCallAfterSoundCompletePlaying_ ); 
		}*/
		public function playSound2(url : String , times : int = 1, x : Object=null, fxDone : Function = null  ) : void
		{
			PlaySound.playSound2( url, times, x, fxDone ); 
		}
		
		public function stopSound(clearFx:Boolean=true):void{
			PlaySound.stopSound();//( s, times ); 
			if ( clearFx) PlaySound.fxCallAfterSoundCompletePlaying = null
		} 
		public function set fxCallAfterSoundCompletePlaying( fx : Function):void{
			PlaySound.fxCallAfterSoundCompletePlaying = fx //( s, times ); 
		} 

		
	}
}