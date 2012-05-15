package org.syncon.TalkingClock.controller
{
	
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	import mx.styles.CSSStyleDeclaration;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.CncSim.model.NightStandConstants;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.vo.MapHelper;
	import org.syncon.CncSim.vo.NightStandConfigVO;
	import org.syncon.TalkingClock.vo.VoiceVO;
	
	public class CopyOfConfigCommand extends Command
	{
		[Inject] public var model:NightStandModel;
		[Inject] public var event:ConfigCommandTriggerEvent;
		private var seqId : int = -1
		private var timerTimeout : Timer = new Timer(4000)
		private var debug : Boolean = true
		private var alert : Boolean = false; 
		private var notAuthenticatedRetryTimer : Timer;
		private var retryWaitForAuthenticationCount : int = 0 ;
		/**
		 * Max retry count for events
		 * */
		private var retryCount : int = 2 ;		
		/**
		 * Remove all references to Alert for mobile test.
		 * */
		static public var FxAlert : Function = null; 
		private var filename:String='config.txt';
		
		override public function execute():void
		{
			return;
			if ( event.type == ConfigCommandTriggerEvent.SAVE_AND_LOAD_CONFIG ) 
			{
				this.loadConfigWhenFinishedSaving = true; 
				//always reload config when saved to verify ... 
				this.saveConfig() 
			}
			if ( event.type == ConfigCommandTriggerEvent.LOAD_CONFIG ) 
			{
				this.loadConfig()
			}
			if ( event.type == ConfigCommandTriggerEvent.SAVE_CONFIG ) 
			{
				this.saveConfig()
			}				
			
		}
		
		private var ui : UIComponent; 
		private var loadConfigWhenFinishedSaving:Boolean;
		private function loadConfig():void
		{
			
			var config : NightStandConfigVO = NightStandConstants.FileLoader.readObjectFromFile("config.txt", this.loadConfigPart2 ) as NightStandConfigVO;
			if ( config != false ) 
				this.loadConfigPart3( config ) ; 
		}
		public function loadConfigPart2( c : Object ) : void
		{
			var map : Object = {currentVoice:VoiceVO, voices:[VoiceVO]}
			//specify function to help arrange alarms adn so forth ..
			map.__baseClass = NightStandConfigVO //FrontPageResultVO ;
			try 
			{
				var config : NightStandConfigVO =MapHelper.map( map , c ) as NightStandConfigVO
			}
			catch(e:Error ) 
			{
				config =MapHelper.map( map , c ) as NightStandConfigVO
				config = new NightStandConfigVO(); 
			}
			this.loadConfigPart3( config ) ; 
		}
		public function loadConfigPart3( config : NightStandConfigVO ) : void
		{
			this.ui = this.contextView as UIComponent; 
			var noConfig: Boolean = false; 
			var css : CSSStyleDeclaration = this.ui.styleManager.getStyleDeclaration('global')
			var fontSize : Number = css.getStyle('fontSize'); 
			var appStyle : CSSStyleDeclaration = this.ui.styleManager.getStyleDeclaration('spark.components.ViewNavigatorApplication')
			//var fontSize : Number = css.getStyle('fontSize'); 
			if ( config == null ) 
			{
				noConfig = true; 
				config = new NightStandConfigVO(); 
			}	
			
			//config.importSelf(); 
			
			
			
			if ( this.ui != null && this.cachingNavigator() ) 
			{
				this.ui['navigator'].cachingMode = config.hiSpeedMode; 
			}
			if ( noConfig ) 
			{
				config.fontSize = fontSize; 
				config.voices = makeFirstConfig(); 
				this.model.loadVoices( config.voices ) 
				config.currentVoice = config.voices[0];
				//t/his.model.config = config;
				this.model.currentVoice = config.currentVoice;
				return; 
			}
			
			if ( fontSize != config.fontSize && ! isNaN( config.fontSize ) && config.fontSize > 0 ) 
				css.setStyle('fontSize', config.fontSize );
			var white : uint = 0xFFFFFF; 
			var black : uint = 0; 
			var currentTextColor : uint = css.getStyle('color');
			var newTextColor : uint = config.reverseText ? white : black 
			var newBgColor : uint = config.reverseText ? black : white 				
			if ( currentTextColor != newTextColor ) 
			{
				css.setStyle('color', newTextColor) ; 
				appStyle.setStyle('backgroundColor', newBgColor ) ;
			}
			//if lost all voices, start fresh
			if ( config.voices.length == 0 )
			{
				config.voices = makeFirstConfig();
				if ( config.currentVoice == null ) 
					config.currentVoice = config.voices[0];
			}
			
			
			if ( config.currentVoice == null ) 
				config.currentVoice = makeFirstConfig()[0]
			
			this.model.loadAlarms( config.alarms ) ; 
		//	this.model.config = config
			this.model.currentVoice = config.currentVoice; 
			this.model.loadVoices( config.voices ) 
		}
		
		private function cachingNavigator(): Boolean
		{
			if ( this.ui != null && this.ui.hasOwnProperty('navigator' ) && this.ui['navigator'].hasOwnProperty('cachingMode' ) )
				return true;
			return false; 
		}
		
		private function makeFirstConfig():Array
		{
			var v : VoiceVO = new VoiceVO(); 
			v.path = 'voices/chav/'
			//v.path = 'G:\My Documents\work\flex4\Mobile2\TalkingClock\bin-debug\voices\chav'; 
			v.name = 'Chav'; 
			v.pic = 'pic.jpg'
			var configs : Array = 	[ v ]
			
			
			v = new VoiceVO(); 
			v.path = 'voices/british/'
			//v.path = 'G:\My Documents\work\flex4\Mobile2\TalkingClock\bin-debug\voices\chav'; 
			v.name = 'British'; 
			v.pic = 'pic.jpg'
			configs.push( v ) 
			
			return configs;
		}
		
		private function saveConfig(): Boolean
		{
			//this.model.config.alarms = this.model.alarmList.toArray();
			//this.model.config.currentVoice = this.model.currentVoice;
			//it is important that this always calls the post save fx ....
			return NightStandConstants.FileLoader.writeObjectToFile( this.model.config, filename, configSaved ) ; 
		}
		
		private function configSaved(o:Object=null):void
		{
			if ( this.loadConfigWhenFinishedSaving  ) 
				this.loadConfig()
		}
		
	}
}