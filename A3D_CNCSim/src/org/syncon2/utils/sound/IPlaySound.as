package   org.syncon2.utils.sound
{
	//import org.syncon.TalkingClock.vo.SoundVO;
	
	public interface IPlaySound  
	{
		function playSound( s :  Object, fxCallAfterSoundCompletePlaying_ : Function = null ) : void
		function playSound2(url : String , times : int = 1, x : Object=null, fxDone : Function = null  ) : void  			 
		function stopSound(): void
		function set fxCallAfterSoundCompletePlaying ( fx : Function ) : void
		/**
		 * In different context we might need to use relative vs abs paths 
		 * */
		/*function set fxChangeSoundLocation(value:Function):void*/
		function chainUp(arr:Array):void
		function setVolume( volume : int) :void
	}
}