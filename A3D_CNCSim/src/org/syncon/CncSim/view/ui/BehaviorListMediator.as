package org.syncon.CncSim.view.ui
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.view.ui.BehaviorList;
	import org.syncon.CncSim.view.ui.old.LayersList;
	import org.syncon.CncSim.vo.BehaviorVO;
	import org.syncon.CncSim.vo.LayerBaseVO;
	
	public class BehaviorListMediator extends Mediator 
	{
		[Inject] public var ui : BehaviorList;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.BEHAVIORS_CHANGED, 
				this.onBehaviorschanged );	
			this.onBehaviorschanged(null)
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_BEHAVIOR_CHANGED, 
				this.onCurrentBehaviorChanged);	
			this.onCurrentBehaviorChanged( null ) 
			this.ui.addEventListener( BehaviorList.CHANGE_LIST, this.onSelectBehavior ) 
				
			this.ui.addEventListener( BehaviorList.ADD, this.onAdd ) 
		}
		
		protected function onAdd(event:Event):void
		{
			// TODO Auto-generated method stub
			//create popup..
		}
		
		private function onBehaviorschanged(e:NightStandModelEvent):void
		{
			if ( this.ui.list.dataProvider != this.model.behaviors ) 
				this.ui.list.dataProvider = this.model.behaviors; 
		}
		
		/**
		 * do not try to select locked layers which will not be here
		 * */
		
		
		private function onCurrentBehaviorChanged(e: NightStandModelEvent): void
		{
			if ( this.model.currentBehavior == null ) 
			{
				this.ui.list.selectedIndex = -1;
				return
			}
	 
			if ( this.ui.list.selectedItem == this.model.currentBehavior ) 
				return; 
			this.ui.list.selectedItem = this.model.currentBehavior;
			var i : int = this.ui.list.dataProvider.getItemIndex( this.model.currentBehavior ); 
			if ( i == -1 ) 
				throw 'how this happen?, why did you select this? if not in list?';
			this.ui.list.selectedIndex = i ; 
		}		
		
		public function onSelectBehavior ( e : CustomEvent ) : void
		{
			this.model.currentBehavior = e.data as BehaviorVO;
			this.ui.list.selectedItem = this.model.currentLayer
			//this.model.objectHandles.selectionManager.setSelected( this.model.currentLayer.model ) ; 
		}
		
	}
}