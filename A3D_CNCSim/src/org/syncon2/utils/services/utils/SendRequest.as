package  org.syncon2.utils.services.utils
{
	import mx.rpc.AsyncToken;
	
	
	/**
	 * Wraps RequestJSONUrl for simpliest interface possible
	 * */
	public  class   SendRequest  
	{
		public function SendRequest(post : Boolean=false)
		{
			
		}
		private var loader:  RequestJSONUrl;
		public function request( url : String, params : Object, fxOk : Function, fxFault : Function = null, post : Boolean = false ):void
		{
			
			loader = new RequestJSONUrl();
			
			if ( post == false ) 
			{
				var async : AsyncToken = loader.getUrl( url , params )
			}
			else
			{
				async = loader.postUrl( url , params )
			}
			/*this.fxResultHandler = listResultHandler
			this.fxFaultHandler = listFaultHandler*/
			async.returnFx = fxOk
			async.faultFx =fxFault
			//async.fxNotifyOnBadResult = onResultInvalid 				
			async.parseJSON = false 			
		}
		
		public function requestPost( url : String, params : Object, fxOk : Function, fxFault : Function = null ):void
		{
			
			loader = new RequestJSONUrl();
			var async : AsyncToken = loader.postUrl( url , params )
			
			/*this.fxResultHandler = listResultHandler
			this.fxFaultHandler = listFaultHandler*/
			async.returnFx = fxOk
			async.faultFx =fxFault
			//async.fxNotifyOnBadResult = onResultInvalid 				
			async.parseJSON = false 			
		}
		
	}
}