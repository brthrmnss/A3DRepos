package org.syncon2.utils.openplug.controller
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.RosettaStone.model.RSModel;
	import org.syncon.TalkingClock.model.NightStandModel;
	import org.syncon2.utils.mobile.AndroidExtensions_OpenPlug;
	
	/**
	 * Will encapuslate all native calls 
	 * */
	public class CallNativeCommand extends Command
	{/*
		air.org
		*/
		static public var PACKAGE_NAME :  String = ''; 
		static public var APP_NAME : String = ''; 
		[Inject] public var model:RSModel;
		[Inject] public var event:CallNativeCommandTriggerEvent;
 		
		public var injections  : Array = ['model', RSModel] 
		override public function execute():void
		{
			if ( event.type == CallNativeCommandTriggerEvent.PROCESS ) 
			{
				 this.onProcess() 
			}
			
			
		}
		
		private function onProcess():void
		{
			var o : String = event.command; 
			switch(o)
			{
				case CallNativeCommandTriggerEvent.STOP_ALL_SOUNDS:
				{
					//this.onStopAllSounds()
					this.model.stopSound()
					break;
				}
				case CallNativeCommandTriggerEvent.REPORT_PROBLEM:
				{
					this.reportProblem()
					//var a  : AndroidExtensions_OpenPlug = new AndroidExtensions_OpenPlug(); 
					//a.reportProblem(this.model.config.package_name); 
					break;
				}
				case CallNativeCommandTriggerEvent.RATE:
				{
					var a  : AndroidExtensions_OpenPlug = new AndroidExtensions_OpenPlug(); 
					a.rateApp( PACKAGE_NAME); 
					break;
				}
				case CallNativeCommandTriggerEvent.MORE:
				{
					//"synco+systems"+alarm
					a  = new AndroidExtensions_OpenPlug(); 
					//a.goToStore('', 'SynCo+Systems' ); 
					a.goToStore( '"SynCo Systems"' ); 
					break;
				}
			/*	case CallNativeCommandTriggerEvent.PLAY_ALL:
				{
					//this.onPlayAll(); 
					break;
				}*/
				case CallNativeCommandTriggerEvent.SHARE:
				{
					//var appname : String = "air.org.syncon.ODBViewer"
					a  = new AndroidExtensions_OpenPlug(); 
					a.shareApp(   APP_NAME, "Check out this app "+"http://market.android.com/details?id="+PACKAGE_NAME,
						"Tell a friend about "+APP_NAME  );//+ ' '  +  this.model.config.subtitle); //com.example.yourpackagename" ); 
					break;
				}					
				case CallNativeCommandTriggerEvent.ABOUT:
				{
					//this.dispatch( new  InitMainContextCommandTriggerEvent(InitMainContextCommandTriggerEvent.EXIT_APP) ) 
					break;
				}
				case CallNativeCommandTriggerEvent.SET_RINGTONE:
				{  
					this.model.alert(
						"Press on a sound and hold for a second to bring up the ringtone changer.", 'Help'  )  
					break;
				}
					
				case CallNativeCommandTriggerEvent.QUIT:
				{
					//a.goToStore( '' ,'SynCo Systems' ); 
				//	this.dispatch( new  InitMainContextCommandTriggerEvent(InitMainContextCommandTriggerEvent.EXIT_APP) ) 
					break;
				}
				default:
				{
					break;
				}
			}
		}		
		
		private function reportProblem():void
		{
			var urlString:String = "mailto:";
			urlString += 'info.sync.con@gmail.com'
			urlString += "?subject="
			urlString += 'Problem With "' + APP_NAME + '"'
			navigateToURL(new URLRequest(urlString));
		}
		
		
	}
}