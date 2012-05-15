package  org.syncon2.utils.mobile.controller
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import mx.effects.Move;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.mvcs.Context;
	import org.syncon2.utils.openplug.Constants;
	
	//import outside.PlatformGlobals;
	
	public class SwitchScreensCommand extends  Command
	{
		private var _event:   SwitchScreensTriggerEvent;		
		
		[Inject]
		public function get event():SwitchScreensTriggerEvent
		{
			return _event;
		}
		
		public function set event(value:SwitchScreensTriggerEvent):void
		{
			_event = value;
		}
		
		//[Inject] public var model :  NewsAppModel;
		static public var forceFlex : Boolean = false; 
		static public var fxSwitchScreens : Function
		static public var history : Array = []; //really is this necesary we know it works ...need to test back btns in code
		static public var EnabledTransitions : Boolean = false; 
		override public function execute():void
		{
			
			if ( fxSwitchScreens == null ) 
				throw 'Init SwitchScreensCommand First' 
			if ( event.type == SwitchScreensTriggerEvent.GO_TO_SCREEN_NAMED ) 
			{
				trace('SwitchScreensCommand', 'GO_TO_SCREEN_NAMED', event.name )
				//handle Alt Actions, allow user to prevent this from happening 
				if ( SwitchScreensTriggerEvent.AltActions[event.name] != null && event.alternateChecked == false ) 
				{
					SwitchScreensTriggerEvent.AltActions[event.name]();
					if ( event.history == false && SwitchScreensTriggerEvent.SkipHistoryOn.indexOf( event.name) == -1  )  
						pushHistory(event); 
					return; 
				}
				
				/*					if ( event.selectedChild == null ) 
				{
				event.selectedChild = getScreenByName(event.name)
				}
				if ( event.selectedChild != null ) 
				{
				var f : Object = event.selectedChild.getStyle('showEffect');
				var o : Object = f[0]
				}*/
				
				if ( EnabledTransitions ) 
				{
					var o : Object  = getScreenByName(event.name)
					if ( o !=  null ) 
					{
						var f : Object = o.getStyle('showEffect');
						var firstEffect : Object = f.children[0]
						firstEffect;
						if ( firstEffect is Move ) 
							this.adjustSettings(  firstEffect as Move, event.history ) 
					}
					  o   = appSelectedItem()
					if ( o !=  null ) 
					{
						var ff: Object = o.getStyle('hideEffect');
						var firsHidetEffect : Object = ff.children[0]
						if ( firsHidetEffect is Move ) 
							this.adjustHideEffect(  firsHidetEffect as Move, event.history ) 
					}
				}
				//if data model necessary, ... we'll use it since it was so prevelant, but 
				//might be temprary 
				event.selectedChild = fxSwitchScreens( event.name, event.data ) 
				
				if ( Constants.flex || forceFlex )
				{
					if ( event.history == false   )  
					{
						if  ( SwitchScreensTriggerEvent.SkipHistoryOn.indexOf( event.name) == -1 )
						{
							pushHistory(event);
						}
						else
						{
							currentScreen  = event;
						}
					}
				}
				
			}
			if ( event.type == SwitchScreensTriggerEvent.GO_BACK ) 
			{
				trace('SwitchScreensCommand', 'GO_BACK', event.name, event.data, forceFlex )
				//if dta specified compar item 
				if ( event.data != null ) 
				{
					var dbg : Object = appSelectedItem()  
					if ( appSelectedItem()   != event.data ) 
					{
						return;
					}
				}
				if ( event.name != null ) 
				{
					var selectedChild : Object = appSelectedItem()  
					if ( selectedChild.id   != event.name ) 
					{
						return;
					}
				}
				if ( Constants.flex == false && forceFlex == false ) 
				{
					trace('SwitchScreensCommand', 'go back')
					//PlatformGlobals.show( this.contextView + ' is ' , 'go back' ) 
					this.contextView['goBack'](  )
				}
				else
				{
					var hist : Object = history; 
					var popHistory2x : Boolean  = true 
					
					//so back button on menu does not Leave App 
					
					
					
					if (  currentScreen != null && SwitchScreensTriggerEvent.SkipHistoryOn.indexOf( currentScreen.name) != -1    ) 
					{
						popHistory2x = false; 
						//trace('pop history 2x == false' ) 
					}
					
					var e  :  SwitchScreensTriggerEvent = popHistory(); 
					
					if ( popHistory2x ) 
					{
						if ( event.popOnce == false ) //in reality you coud check teh current item, if it matches what was sent in? 
							e  =popHistory(); //one more to previoues
					}
					if ( e == null ) 
					{
						e = new SwitchScreensTriggerEvent(SwitchScreensTriggerEvent.GO_TO_SCREEN_NAMED, ''); 
					}
					else
					{
						pushHistory( e ) ; 
					}
					e.history = true; 
					//if ( this.context != null ) 
					trace('SwitchScreensCommand', 'redistpach', e.name)
					this.dispatch( e as Event ) ; 
				}
			} 			
			
		} 
		
		private function adjustSettings(fx:Move, history:Boolean):void
		{
			if ( getAppWidth == null ) return; 
			var width  :Number  =  getAppWidth(); 
			if ( history == false ) 
			{
				// TODO Auto Generated method stub
				fx.xFrom = width; 
				fx.xTo = 0 ; 
			}
			else 
			{
				fx.xFrom = -width; 
				fx.xTo =  0 ;
			}
		}		
		
		private function adjustHideEffect(fx:Move, history:Boolean):void
		{
			if ( getAppWidth == null ) return; 
			var width  :Number  =  getAppWidth(); 
			if ( history == false ) 
			{
				// TODO Auto Generated method stub
				fx.xFrom = 0; 
				fx.xTo = -width ; 
			}
			else 
			{
				fx.xFrom = 0; 
				fx.xTo =  width ;
			}
		}		
		
		
		public function pushHistory( h :  SwitchScreensTriggerEvent ) : void
		{
			currentScreen = h ; 
			var hist  :Object = history; 
			history.push( h ) ; 
		}
		public function popHistory( ) : *
		{
			var hist  :Object = history; 
			return history.pop(); 
		}
		static public var currentScreen :   SwitchScreensTriggerEvent; 
		/**
		 * Returns select item on nvaigation stack ..
		 * */
		static public var appSelectedItem :   Function; 
		static public var app : Object; 
		static public var getScreenByName : Function; 
		static public var getAppWidth : Function; 
		static public function goBack(ifOnScreen: Object=null) : void
		{
			//either is more convient ...
			if ( ifOnScreen is String ) 
			{
				var eve1 : SwitchScreensTriggerEvent = new SwitchScreensTriggerEvent(
					SwitchScreensTriggerEvent.GO_BACK, ifOnScreen.toString() );
			}
			else
			{
				eve1 = new SwitchScreensTriggerEvent(
					SwitchScreensTriggerEvent.GO_BACK, null, ifOnScreen);
			}
			
			app['context'].dispatchEvent( eve1  ) 
			return 
			/*
			if ( PlatformGlobals.flex == false ) 
			{
			app['goBack'](  )
			}
			else
			{
			var eve1 : SwitchScreensTriggerEvent = new SwitchScreensTriggerEvent(SwitchScreensTriggerEvent.GO_BACK, ifOnScreen);
			/*var hist : Object = history; 
			var e  :  SwitchScreensTriggerEvent = history.pop(); 
			if ( ifOnScreen != null ) 
			{
			if ( e == null ) 
			return; 
			if ( e.name != ifOnScreen.id ) 
			return; 
			}
			//go back one more 
			e  = history.pop(); 
			history.push( e ) ; 
			if ( e == null ) 
			e = new SwitchScreensTriggerEvent(SwitchScreensTriggerEvent.GO_TO_SCREEN_NAMED, ''); 
			e.history = true; 
			*/
			/*		app['context'].dispatchEvent( e as Event ) 
			}*/
			/*var c : SwitchScreensCommand = new SwitchScreensCommand()
			c.event =   SwitchScreensTriggerEvent.GoBack(ifOnScreen)
			c.context = new Context()
			c.context.app = app
			c.contextView = app as DisplayObjectContainer
			c.execute(); */
		}
	}
}