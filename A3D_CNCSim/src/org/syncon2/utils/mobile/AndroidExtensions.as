//@terrypaton1//
//@xavivives//

package org.syncon2.utils.mobile
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	
	
	public class AndroidExtensions
	{
		private var socket:Socket;
		private var args:Array;
		
		/**
		 * Quickly display error from this class ... very lazy, but convient 
		 * */
		static public var FxError : Function;  
		public static var port:Number;
		
		private function startSocket():void
		{
			// TODO Auto Generated method stub
			var s:Socket = new Socket();
			s.connect("localhost", 12345);
			s.addEventListener(Event.CONNECT, function(event:Event):void {
				trace('connected!');
				s.writeInt(1);
				s.writeUTF('booo');
				s.flush();
				s.close();
			});
			s.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {
				trace('error! ' ); //+ event.errorID);
				if ( event.hasOwnProperty('errorID' ) ) 
					trace(event['errorID'] )
			});
			s.addEventListener(ProgressEvent.SOCKET_DATA, function(event:ProgressEvent):void {
				trace('progress ');
			});
		}
		
		/**
		 * Sent url of asset relative from top of apk file...
		 * */
		public function setRingtone(url:String):void
		{
		/*	this.socket = this.connectToSocket(12346 );
			this.args = ['r', url]
				*/
			this.socket = this.connectToSocket(12347 );
			this.args = ['ringtone', 'r', url, '']				
		}
		
		
		/**
		 * Sent url of asset relative from top of apk file...
		 * */
		public function setNotification(url:String):void
		{
			/*this.socket = this.connectToSocket(12346 );
			this.args = ['n', url]*/
			this.socket = this.connectToSocket(12347 );
			this.args = ['ringtone', 'n', url, '']		
		}
		
		/**
		 * Sent url of asset relative from top of apk file...
		 * */
		public function setAlarm(url:String):void
		{
			/* this.socket = this.connectToSocket(12346 );
			this.args = ['a', url]*/
			this.socket = this.connectToSocket(12347 );
			this.args = ['ringtone', 'a', url]		
		}
		
		private function onConnect(event:Event):void {
			trace('connected!');
			var s : Socket = event.currentTarget as Socket
			s.writeInt(1);
			this.callArgs( s, this.args )
			
			s.flush();
			s.close();
			this.cleanUp(s); 
		}
		
		private function onError(event:IOErrorEvent):void {
			trace('error! ' , event )//['text']);
			if ( event.hasOwnProperty('errorID' ) ) 
				trace(event['errorID'] )
			if ( FxError != null ) 
			FxError(  'An Error Occured, please exit app (via Menu) and try again. If problems persist, send in a Problem Report.'  ); 
			this.cleanUp(this.socket); 
		}
		
		private function cleanUp(socket:Socket):void
		{
			var s : Socket = socket; 
			s.removeEventListener(Event.CONNECT, onConnect);
			s.removeEventListener(IOErrorEvent.IO_ERROR, onError );
			s.removeEventListener(ProgressEvent.SOCKET_DATA, onProgress);
		}
		private function onProgress(event:ProgressEvent):void {
			trace('progress ');
			this.cleanUp(this.socket); 
		}
		
		
		private function callArgs( s : Socket, args : Array ) : void
		{
			for each (var arg : String in args ) 
			{
				s.writeUTF(arg);
			}
		}
		
		
		
		
		/**
		 * Sent url of asset relative from top of apk file...
		 * */
		public function goToStore(query:String='', pub:String=''):void
		{
			this.socket = this.connectToSocket(12347 );
			this.args = ['search', query, pub, '']
		}
		[ElipsPlatformExtension(platforms="Android 1.6")]		
		public function rateApp(apppackage:String):void
		{
			this.socket = this.connectToSocket(12347 );
			this.args = ['rate' ,apppackage,'','' ]
		}
		[ElipsPlatformExtension(platforms="Android 1.6")]
		public function shareApp(subject : String,text : String, intentName : String):void
		{
			this.socket = this.connectToSocket(12347 );
			this.args = ['share' ,subject, text, intentName ]
		}
		
		
		public function connectToSocket(port : Number =12346) : Socket
		{
			var s:Socket = new Socket();
			if ( !  isNaN(AndroidExtensions.port ) )
			{
				port = AndroidExtensions.port
			}
			s.connect("localhost", port);
			s.addEventListener(Event.CONNECT, onConnect);
			s.addEventListener(IOErrorEvent.IO_ERROR, onError );
			s.addEventListener(ProgressEvent.SOCKET_DATA, onProgress);
			return s;
		}
		
	}
}