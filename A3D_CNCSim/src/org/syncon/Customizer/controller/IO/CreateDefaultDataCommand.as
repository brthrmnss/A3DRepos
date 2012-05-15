package org.syncon.Customizer.controller.IO
{
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon2.utils.MakeVOs;
	
	
	public class CreateDefaultDataCommand extends Command
	{
		[Inject] public var model:NightStandModel;
		[Inject] public var event:CreateDefaultDataTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == CreateDefaultDataTriggerEvent.CREATE ) 
			{
				this.createDeafultLessonPlan()
			}				
		}
		
		private function createDeafultLessonPlan():void
		{
			
	 ; 
		}		
		
		
	}
}