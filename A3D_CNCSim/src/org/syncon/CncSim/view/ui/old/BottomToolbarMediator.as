package org.syncon.CncSim.view.ui.old
{
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.view.ui.old.BottomToolbar;
	
	public class BottomToolbarMediator extends Mediator 
	{
		[Inject] public var ui : BottomToolbar;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			this.ui.addEventListener( BottomToolbar.UPDATE_JSON, 
				this.onUpdateJSON);	
		}
		
		private function onUpdateJSON(e:  CustomEvent): void
		{
			var obj : Object = e.data
			
		}		
		
		
		
	}
}