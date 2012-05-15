package org.syncon2.utils.modules
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.syncon2.utils.sound.IPlaySound;
	
	/**
	 * Uses old set time functionality to quickly take a function tot call later 
	 * uses different Timers for each request to prevent conflicts 
	 * @author user3
	 * 
	 */
	public class  SetTimeout2
	{
		
		
		private var setupTimer:Boolean;
		
		public var dict : Dictionary = new Dictionary(true); 
		
		public function setTimeout( delay : Number, fx : Function,  params : Array=null ) : Timer
		{
			if ( delay == 0 ) 
			{
				fx.apply( this, params ) 
				return null; 
			}
			var t : Timer = new Timer( delay, 1 ) ; 
			this.dict[t] = [fx,params]; 
			t.addEventListener(TimerEvent.TIMER, this.onCount, false, 0, true ) ; 
			t.stop(); 
			t.start()
			return t; 
		}
		
		public function cancelTimer(t : Timer ) : void
		{
			delete dict[t] 
			t.stop(); 
			t.removeEventListener( TimerEvent.TIMER, this.onCount )
		}
		
		protected function onCount(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			var args : Array = dict[event.currentTarget] 
				delete dict[event.currentTarget] 
			var t : Timer = event.currentTarget as Timer; 
			t.stop(); 
			t.removeEventListener( TimerEvent.TIMER, this.onCount )
			var fx : Function = args[0] 
			if ( fx == null ) 
			{
				return;//canceled?
			}
			var params : Array = args[1]
			fx.apply( this, params ) ; 
		}
		
		
	}
}