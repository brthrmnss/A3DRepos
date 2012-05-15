//@terrypaton1//
//@xavivives//

package org.syncon2.utils.mobile
{
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class AdMob
	{
		// setup variables
		private var _stageWebView:StageWebView;
		//var myAdvertURL:String = "http://terrypaton.com/ads/exampleAdvert.html";
		private var myAdvertURL:String;
		/*
		private var adWidth:Number=480;
		private var adHeight:Number=60;
		*/
		private var adWidth:Number=480;
		private var adHeight:Number=70;
		private var stage:Stage;
		public var hiddenState : Boolean = false; 
		public function AdMob(adURL:String,_stage:Stage, w : Number=480, h : Number = 70)
		{
			myAdvertURL=adURL;
			stage=_stage;
			stage.addEventListener( Event.RESIZE, this.onResize3 )
			this.adWidth = w; 
			this.adHeight = h
				
			createAd(); 
		}
		public function onResize3(e:Event=null) : void
		{
			//if ( this.hiddenState ) return; 
			_stageWebView.viewPort = new Rectangle((stage.stageWidth-adWidth)/2,stage.stageHeight-adHeight,adWidth,adHeight);
		}
		
		public function onResize(e:Event=null) : void
		{
			//if ( this.hiddenState ) return; 
			_stageWebView.viewPort = new Rectangle((stage.stageWidth-adWidth)/2,stage.stageHeight-adHeight,adWidth,adHeight);
		}
		public function onResize2(w:Number, h:Number) : void
		{
			//if ( this.hiddenState ) return; 
			_stageWebView.viewPort = new Rectangle((w-adWidth)/2,h-adHeight,adWidth,adHeight);
			//stage.width;// = w; 
			//stage.height// = h; 
		}
		
		public function createAd():void {
			// check that _stageWebView doersn't exist
			if (! _stageWebView) {
				_stageWebView = new StageWebView () ;
				// set the size of the html 'window'
				_stageWebView.viewPort = new Rectangle((stage.stageWidth-adWidth)/2,stage.stageHeight-adHeight,adWidth,adHeight);
				// add a listener for when the content of the StageWebView changes
				_stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE,onLocationChange);
				//add a listener for when the ad is loaded
				_stageWebView.addEventListener(Event.COMPLETE,onComplete);
				
				_stageWebView.addEventListener(ErrorEvent.ERROR, this.onError ) ; 
				// start loading the URL;
				_stageWebView.loadURL(myAdvertURL);
			}
			// show the ad by setting it's stage property;
			//showAd();
		}
		
		public function destroyAd():void {
			// check that the instace of StageWebView exists
			if (_stageWebView) {
				trace("removing advert");
				// destroys the ad
				_stageWebView.stage = null;
				_stageWebView = null;
			}
		}
		
		public function toggleAd():void {
			trace("toggling advert",_stageWebView);
			// check that StageWebView instance exists 
			if (_stageWebView) {
				trace("_stageWebView.stage:"+_stageWebView.stage);
				if (_stageWebView.stage == null) {
					//show the ad by setting the stage parameter
					_stageWebView.stage = stage;
				} else {
					// hide the ad by nulling the stage parameter
					_stageWebView.stage = null;
				}
			} else {
				// ad StageWebView doesn't exist - show create it
				createAd();
			}
		}
		
		public function onLocationChange(event:LocationChangeEvent):void {
			// check that it's not our ad URL loading
			if (_stageWebView.location != myAdvertURL) {
				// destroy the ad as the user has kindly clicked on my ad
				destroyAd();
				// Launch a normal browser window with the captured URL;
				navigateToURL( new URLRequest( event.location ) );
			}
		}
		
		public function onComplete(event:Event):void{
			//add the ad when it is loaded. If not it will apear a white rectangle until the load is complete.
			showAd();
		}
		
		public function onError(event:Event):void{
			//add the ad when it is loaded. If not it will apear a white rectangle until the load is complete.
			showAd();
		}		
		
		public function updateAd(adURL:String=null):void{
			if (adURL!=null){
				myAdvertURL = adURL;
			}
			destroyAd();
			createAd();
		}
		
		public function showAd():void{
			if ( this.hiddenState ) 
				return; 
			if (_stageWebView) 
			{
				_stageWebView.stage = stage;
				this.onResize()
			}
			this.hiddenState = false; 
		}
		
		public function hideAd():void{
			if (_stageWebView) 
				_stageWebView.stage = null;
			this.hiddenState = true; 
		}
		
		
		
		//
	}
}