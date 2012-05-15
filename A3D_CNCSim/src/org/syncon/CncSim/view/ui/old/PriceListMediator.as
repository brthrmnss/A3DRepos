package org.syncon.CncSim.view.ui.old
{
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.view.ui.old.PriceList;
	
	public class PriceListMediator extends Mediator 
	{
		[Inject] public var ui : PriceList;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			this.ui.addEventListener( PriceList.UPDATE_JSON, 
				this.onUpdateJSON);	
		}
		
		private function onUpdateJSON(e: CustomEvent): void
		{
		}		
		
	}
}