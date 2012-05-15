package   org.syncon2.utils.openplug.ui.comp
{
	//import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon2.utils.mobile.controller.SwitchScreensTriggerEvent;
	import org.syncon2.utils.openplug.controller.CallNativeCommandDefault;
	import org.syncon2.utils.openplug.controller.CallNativeCommandDefaultTriggerEvent;
	import org.syncon2.utils.openplug.controller.CustomEvent;
	import org.syncon2.utils.view.LazyEventHandler;
	
	/**
	 * Open menu from default menu provider 
	 * */
	public class PopupMenuActionViewMediator extends Mediator
	{
		[Inject] public var ui: PopupMenuActionView;
		private var ev : LazyEventHandler = new LazyEventHandler(); 
		
		private var dp:ArrayCollection   
		
		public static var REPORT_PROBLEM:String = 'Report a problem'; 
		public static var RATE:String = 'Rate'; 
		public static var MORE: String = 'More Applications' 
		public static var ABOUT:String = 'About'; 
		public static var PLAY_ALL:String = 'Play All';
		public static var SHARE :  String = 'Share'
		public static var QUIT:String = 'Quit'; 
		public static var SETTINGS : String = 'Settings'; 
		public static var STOP_ALL_SOUNDS:String = 'Stop All Sounds'; 
		public static var SET_RINGTONE:String = 'Set Ringtone'; 		
		
		public static var BACK:String = 'Cancel'; 		
		private var lastItem:Object;
		private var defaultDp:ArrayCollection;
		private var config:MobileMenuConfigVO;

		static public var fxProcess : Function; //called when we cannot process an item  
		static public var fxBack : Function; //called when you do not want to use switchScreens
		
		override public function onRemove():void
		{
			ev.unmapAll(); 
			super.onRemove()
		}
		override public function onRegister():void
		{
			ev.init( this.ui ) ; 
			ev.addEv( PopupMenuActionView.GO_BACK, this.onGoBack )
			ev.addEv( PopupMenuActionView.DATA_CHANGED, this.onDataChanged )	
			ev.addEv( PopupMenuActionView.LIST_CHANGED, this.onListChanged )	
			
			this.convertArrayInDp([
				/*	
				[PLAY_ALL,  null],
				[STOP_ALL_SOUNDS, null],
				//[ABOUT, null],
				[SET_RINGTONE, null],*/
				//[SETTINGS, null],
				[REPORT_PROBLEM, null],
				[RATE, null],
				[SHARE, null],
				[MORE, null],
				[BACK, null]
			]); 
			
			this.styilzeDP()
			this.defaultDp = new ArrayCollection(this.dp.toArray() )
			if ( this.ui.defaultConfig != null ) 
				this.defaultDp = new ArrayCollection( this.ui.defaultConfig.options )
			this.ui.dp = this.defaultDp		
			
			this.context.mapEvent( CallNativeCommandDefaultTriggerEvent.PROCESS, CallNativeCommandDefault )
			//you can do the rest in your own context
			this.onDataChanged(null)
		}
		
		private function convertArrayInDp(sets:Array):void
		{
			//this.ui.list.predefinedItemRenderer="DefaultListItemRenderer3"
			var arr : Array = [] 
			for(var i : int = 0; i < sets.length; i++)
			{
				/*var set : Array = sets[i]
				var item : DefaultListItemRenderer3 = new DefaultListItemRenderer3(set[0], set[1])
				item.titleFontSize = 18;
				item.titleColor = 0x000000
				item._titleColor = 0x000000
				item.titleSelectedColor = 0xd2d2d2; 
				item.titleFontFamily = 'myFontFamily'
				item.subtitleColor = 0xFF0000;
				arr.push(item)*/
				
				var set : Array = sets[i]
				var item :  String =  set[0] 
				arr.push(item)
			}			
			
			this.dp = new ArrayCollection( arr ) ; 
		}
		
		private function styilzeDP():void
		{
			/*	for(var i : int = 0; i < dp.length; i++)
			{
			var item : DefaultListItemRenderer3 = dp[i] as  DefaultListItemRenderer3 
			item.titleFontSize = 18;
			item.titleColor = 0x000000
			item._titleColor = 0x000000
			item.titleSelectedColor = 0xd2d2d2; 
			item.titleFontFamily = 'myFontFamily'
			//item.subtitleColor = 0xFF0000
			//(myDLIR3[i] as DefaultListItemRenderer3).subtitleFontStyle = "italic";
			}*/
			
		}
		
		private function onGoBack(e:Object=null):void
		{
			trace('PopupMenuActionViewMediator', 'go back')
			if ( fxBack != null ) 
			{fxBack(); return }
			this.dispatch(SwitchScreensTriggerEvent.GoBack(null, true ) ) 
		}
		
		private function onDataChanged(e:Object):void
		{
			//might have to write surpession routinse 
			
			//this.onSelectAction( Ringtone  )
			if ( this.ui._data  != null ) 
			{
				if ( this.ui._data is MobileMenuConfigVO ) 
				{
					this.config = this.ui._data as MobileMenuConfigVO; 
					this.config.process( this.dp, this.defaultDp ) ; 
					this.ui.dp = this.dp; 
				}
			}
			else
			{
				this.ui.dp = new ArrayCollection( this.defaultDp.toArray() )  
			}
			this.lastItem = null; 
		}
		
		private function onSelectAction(o  :   String ) : void
		{
			/*	if ( PlatformGlobals.ELIPS ) 
			{
			o = o.target.label
			}*/
			
			if ( o == BACK ) 
			{
				this.onGoBack(); 
				return
			}
			else  if ( o == SETTINGS ) 
			{
				this.onGoBack(); 
				this.dispatch( SwitchScreensTriggerEvent.GoTo(SwitchScreensTriggerEvent.settings)  ) 
				return
			}
			else
			{
				if ( this.ui.fxAction != null ) 
				{
					this.ui.fxAction( o ) ; 
				}
				else
				{
					var e : Event  = new CallNativeCommandDefaultTriggerEvent(CallNativeCommandDefaultTriggerEvent.PROCESS, o)
					this.dispatch( e   ) 
					if ( e.isDefaultPrevented() == false )
					{
						fxProcess(o); 
					}
				}
				this.onGoBack(); 
			}
			
		}
		
		protected function onListChanged(event:CustomEvent):void
		{
			this.ui.list.selectedItem = null; 
			//this.ui.list.selectedItem = null 
			//this.ui['list'].selectedIndex = -1; 
			var data : Object= event.data 
			//double dispatch error ... might be adl thing ....
			if ( this.lastItem == data ) 
				return; 
			this.lastItem = data; 
			if ( event.data is String ) 
			{
				this.onSelectAction( data.toString() )  
			}
			if ( event.data is MobileMenuItemVO ) 
			{
				var m : MobileMenuItemVO = event.data as MobileMenuItemVO
				this.config.fx( m.label ) ; 
			}
			
			//this.model.playSound( sound ) ; 
		}
		
		
	}
}