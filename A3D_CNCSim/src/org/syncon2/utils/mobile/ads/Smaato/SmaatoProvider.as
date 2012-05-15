package  org.syncon2.utils.mobile.ads.Smaato
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	//	import flash.sensors.Geolocation;
	
	//import com.yourdomain.InternetIPProvider;
	
	
	public final class SmaatoProvider extends Loader
	{
		// This works only in AIR.
		//
		// The following permissions need to be enabled:
		//
		// 	INTERNET
		// 	READ_PHONE_STATE
		// 	ACCESS_NETWORK_STATE
		// 	ACCESS_WIFI_STATE	
		//
		// For the optional geo-location, the following permissions should be enabled, as well:
		//	
		//	ACCESS_COARSE_LOCATION
		//	ACCESS_FINE_LOCATION
		//
		
		
		// Properties
		//
		
		private var _debugTraces:Boolean;
		
		private var _smaatoReqAdURLLoader:URLLoader;
		private var _smaatoRequest:URLRequest;
		private var _variables:URLVariables;
		private var _smaatoClickURL:String;
		private var _smaatoXMLData:XML;	
		
		private var _ipProvider:InternetIPProvider;
		private var _ip:String = "";
		public var refreshFrequency:Number;		// In seconds
		private var _adTimer:Timer;
		
		//private var _geo:Geolocation;
		private var _geoInterval:Number;
		
		
		// Methods
		//
		
		
		public function SmaatoProvider(pubID:int, adID:int, refreshFreq:Number = 60, geoLocate:Boolean = true, debugTraces:Boolean = false):void // CONSTRUCTOR
		{
			
			_debugTraces = debugTraces;
			
			super();
			
			refreshFrequency = refreshFreq;
			
			_ipProvider = new InternetIPProvider(_debugTraces);
			_ip = _ipProvider.ip;
			trace("_ipProvider.ip = " + _ipProvider.ip);
			
			
			if (debugTraces)
			{
				trace("pubID = " + pubID);
				trace("adID = " + adID);
				trace("_ip = " + _ip);
			}
			
			initSmaato(_ip, pubID, adID);
			//_ipProvider.addEventListener(Event.NETWORK_CHANGE, onNetworkChange, false, 0, true); // Need to be AFTER initSmaato(), bc has a requestSmaatoAd() within
			_ipProvider.addEventListener( InternetIPProvider.GOT_IP, this.onNetworkChange , false, 0, true ); 
			/*
			if (geoLocate)
			enableGeolocation();
			*/
			_adTimer = new Timer(refreshFrequency * 1000, 0);
			_adTimer.addEventListener(TimerEvent.TIMER, onAdTimer, false, 0, true);
			
			if (_ip != "")
			{
				requestSmaatoAd();
				_adTimer.start();
			}
		}
		
		public static var DEVICE : String = 'Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/526.9+ (KHTML, like Gecko) AdobeAIR/1.5'//URLRequestDefaults.userAgent;
		private var beaconLoader:URLLoader;
		public var ownid:String;
		private function initSmaato(ipStr:String, pubID:int, adID:int):void
		{
			_smaatoRequest = new URLRequest("http://soma.smaato.com/oapi/reqAd.jsp");
			_variables = new URLVariables();
			
			// Careful: don't use a with() statement, below, because it doesn't create new properties!
			_variables.pub = pubID;
			_variables.adspace = adID;
			_variables.devip = ipStr;
			_variables.format = "IMG";
			_variables.adcount = 1;
			//_variables.dimension = 'xxlarge';;
			_variables.response = "XML";
		
			_variables.device = DEVICE; //URLRequestDefaults.userAgent;
			if ( this.ownid != null ) 
			{
				_variables.device = ownid;
			}
			_smaatoRequest.data = _variables;
			
			_smaatoReqAdURLLoader = new URLLoader();
			_smaatoReqAdURLLoader.addEventListener(Event.COMPLETE, onSmaatoReqAdLoaderComplete, false, 0, true);
			_smaatoReqAdURLLoader.addEventListener(IOErrorEvent.IO_ERROR, onSmaatoReqAdLoaderIOError, false, 0, true);
			//_smaatoReqAdURLLoader.addEventListener(.IO_ERROR, onSmaatoReqAdLoaderIOError, false, 0, true);
			
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, onSmaatoAdLoaderComplete, false, 0, true);
			
			//this.addEventListener(MouseEvent.CLICK, onSmaatoAdClicked, false, 0, true);
			
			//requestSmaatoAd()
		}
		
		
		public function requestSmaatoAd():void
		{
			try
			{
				_smaatoReqAdURLLoader.load(_smaatoRequest);
			}
			catch(err:Error)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR) );
			}
		}
		
		
		private function onSmaatoReqAdLoaderIOError(evt:IOErrorEvent):void
		{
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR) );
		}
		
		
		private function onSmaatoReqAdLoaderComplete(evt:Event):void
		{
			// Below: if the internet is not available, this can cause evt.target.data to fail
			var data : String = evt.target.data as String
			try
			{
				if ( data.indexOf( '\n') != -1 ) 
				{
					var sets : Array = data.split('\n' ) ; 
				}
				var finalSets : Array = [] ; 
				for each ( var s  : String in sets ) 
				{
					s = s.replace('\n','')
					s = s.replace("\r",'')
					if ( s != '' ) 
						finalSets.push( s ) 
				}
				data = finalSets[finalSets.length-1].toString().replace('\n', '' )
				try {
					_smaatoXMLData = new XML( data );
				}
				catch ( e : Error ) 
				{
					_smaatoXMLData = new XML( data+'</response>' );
					var dbg : Array  = [_smaatoXMLData.children()[0]] 
					_smaatoXMLData = dbg[0];//_smaatoXMLData.children().child(0);
					//_smaatoXMLData = _smaatoXMLData.*::response;//.*::response
				}
				var status:String = _smaatoXMLData.*::status.toString();
				
				if (_debugTraces)
					trace("xmlData = " + _smaatoXMLData);
				
				if (status == "success")
				{
					var ad:XMLList = _smaatoXMLData.*::ads.*::ad;
					var link:String = ad.*::link.toString();					
					
					_smaatoClickURL = ad.*::action.@target.toString();
					var beacons:XMLList = _smaatoXMLData.*::ads.*::ad.*::beacons.*::beacon;
					var beacon:String = beacons.toString();	
					var adreq:URLRequest = new URLRequest(link);
					adreq.data = _variables; // may not be necessary but just in case
					this.load( adreq );
					
					var reqBeacon:URLRequest = new URLRequest(link);
					this.beaconLoader = new URLLoader();
					this.beaconLoader.load(  reqBeacon ) 
					beaconLoader.addEventListener(Event.COMPLETE, onBeaconLoaderComplete, false, 0, true);
					beaconLoader.addEventListener(IOErrorEvent.IO_ERROR, onBeaconLoaderIOError, false, 0, true);
					
				}
				else
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR) );
			}
			catch(err:Error)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR) );
			}
		}
		
		protected function onBeaconLoaderIOError(event:IOErrorEvent):void
		{
			return;
		}
		
		protected function onBeaconLoaderComplete(event:Event):void
		{
			return;
		}		
		
		public function onSmaatoAdClicked(evt:  Event):void
		{
			var req:URLRequest = new URLRequest(_smaatoClickURL);
			req.data = _variables; // this will pass the needed userAgent
			
			navigateToURL( req );
		}		
		
		
		private function onNetworkChange(evt:Event):void
		{
			ip = evt.target.ip;  // triggers the setter, below
		}
		
		
		public function set ip(ipStr:String):void
		{
			_ip = ipStr;
			
			if (_ip != "")
			{
				_variables.devip = _ip;
				//_smaatoRequest.data = _variables; // Not needed, since "data" refers to _variables already
				//trace("_variables.devip = " + _variables.devip + "\t_smaatoRequest.data.devip = " + 	_smaatoRequest.data.devip);
				requestSmaatoAd();
				
				if (!_adTimer.running)
				{
					_adTimer.reset();
					_adTimer.start();
				}
			}
			else
			{
				_adTimer.stop();
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR) );
			}
		}
		
		
		public function get ip():String
		{
			return _ip;
		}
		
		
		private function onAdTimer(evt:TimerEvent):void
		{
			if (_ip != "")
				requestSmaatoAd();
		}
		
		
		private function onSmaatoAdLoaderComplete(evt:Event):void
		{
			this.dispatchEvent( new Event(Event.CHANGE) );
			
			/*
			// Disabled: this step is done in the container of this
			// Reposition the ad
			// Note: evt.target = this.contentLoaderInfo
			with(evt.target)
			{
			loader.y = this.stage.stageHeight - height;
			loader.x = (this.stage.stageWidth - width) * 0.5;
			}
			*/
		}
		
		
		public function get data():XML
		{
			return _smaatoXMLData;
		}
		
		
		public function get adTimer():Timer
		{
			return _adTimer;
		}
		
		
		public function get ipProvider():InternetIPProvider
		{
			return _ipProvider;
		}
		
		
		public function get variables():URLVariables
		{
			// Note this is a pass by reference!
			return _variables;
		}
		
		/*	
		public function enableGeolocation(interval:Number = 1800000):void
		{
		// interval default is 30 minutes (expressed in millisecs)
		//
		// Note: make sure to enable permissions for ACCESS_COARSE_LOCATION and ACCESS_FINE_LOCATION
		
		if ( Geolocation.isSupported ) 
		{
		_geoInterval = interval;
		
		_geo = new Geolocation();
		_geo.addEventListener(StatusEvent.STATUS, onGeoStatusChange, false, 0, true);
		
		if (!_geo.muted)
		_geo.addEventListener(GeolocationEvent.UPDATE, onGeoUpdate, false, 0, true);
		}
		}
		
		
		private function onGeoUpdate(evt:GeolocationEvent):void
		{
		_variables.gps = evt.latitude.toString() + "%2C" + evt.longitude.toString();
		evt.target.setRequestedUpdateInterval(_geoInterval);
		}
		
		
		private function onGeoStatusChange(evt:StatusEvent):void
		{
		if (evt.target.muted)
		evt.target.removeEventListener(GeolocationEvent.UPDATE, onGeoUpdate, false);
		else
		evt.target.addEventListener(GeolocationEvent.UPDATE, onGeoUpdate, false, 0, true);
		}
		
		
		public function get geo():Geolocation
		{
		return _geo;
		}
		*/
		
		public function pause():void
		{
			_adTimer.stop();
			/*
			if (_geo)
			{
			_geo.removeEventListener(StatusEvent.STATUS, onGeoStatusChange, false);
			
			if ( _geo.hasEventListener( GeolocationEvent.UPDATE ) )
			_geo.removeEventListener(GeolocationEvent.UPDATE, onGeoUpdate, false);		
			}*/
		}
		
		
		public function resume():void
		{
			if (_ip != "")
			{
				requestSmaatoAd();
				_adTimer.reset();
				_adTimer.start();
			}
			
			/*if (_geo)
			{
			_geo.addEventListener(StatusEvent.STATUS, onGeoStatusChange, false, 0, true);
			
			if (!_geo.muted)
			_geo.addEventListener(GeolocationEvent.UPDATE, onGeoUpdate, false, 0, true);
			}*/
		}
		
		
		public function get clickURL():String
		{
			return _smaatoClickURL;
		}
		
	}
}






