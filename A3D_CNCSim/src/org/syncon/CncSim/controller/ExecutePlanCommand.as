package org.syncon.CncSim.controller
{
	import org.robotlegs.mvcs.Command;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.vo.LogVO;
	import org.syncon.CncSim.vo.PlanVO;
	
	/**
	 * Is a wrapper for the executor, which only knows how to play back steps into the log 
	 * Think of this as a PlanExecutorVO helper to get it started in a very unset state
	 * */
	public class ExecutePlanCommand extends Command
	{
		[Inject] public var model:NightStandModel;
		[Inject] public var event:ExecutePlanCommandTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == ExecutePlanCommandTriggerEvent.PLAY ) 
			{
				var newPlan :  PlanVO = event.data as PlanVO; 
				if ( newPlan != null && this.model.currentPlan != newPlan ) 
				{
					//shelve old product
					//shelp old log
					//say you're editing something
					
					/*var log : LogVO = new LogVO(); 
					log.changePlan( this.model.currentPlan , this.model.listExecutionLog )
					log.l
					this.dispatch( EditProductCommandTriggerEvent
					this.model.currentPlan = plan; 
					*/
				/*	this.dispatch( new EditProductCommandTriggerEvent (
						EditProductCommandTriggerEvent.CHANGE_PLANS, newPlan ) ) ;
								*/
				}
				this.model.player.plan = this.model.currentPlan; 
				this.model.player.play(0); 
				this.dispatch( new NightStandModelEvent( NightStandModelEvent.EXECUTION_STATE_CHANGED ) ) 
			}
			
			if ( event.type == ExecutePlanCommandTriggerEvent.STOP ) 
			{
			}
			
			if ( event.type == ExecutePlanCommandTriggerEvent.PAUSE ) 
			{
			}
			
			if ( event.type == ExecutePlanCommandTriggerEvent.GO_TO_LINE ) 
			{
			}
		}
		
		
	}
}