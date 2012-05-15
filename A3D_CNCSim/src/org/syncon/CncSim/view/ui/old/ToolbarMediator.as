package org.syncon.CncSim.view.ui.old
{
	import flash.events.Event;
	
	import flashx.undo.IOperation;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.controller.EditProductCommandTriggerEvent;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.view.ui.old.Toolbar;
	import org.syncon.CncSim.vo.ImageVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class  ToolbarMediator extends Mediator 
	{
		[Inject] public var ui : Toolbar;
		[Inject] public var model : NightStandModel;
		
		override public function onRegister():void
		{
			this.ui.addEventListener( Toolbar.ADD_TEXT,  this.onAddText);	
			this.ui.addEventListener( Toolbar.ADD_IMAGE,  this.onAddImage);	
			this.ui.addEventListener( Toolbar.UNDO,  this.onUndo);	
			this.ui.addEventListener( Toolbar.REDO,  this.onRedo);	
			
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.UNDOS_CHANGED, 
				this.checkUndoButtons);	
			this.checkUndoButtons(); 
		}
		
		protected function onRedo(event:Event):void
		{
			// TODO Auto-generated method stub
			var op : IOperation = this.model.undo.popRedo()
			op.performRedo()
			this.model.undo.pushUndo( op ) ; 
			//this.model.undo.redo(); 
			this.checkUndoButtons()
		}
		
		protected function onUndo(event:Event):void
		{
			// TODO Auto-generated method stub
			//	this.model.undo.undo()
			var op : IOperation = this.model.undo.popUndo()
			op.performUndo()
			this.model.undo.pushRedo( op ) ; 
			this.checkUndoButtons()
		}
		
		private function checkUndoButtons(e:Event=null):void
		{
			var dbg : Array = [this.model.undo.canUndo()] 
			this.ui.btnRedo.enabled = this.model.undo.canRedo() 
			this.ui.btnUndo.enabled = this.model.undo.canUndo() 
		}
		
		private function onAddText(e:  CustomEvent): void
		{
			var obj : Object = e.data
			this.dispatch( new EditProductCommandTriggerEvent (
				EditProductCommandTriggerEvent.ADD_TEXT_LAYER, e) ) ; 
		}		
		
		private function onAddImage(e:  CustomEvent): void
		{
			var obj : Object = e.data
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupPickImage', [this.onPickedImage], 'done' ) 		
			this.dispatch( event_ ) 
		}		
		
		private function onPickedImage( e : ImageVO ) : void
		{
			this.dispatch( new EditProductCommandTriggerEvent (
				EditProductCommandTriggerEvent.ADD_IMAGE_LAYER, e.url) ) ; 
		}
		
	}
}