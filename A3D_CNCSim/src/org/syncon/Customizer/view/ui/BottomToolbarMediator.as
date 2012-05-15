package org.syncon.Customizer.view.ui
{
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.Customizer.model.CustomEvent;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon.Customizer.model.NightStandModelEvent;
	import org.syncon.Customizer.view.ui.BottomToolbar;
	
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