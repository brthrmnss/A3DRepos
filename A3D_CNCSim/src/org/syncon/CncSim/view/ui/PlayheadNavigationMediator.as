package org.syncon.CncSim.view.ui
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.view.ui.PlayheadNavigation;
	
	public class  PlayheadNavigationMediator extends Mediator 
	{
		[Inject] public var ui : PlayheadNavigation;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			this.ui.addEventListener( PlayheadNavigation.PLAY,  this.onPlay);	
			this.ui.addEventListener( PlayheadNavigation.PAUSE,  this.onPause);	
			this.ui.addEventListener( PlayheadNavigation.STOP,  this.onStop);	
			this.ui.addEventListener( PlayheadNavigation.REWIND,  this.onRewind);	
			this.ui.addEventListener( PlayheadNavigation.JUMP_TO,  this.onJumpTo);	
			//update the maximum
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.EXECUTION_STATE_CHANGED, 
				this.onExecutationStateChanged);	
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.PLAN_LENGTH_CHANGED, 
				this.onPlanLengthChanged);	
/*			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_PLAN_CHANGED, 
				this.onLayersChanged);	*/
			this.onExecutationStateChanged()
			
		} 
		
		private function onPlanLengthChanged(e:NightStandModelEvent):void
		{
			// TODO Auto Generated method stub

		}
		
		private function onExecutationStateChanged(e:Event=null):void
		{
			this.show( this.ui.btnPlay ) ; 	
			this.show( this.ui.btnPause ) ; 	
			this.show( this.ui.btnStop ) ; 				
			if ( this.model.player.isPlaying() ) 
			{
				this.hide( this.ui.btnPlay ) ; 	
			} 
			else if ( this.model.player.isPaused() ) 
			{
				this.hide( this.ui.btnPause ) ;
			}
			else if ( this.model.player.isStopped() )
			{
				this.hide( this.ui.btnPause ) ;
				this.hide( this.ui.btnStop ) ;
			}
			
		}
		private function show(btn:UIComponent):void
		{
			btn.includeInLayout = btn.visible = true; 
		}
		private function hide(btn:UIComponent):void
		{
			btn.includeInLayout = btn.visible = false; 
		}
		
		private function onPlay(e:  CustomEvent): void
		{
			this.model.play(); 
		}		
		
		private function onStop(e:  CustomEvent): void
		{
			this.model.play(); 
		}		
		private function onPause(e:  CustomEvent): void
		{
			this.model.pause(); 
		}		
		
		
		private function onRewind(e:  CustomEvent): void
		{
			this.model.goToLine(0); 
		}		
		
		
		private function onJumpTo(e:  CustomEvent): void
		{
			this.model.goToLine(e.data as int); 
		}		
		
		
	}
}