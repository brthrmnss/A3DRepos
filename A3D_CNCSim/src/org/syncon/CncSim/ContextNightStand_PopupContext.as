package   org.syncon.CncSim
{
	import org.syncon.CncSim.view.popup.*;
	import org.syncon.CncSim.view.popup.rs.*;
	import org.syncon.popups.controller.*;
	import org.syncon.popups.controller.default_commands.*;
	import org.syncon.popups.model.PopupModel;
	import org.syncon.popups.view.popups.default_popups.*;
	import org.syncon2.utils.SubContext;

	/*
	import sss2.Onenote.views.OnenotePage.view.popups.PopupDragListerMediator;
	import sss2.Onenote.views.OnenotePage.view.popups.PopupFloatingCellAdjusterMediator;
	import sss2.Onenote.views.OnenotePage.view.popups.popup_drag_listerV2;
	import sss2.Onenote.views.OnenotePage.view.popups.popup_floating_cell_adjusterV2;
	*/
	public class ContextNightStand_PopupContext  extends  SubContext
	{
		
		public function ContextNightStand_PopupContext()
		{
			super();
		}
 
		
		override public function startup():void
		{
			// Model
			// Controller
			// Services
			// View
			
			this.startupPopupSubContext()
				
				this.customContext(); 
		}
		
		public function startupPopupSubContext()  : void
		{
			// Model
			injector.mapSingleton( PopupModel  )		
			// Controller
			//commandMap.mapEvent(StockPricePopupEvent.CREATE_POPUP, CreateStockPricePopupCommand, StockPricePopupEvent);	
			commandMap.mapEvent(CreatePopupEvent.REGISTER_AND_CREATE_POPUP, CreatePopupCommand, CreatePopupEvent);		
			commandMap.mapEvent(CreatePopupEvent.REGISTER_POPUP, CreatePopupCommand, CreatePopupEvent);			
			commandMap.mapEvent(RemovePopupEvent.REMOVE_POPUP, RemovePopupCommand, RemovePopupEvent);			
			commandMap.mapEvent(ShowPopupEvent.SHOW_POPUP, ShowPopupCommand, ShowPopupEvent);			
			commandMap.mapEvent(HidePopupEvent.HIDE_POPUP, HidePopupCommand, HidePopupEvent);			
			
			//default popups
			commandMap.mapEvent(ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP, ShowConfirmDialogCommand, ShowConfirmDialogTriggerEvent);			
			commandMap.mapEvent(ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, ShowAlertMessageCommand, ShowAlertMessageTriggerEvent);				
			
			commandMap.mapEvent(AddKeyboardShortcutToOpenPopupEvent.ADD_KEYBOARD_SHORTCUTS, AddPopupsKeyboardShortcutsCommand, AddKeyboardShortcutToOpenPopupEvent);	
			commandMap.mapEvent(AddKeyboardShortcutToOpenPopupEvent.ENABLE_KEYBOARD_SHORTCUTS, AddPopupsKeyboardShortcutsCommand);				
			
			 
			// View
			mediatorMap.mapView( popup_modal_bg , PopupModalMediator , null, true, true );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP,  popup_modal_bg, 'popup_modal_bg', true ) );
			this._this.dispatchEvent( new CreatePopupEvent( 
			CreatePopupEvent.REGISTER_POPUP, 
			popup_message, 'popup_alert' ) );
			//org.syncon.evernote.basic.view.popup.default_popups.popup_message
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, 
			popup_confirm, 'popup_confirm' ) );			
			//org.syncon.evernote.basic.view.popup.default_popups.popup_confirm
			this._this.dispatchEvent( new AddKeyboardShortcutToOpenPopupEvent( AddKeyboardShortcutToOpenPopupEvent.ENABLE_KEYBOARD_SHORTCUTS  ) );
			this._this.dispatchEvent( new AddKeyboardShortcutToOpenPopupEvent( AddKeyboardShortcutToOpenPopupEvent.ADD_KEYBOARD_SHORTCUTS, 
			'popup3', 89 ) ); //ctrl+Y	
		}
		
		/**
		 * Add your custom popups here
		 * */
		public function customContext() : void
		{
			mediatorMap.mapView(  PopupPickImage,  PopupPickImageMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupPickImage, 'PopupPickImage', true  ) );	
			
			mediatorMap.mapView(  PopupUploadImage,  PopupUploadImageMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupUploadImage, 'PopupUploadImage', true  ) );		
	 
			mediatorMap.mapView(  PopupNotification,  PopupNotificationMediator, null, false, false );	
			this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
				PopupNotification, 'PopupNotification', false   ) );		
			
			
		}
		
		public function onInit()  : void
		{
			return; 
			import flash.utils.setTimeout; 
			// this.contextView.alpha = 0.3
			//setTimeout( this.onInit2 , 2000 ) 
			this._this.dispatchEvent( new ShowPopupEvent( 
				ShowPopupEvent.SHOW_POPUP,  'popup_login' ) );	
		}
		public function onInit2()  : void
		{
			/*import flash.utils.setTimeout; 
			setTimeout( this.onInit2 , 10000 )*/
			this._this.dispatchEvent( new ShowPopupEvent( 
				ShowPopupEvent.SHOW_POPUP,  'popup_login' ) );	
			
		}		
		
		
	}
}