package  	org.syncon.CncSim.view.popup.rs 
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.vo.LazyEventHandler;
	
	public class  PopupUploadImageMediator extends Mediator
	{
		[Inject] public var ui:PopupUploadImage;
		[Inject] public var model : NightStandModel;
		private var ev :  LazyEventHandler = new LazyEventHandler(); 
		public function PopupUploadImageMediator()
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
			this.ev.addEv(PopupUploadImage.CANCEL, this.onCancel )
			this.ev.addEv(PopupUploadImage.OK, this.onSelectImage )
			this.ev.addEv(PopupUploadImage.SETUP, this.onSetup ) ; 
		}
		
		private function onSelectImage( e:Event):void
		{
			// TODO Auto Generated method stub
			this.ui.hide()
				if ( this.ui.fxDone != null ) 
				{
					this.ui.fxDone(this.ui.imageUploadedPic.source ) 
				}
		}		
		
		
		protected function onSetup(event:Event):void
		{
		}
		
		
		
		
		private function onCancel(e:Event) : void
		{
			//this.model.reselectCurrentLayer();//
			this.ui.hide();
		}				
		
		
	}
}