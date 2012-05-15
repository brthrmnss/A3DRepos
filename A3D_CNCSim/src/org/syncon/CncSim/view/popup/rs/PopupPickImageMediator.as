package  	org.syncon.CncSim.view.popup.rs 
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.vo.ImageVO;
	import org.syncon.CncSim.vo.LazyEventHandler;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class  PopupPickImageMediator extends Mediator
	{
		[Inject] public var ui:PopupPickImage;
		[Inject] public var model : NightStandModel;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		public function PopupPickImageMediator()
		{
		} 
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			ev.init( this.ui ) ; 
			this.ev.addEv(PopupPickImage.CANCEL, this.onCancel )
			this.ev.addEv(PopupPickImage.SETUP, this.onSetup ) ; 
			
			this.ev.addEv(PopupPickImage.UPLOAD, this.onUpload )
			
			this.ev.addEv(PopupPickImage.SELECT, this.onSelect )
			
			
			this.ui.list.dataProvider = this.model.images; 
		}
		
		private function onSelect(e:CustomEvent):void
		{
			this.ui.list.selectedIndex = -1
			this.ui.list.selectedItem = null; 
			var img : ImageVO = e.data as ImageVO; 
			//	img.name = 'foo'; 
			
			var oldScroll : Number = this.ui.list.scroller.verticalScrollBar.value; 
			this.ui.list.dataProvider = new ArrayList(); 
			this.ui.list.dataProvider = this.model.images; 
			this.ui.list.scroller.verticalScrollBar.value; 
			
			this.ui.hide()
			//if ( this.ui.fxDone != null ) 
				this.ui.fxDone( img ) ; 
		}
		
		private function onUpload(event:Event=null):void
		{
			//this.dispatch( new AutomateEvent(AutomateEvent.START_LESSON, this.ui.lesson )) 
			//this.ui.hide(); 
			var event_ : ShowPopupEvent = new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupUploadImage', [null], 'done' ) 		
			this.dispatch( event_ ) 
		}	
		
		protected function onSetup(event:Event):void
		{
			//this.ui.txtLessonName.text = this.model.currentLessonPlan.name; 
		}
		
		
		
		
		private function onCancel(e:Event) : void
		{
			//this.model.reselectCurrentLayer();//
			//= this.model.currentLayer
			this.ui.hide();
		}				
		
		
	}
}