package  org.syncon.Customizer.view.subview
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.StyleSheet;
	import flash.utils.Timer;
	
	import mx.core.IFactory;
	import mx.events.FlexEvent;
	import mx.styles.CSSStyleDeclaration;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.NightStand.controller.GetInitDataCommandTriggerEvent;
	import org.syncon.Customizer.model.CustomEvent;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon.Customizer.model.NightStandModelEvent;
	import org.syncon.NightStand.vo.OdbVO;
	import org.syncon.TalkingClock.vo.StyleConfigurator;
	
	import spark.components.supportClasses.StyleableTextField;
	import spark.events.ViewNavigatorEvent;
	import org.syncon.NightStand.view.mobile.SettingsView;
	import org.syncon.TalkingClock.view.mobile.SettingsView;
	
	
	public class  ListViewMediator extends Mediator
	{
		[Inject] public var ui:  ListView;
		[Inject] public var model :  NightStandModel;
		private var firstLoad:Boolean=true;
		private var loadOdb:OdbVO;
		private var timer:Timer;
		private var timer_Reset:Timer;
		
		private var timer_ShowLoading : Timer; 
		private var styler:StyleConfigurator;
		
		public function ListViewMediator()
		{
			this.timer_Reset = new Timer(500,1)
			this.timer_Reset.addEventListener(TimerEvent.TIMER, this.onReset  , false, 0, true )
			this.timer_ShowLoading = new Timer(500, 1); 
			this.timer_ShowLoading.addEventListener(TimerEvent.TIMER, this.onShowLoading, false, 0, true ) ; 
		} 
		override public function onRemove():void
		{
			trace('mediator removed'); 
			this.ui.removeEventListener(ListView.GO_BACK, this.onGoBack  ) ;
			this.ui.removeEventListener(ListView.TRY_AGAIN , this.onTryAgain  ) ; 
			this.ui.removeEventListener(ListView.LIST_CHANGED, this.onListChanged  ) ;
			this.ui.removeEventListener(ListView.SETTINGS, this.onSettings  ) ;
			super.onRemove()
		}
		override public function onRegister():void
		{
			if ( this.model.showAds == false ) 
			{
				this.ui.list.setStyle('bottom', 0 ); 
			}			
			trace('mediator created'); 
			/*if ( this.ui.destructionPolicy == 'never' ) {
			this.mediatorMap.unmapView( ListView  )
			}*/
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.LOADED_ODBS,
				this.onLoadOdbs);	
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.LOAD_ODBS_FAULT,
				this.onLoadOdbsFault);				
			//this.ui.addEventListener(FlexEvent.DATA_CHANGE, this.onDataChange, false, 0, true ) ; 
			this.ui.addEventListener(ListView.GO_BACK, this.onGoBack, false, 0, true ) ;
			this.ui.addEventListener(ListView.TRY_AGAIN , this.onTryAgain, false, 0, true ) ; 
			this.ui.addEventListener(ListView.LIST_CHANGED, this.onListChanged, false, 0, true ) ;
			
			this.ui.addEventListener(ListView.SETTINGS, this.onSettings, false, 0, true ) ;
			
			
			//this.ui.addEventListener(Event.ACTIVATE, this.onActivate, false, 0, true ) ; 
			this.ui.addEventListener(ViewNavigatorEvent.VIEW_ACTIVATE, this.onActivate2, false, 0, true ) ; 
			this.ui.txtLoading.visible = true; 
			this.ui.txtError.visible = false;
			
			this.styler = new StyleConfigurator(); 
			this.styler.init( this.ui, this.model.config, this.updateStyles  ); 
			
			if ( this.model.stories.length > 0 ) 
				this.onLoadOdbs(null); 
		}
		
		protected function onSettings(event:Event):void
		{
			this.ui.navigator.pushView( SettingsView,null, null,   );
		}
		 
		private function onLoadOdbsFault(e:Event):void
		{
			this.ui.txtLoading.visible = false; 
			this.ui.txtError.visible = true; 
		}
		
		protected function onActivate2(event:ViewNavigatorEvent):void
		{
			//trace('activate', this.ui ); 
			/*this.ui.list.alpha = 1; 
			this.ui.txtLoading.visible = false; */
			this.styler.changedCheck( this.model.config ) ; 
		}
		public function updateStyles(init:Boolean=false) : void
		{
			var updateAnyway : Boolean = false
			if ( this.styler.bgChanged || init ) 
			{
				var css : CSSStyleDeclaration = this.ui.styleManager.getStyleDeclaration('org.syncon.odb.view.mobile.ODBRenderer')
				css.setStyle( 'backgroundColor', this.model.config.reverseText ? 0:  0xFFFFFF  ) 
				var css2 : CSSStyleDeclaration = this.ui.styleManager.getStyleDeclaration('.txtTitleStyle')
				css2.setStyle( 'color', this.model.config.reverseText == false  ? 0:  0xFFFFFF  ) 
				updateAnyway = true; 
			}
			if ( this.styler.fontChanged || updateAnyway ) // != this.model.config.fontSize ) 
			{
				this.hideUI(); 
				//refresh list itemRenderers
				var oldItemRenderer : Object = this.ui.list.itemRenderer
				this.ui.list.itemRenderer = null ; 
				this.ui.list.itemRenderer = oldItemRenderer as IFactory ;
				
				this.ui.list.scroller.verticalScrollBar.value = 0; 
				
				this.timer_ShowLoading.start(); 
			}
		}
		
		
		public function onShowLoading(e:Event):void
		{
			this.showUI()
		}
		
		private function showUI():void
		{
			this.ui.txtLoading.visible = false; 
			this.ui.txtError.visible = false;
			this.ui.list.alpha = 1; 
		}
		
		private function hideUI():void
		{
			this.ui.txtLoading.visible = true; 
			this.ui.txtError.visible = false;
			this.ui.list.alpha = 0.2
		}
		
		private function onTryAgain(e:Event):void
		{
			this.dispatch( new GetInitDataCommandTriggerEvent( 
				GetInitDataCommandTriggerEvent.LOAD_RSS_AND_CONVERT  ))
		}		
		
		private function onGoBack(e:Event):void
		{
			//this.ui.navigator.popView()
		}		
		
		private function onLoadOdbs(e:NightStandModelEvent):void
		{
			this.ui.list.dataProvider = this.model.stories; 
			
			this.ui.txtLoading.visible = false; 
			this.ui.txtError.visible = false;
			
			if ( firstLoad && this.model.stories.length == 0  ) //wanted to not desotry view ....
			{
				firstLoad = false ; 
				this.ui.txtLoading.visible = true; 
				this.ui.txtError.visible = false;
			}	
		}
		protected function onListChanged(event:CustomEvent):void
		{
			//this.ui.list.selectedItem = null 
			this.ui.list.selectedIndex = -1; 
			trace('change heard'); 
			
			var odb :  OdbVO = event.data as  OdbVO;
			this.loadOdb  = odb
			this.ui.txtLoading.visible = false; 
			//this.showLoadingForLater()
			this.ui.txtLoading.addEventListener(FlexEvent.SHOW, this.onShowLabel, false, 0, true ); 
			this.ui.txtLoading.visible = true; 
			this.ui.list.alpha = 0.2
			/*this.ui.callLater( this.ui.navigator.pushView, [DevotionView, odb] )*/
			/*this.ui.navigator.pushView( DevotionView, odb  ); */
			
		}
		
		private function showLoadingForLater():void
		{
			// TODO Auto Generated method stub
			
		}
		
		protected function onShowLabel(event:FlexEvent):void
		{
			this.ui.txtLoading.removeEventListener(FlexEvent.SHOW, this.onShowLabel );
			this.timer = new Timer(400, 1 ) 
			this.timer.addEventListener(TimerEvent.TIMER, this.onDone, false, 0, true ) ; 
			this.timer.start(); 
		}
		
		protected function onDone(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER, this.onDone ); 
			this.ui.navigator.pushView( DevotionView, this.loadOdb  );
			
			this.timer_Reset.start(); 
			
		}		
		
		public function onReset(e:Event):void{
			this.ui.list.alpha = 1; 
			this.ui.txtLoading.visible = false; 
		}
		
		
		/*		
		private function onAuthenticated(e:EvernoteAPIModelEvent): void
		{
		}		
		
		private function onSearch(e:CustomEvent) : void
		{
		this.dispatch( new SearchEvent( SearchEvent.SEARCHED, e.data.toString() ) ) 
		}		
		
		private function onSearchUpdatedHandler(e:SearchEvent) : void
		{
		this.ui.txtQuery.text = e.query; 
		//move t oend ..
		//this.ui.txtQuery.selectRange( 
		}				
		*/
	}
}