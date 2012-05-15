package     org.syncon2.utils.mobile.ads.Smaato
{
/*
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.net.InterfaceAddress;
*/
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.utils.StringUtil;


	public final class InternetIPProvider extends EventDispatcher
	{
		// This is an AIR only class
		
		//
		// Properties
		//
		
		private var _ip:String = "";
		
		private var _sites:Array = [
			{siteURL:"http://city-21.com/ip.php"},
														 {siteURL: "http://tejji.com/ip/my-ip-address.aspx/", regExp1:"ExtIP.*>[0-9.]+<", regExp2:">.*<"}
														,{siteURL: "http://www.whatismyip.com/tools/ip-address-lookup.asp", regExp1:"IP\".*value.*[0-9.]+\"", regExp2:"\"[0-9.]+\""}
													]; // sites that provide internet IPs.  Used as a fall-back method.
		private var _currSiteIdx:uint;
		private var _siteLoader:URLLoader;
		
		
		private var _debugTraces:Boolean;

		
		//
		// Methods
		//
		public static var GOT_IP:String='GOT_IP';


		public function InternetIPProvider(debugTraces:Boolean = false):void //CONSTRUCTOR
		{
			_debugTraces = debugTraces;
					
			//NetworkInfo.networkInfo.addEventListener(Event.NETWORK_CHANGE, onNetworkChange, false, 0, true);
			getInternetIP();
		}
		
		
		public function getInternetIP():void
		{
		 
			// Fall-back: let's look at internet sites that provide the IP address
			// Note: it can happen, that although no IP address was found via NetworkInterface.addresses
			// the device is nevertheless connected to the internet.
			// Such a case is when using the "mobile interface" on a smartphone (carrier network)
			getWanIPFromInternetSite(0);
		}


		private function getWanIPFromInternetSite(siteIdx:uint):void
		{
			// This function connects to a site providing the internet IP of the device, and parses its html for the wan IP.
			_currSiteIdx = siteIdx;
			
			if (_siteLoader) // from a previous try
			{
				_siteLoader.removeEventListener(Event.COMPLETE, onSiteLoaderComplete, false);
				_siteLoader.removeEventListener(IOErrorEvent.IO_ERROR, onSiteLoaderError, false);
				_siteLoader = null;
			}
			
			_siteLoader = new URLLoader();
			
			_siteLoader.addEventListener(Event.COMPLETE, onSiteLoaderComplete, false, 0, true);
			_siteLoader.addEventListener(IOErrorEvent.IO_ERROR, onSiteLoaderError, false, 0, true);

			_siteLoader.load( new URLRequest( _sites[siteIdx].siteURL ) );
		}
		
		
		private function onSiteLoaderComplete(evt:Event):void
		{
			var dataStr:String = evt.target.data.toString();

			//trace("\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");			
			//trace( dataStr );
	
		
			var ipStr:String = ""; // what we are tryingto find
			
			var foundArr:Array = dataStr.match( new RegExp( _sites[_currSiteIdx].regExp1 ) ); // apply first regular expression
			
			if (foundArr != null ) // not null
			{
				ipStr = foundArr[0];
				
				if ( (_sites[_currSiteIdx].regExp2 != undefined) && (_sites[_currSiteIdx].regExp2 != "") ) // apply second regular expression
				{
					foundArr = ipStr.match( new RegExp( _sites[_currSiteIdx].regExp2 ) );
					
					if (foundArr)
						ipStr = foundArr[0];
				}
				
				foundArr = ipStr.match( new RegExp("[0-9.]+" ) ); // strip everything but the numbers and dots
				
				if (foundArr)
					ipStr = foundArr[0];
			}
			if (   _sites[_currSiteIdx].regExp1 == null ) 
			{
				ipStr = StringUtil.trim( dataStr ) ; 
			}
			
			if (ipStr == "") // we didn't find an IP address
			{
				// Try the next site in our list of internet providing sites
				if (_currSiteIdx < (_sites.length - 1) )
					getWanIPFromInternetSite(_currSiteIdx + 1);
				else
					setIP(""); // no internet site was found		
			}
			else // we found an IP address
				setIP(ipStr);
		}
		

		private function onSiteLoaderError(evt:Event):void
		{
			if (_currSiteIdx < (_sites.length - 1) )
				getWanIPFromInternetSite(_currSiteIdx + 1); // try the next site in our list of internet providing sites
			else
				setIP(""); // no internet site was found
		}
		
		
		private function onNetworkChange(evt:Event):void
		{
			getInternetIP();
			
			if (_debugTraces)
				listNetworkInfo();
		}
	
	
		public function get ip():String
		{
			return _ip;
		}
		
		
		private function setIP(ipStr:String):void
		{
			if (_siteLoader) // Bit of cleanup, in case the ip came from an internet providing site
			{
				_siteLoader.removeEventListener(Event.COMPLETE, onSiteLoaderComplete, false);
				_siteLoader.removeEventListener(IOErrorEvent.IO_ERROR, onSiteLoaderError, false);
				_siteLoader = null;
			}
			
			_ip = ipStr;
			//dispatchEvent(new Event(Event.NETWORK_CHANGE)); // Used by a listener on the SmaatoProvider
			dispatchEvent(new Event(GOT_IP));
			
		}
		
	
		public function listNetworkInfo(traceList:Boolean = true):String
		{
			var netInfoStr:String = "";
			
		 
			netInfoStr += "Using ip: " + _ip + "\n";

			if (traceList)
				trace(netInfoStr);
			
			return(netInfoStr);
		}
		

	}
}