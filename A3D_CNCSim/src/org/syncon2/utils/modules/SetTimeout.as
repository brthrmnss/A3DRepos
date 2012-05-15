package org.syncon2.utils.modules
{
	import org.syncon2.utils.sound.IPlaySound;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class  SetTimeout  
	{

		
		public var setTimeoutTimer_Fx  : Function; 
		public var setTimeoutTimer : Timer = new Timer(500, 1)
		public var setTimeoutTimer_Args : Array = []; 
		private var setupTimer:Boolean;
		
		public function setTimeout( delay : Number, fx : Function,  params : Array ) : void
		{
			setTimeoutTimer.addEventListener(TimerEvent.TIMER, this.onCount, false, 0, true ) ; 
			setTimeoutTimer.stop(); 
			setTimeoutTimer.delay = delay;
			this.setTimeoutTimer_Args = params; 
			this.setTimeoutTimer_Fx = fx ;
			setTimeoutTimer.start()
		}
		protected function onCount(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			this.setTimeoutTimer.stop(); 
			setTimeoutTimer_Fx.apply( this, this.setTimeoutTimer_Args ) ; 
		}
		
		
	}
}