package org.syncon.CncSim.view.ui
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.view.ui.BehaviorList;
	import org.syncon.CncSim.view.ui.old.LayersList;
	import org.syncon.CncSim.vo.LayerBaseVO;
	import org.syncon.CncSim.vo.LogVO;
	
	public class LogListMediator extends Mediator 
	{
		[Inject] public var ui : LogList;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.LIST_MAIN_LOG_CHANGED, 
				this.onLogListChanged );	
			this.onLogListChanged(null)
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LOG_CHANGED, 
				this.onCurrentBehaviorChanged);	
			this.onCurrentBehaviorChanged( null ) 
			this.ui.addEventListener( LogList.CHANGE_LIST, this.onSelectBehavior ) 
		}
		
		private function onLogListChanged(e:NightStandModelEvent):void
		{
			if ( this.ui.list.dataProvider != this.model.listLog ) 
				this.ui.list.dataProvider = this.model.listLog; 
		}
		
		/**
		 * do not try to select locked layers which will not be here
		 * */
		
		
		private function onCurrentBehaviorChanged(e: NightStandModelEvent): void
		{
			if ( this.model.currentLayer == null ) 
			{
				this.ui.list.selectedIndex = -1;
				return
			}
			if ( this.model.currentLayer.showInList == false ) 
				return; 
			if ( this.ui.list.selectedItem == this.model.currentLayer ) 
				return; 
			this.ui.list.selectedItem = this.model.currentLayer;
			var i : int = this.ui.list.dataProvider.getItemIndex( this.model.currentLayer ); 
			if ( i == -1 ) 
				throw 'how this happen?, why did you select this? if not in list?';
			this.ui.list.selectedIndex = i ; 
		}		
		
		public function onSelectBehavior ( e : CustomEvent ) : void
		{
			this.model.currentLog = e.data as LogVO;
			this.ui.list.selectedItem = this.model.currentLayer
			//this.model.objectHandles.selectionManager.setSelected( this.model.currentLayer.model ) ; 
		}
		
	}
}