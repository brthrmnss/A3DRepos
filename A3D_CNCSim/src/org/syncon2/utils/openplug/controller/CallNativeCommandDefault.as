package org.syncon2.utils.openplug.controller
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon2.utils.mobile.AndroidExtensions_OpenPlug;
	
	/**
	 * Will encapuslate all native calls 
	 * Only call that aer to be shared across all applications
	 * */
	public class CallNativeCommandDefault extends Command
	{/*
		air.org
		*/
		static public var PACKAGE_NAME :  String = ''; 
		static public var APP_NAME : String = ''; 
		static public var DEV_NAME : String = 'SynCo Systems'; 
		[Inject] public var event:CallNativeCommandDefaultTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == CallNativeCommandDefaultTriggerEvent.PROCESS ) 
			{
				this.onProcess() 
			}
			
			
		}
		
		private function onProcess():void
		{
			var o : String = event.command; 
			var handled : Boolean = false
			switch(o)
			{
				case CallNativeCommandTriggerEvent.REPORT_PROBLEM:
				{
					this.reportProblem()
					handled = true
					//var a  : AndroidExtensions_OpenPlug = new AndroidExtensions_OpenPlug(); 
					//a.reportProblem(this.model.config.package_name); 
					break;
				}
				case CallNativeCommandTriggerEvent.RATE:
				{
					var a  : AndroidExtensions_OpenPlug = new AndroidExtensions_OpenPlug(); 
					a.rateApp( PACKAGE_NAME); 
					handled = true
					break;
				}
				case CallNativeCommandTriggerEvent.MORE:
				{
					//"synco+systems"+alarm
					a  = new AndroidExtensions_OpenPlug(); 
					//a.goToStore('', 'SynCo+Systems' ); 
					a.goToStore( '"'+DEV_NAME+'"' ); 
					handled = true
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
					handled = true
					break;
				}					
				case CallNativeCommandTriggerEvent.ABOUT:
				{
					//this.dispatch( new  InitMainContextCommandTriggerEvent(InitMainContextCommandTriggerEvent.EXIT_APP) ) 
					break;
				}
				case CallNativeCommandTriggerEvent.QUIT:
				{
					handled = true
					//a.goToStore( '' ,'SynCo Systems' ); 
					//	this.dispatch( new  InitMainContextCommandTriggerEvent(InitMainContextCommandTriggerEvent.EXIT_APP) ) 
					break;
				}
				default:
				{
					break;
				}
	
			}
			if ( handled ) 
			{
				event.preventDefault(); 
				event.stopPropagation(); 
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