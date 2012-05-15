package  org.syncon2.utils.mobile.controller
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class SwitchScreensTriggerEvent extends Event
	{
		public static const GO_TO_SCREEN_NAMED:String = 'goToScreenNamed';
		/**
		 * Return to previous screen
		 * */
		public static const GO_BACK:String = 'goBack';
		/*		static public const SCREEN_STORY_1 : String = 'screen1'; 
		static public const SCREEN_STORY_2 : String = 'screen2'; 
		static public const SCREEN_STORY_3 : String = 'screen3'; 
		static public const SCREEN_STORY_4 : String = 'screen4'; 
		static public const SCREEN_ABOUT : String = 'screenAbout'; 		
		static public const SCREEN_STORY_VIEWER : String = 'story'; 		*/
		
		public var name :   String = ''; 
		public var data:Object;
		public var history : Boolean = false;
		
		public var selectedChild : Object; 
		
		/**
		 * Prevent loops by blocking out these alternates if used
		 * */
		public var alternateChecked : Boolean = false; 
		public static var POPUP_RINGTONE_ACTION:String = 'popupRingToneAction';
		public static var POPUP_MENU_ACTION:String = 'popupMenuAction';
		public static var PLAYER_VIEW : String = 'playerView2'; 
		public static var SELECT_PACKAGE : String = 'packageSelectView'; 
		public static var SELECT_LESSON_GROUP : String = 'groupSelectView'; 
		public static var SELECT_LESSON : String = 'lessonSelectView'; 		
		public static var PLAYER_VIEW2 : String = 'playerView2';
		static public const POPUP_LESSON_COMPLETE : String = 'popupLessonComplete'; 		
		static public const popupGroupComplete : String = 'popupGroupComplete'; 	
		static public const home : String = 'home'; 	
		static public const exitView : String = 'exitView'; 
		static public const curriculum : String = 'curriculum'; 	
		static public const selectProduct : String = 'selectProduct'; 	
		static public const startEnrollment : String = 'startEnrollment'; 	
		
		static public const settings : String = 'settings'; 	
		static public const gettingStarted : String = 'gettingStarted'; 
		static public const menu : String = 'menu'; 	
		
		static public const changeUser : String = 'changeUser'; 	
		static public const progressReport : String = 'progressReport'; 	
		
		
		static public var SkipHistoryOn : Array = []; // [menu] 
		/*
		if a screen is set here ... we will call thsi function instead ... 
		*/
		static public var AltActions : Dictionary = new Dictionary(); 
		/**
		 * only used by popups so far ... do not remove two history items, just once
		 * */
		public var popOnce:Boolean;
		
		public function SwitchScreensTriggerEvent(type:String, name_ :   String=null, data  : Object = null    )
		{
			this.name = name_
			this.data = data; 
			super(type);
		}
		
		override public function clone():Event{
			var e : SwitchScreensTriggerEvent = new SwitchScreensTriggerEvent(type, name, data);
			e.popOnce = this.popOnce; 
			e.history = this.history
			e.alternateChecked = this.alternateChecked
			return e;
		}
		
		
		static public function GoTo(  name_ :   String=null, data  : Object = null , alternateChecked : Boolean = false   ) : SwitchScreensTriggerEvent
		{
			var e : SwitchScreensTriggerEvent = new SwitchScreensTriggerEvent(
				SwitchScreensTriggerEvent.GO_TO_SCREEN_NAMED, name_, data
			) 
			e.alternateChecked = alternateChecked
			return e
		}
		
		static public function GoBack(   ifOnScreen: Object=null, popupOnce : Boolean = false  ) : SwitchScreensTriggerEvent
		{
			var e : SwitchScreensTriggerEvent = new SwitchScreensTriggerEvent(
				SwitchScreensTriggerEvent.GO_BACK ,null,ifOnScreen ) 
			e.popOnce = popupOnce; 
			return e
		}
		
		static public function mapCommands(commandMap :  Object, command : Object ) : void
		{
			var types : Array = [
				GO_TO_SCREEN_NAMED, 
				GO_BACK
			]
			for each ( var commandTriggerEventString : String in types ) 
			{
				commandMap.mapEvent(commandTriggerEventString,  command, SwitchScreensTriggerEvent, false );			
			}
		}	
		
		
		
	}
}