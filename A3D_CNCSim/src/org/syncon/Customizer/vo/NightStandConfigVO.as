package  org.syncon.Customizer.vo
{
	import mx.collections.ArrayList;

	[RemoteClass]
	public class NightStandConfigVO  
	{
		public var hiSpeedMode : Boolean = false; 
		
		public var storeVerses : Boolean = true; 
		public var reverseText:Boolean;
		
		public var voices : Array  = [] ;
		public var currentVoice:  VoiceVO;
		
		private var _fontSize : Number = NaN; 
 
		
		public function get fontSize():Number
		{
			return _fontSize;
		}
		
		public function set fontSize(value:Number):void
		{
			_fontSize = value;
		}
		
		
		public var format24Hours : Boolean = false ; 
		public var showDate : Boolean = true; 
		public var showSeconds : Boolean = true ; 
		public var showDayOfWeek : Boolean = true; 
		public var helpShown:Boolean=false;
		
		public var intervalSeconds : Number = 0 ; 
		public var intervalMinutes : Number =1 ; 
		public var enableVoice : Boolean = true; 
		
		public var alarms : Array = [] ; 
		public var speakOnShake:Boolean=true;
		
		
	}
}