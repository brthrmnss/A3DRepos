package org.syncon2.utils.services.utils
{
	import com.adobe.serialization.json.JSON;
	
	import mx.core.ClassFactory;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	/**
	 * 
	 * Encapsulates HTTP service and does own json parsing with convience fatures
	 * 
	 * default 'custom' responders - set properties on token 
	 * returnFx
	 * faultFx - return typed objection 
	 * fxResultRaw - return raw resultEvent
	 * fxFaultRaw 
	 * 
	 * fxNotifyOnBadResult - send in token when this all fails ...
	 * */
	public class RequestURL
	{
		public var params : Object = new Object() //contains parameters
		
		public static var showBusyCursor:Boolean = true ;
		public static var ShowClasses : Boolean = true
		protected var responder:IResponder;
		public var fxConversionExpections:Function; ;
		
		
		/**
		 * 
		 * @param pLimit The number of results to return. Max is 30.
		 * @param pPage The result page.
		 * @param pSort A ProductSortingOptions value
		 * @param pQuery The search string
		 * 
		 */
		
		public function getUrl( url : String , param : Object = null,   returnMessagesFx : Function=null    ): AsyncToken
		{			
			url = cleanUrl( url ) ; 
			return performOperation(url, this.onRecievedStream, null, false, returnMessagesFx );
		}		
		
		
		
		public function postUrl( url : String ,   returnMessagesFx : Function=null, params : Object=null ): AsyncToken
		{			
			url = cleanUrl( url ) ; 
			return performOperation(url, this.onRecievedStream, params, true,  returnMessagesFx );
		}		
		
		/**
		 * Snatizies url 
		 * */
		private function cleanUrl(url:String):String
		{
			if ( url.indexOf('http://') == -1 )
			{
				url = 'http://'+url
			} 
			//url = url + '&login=bitly'
			url = escape( url ) 
			return url;
		}				
		
		private function onRecievedStream(pEvt:ResultEvent):void
		{
			var jsonString :  String = replace(  pEvt.result.toString(), '\n' , '' )
			jsonString = replace(jsonString, '\r' , '' )
			jsonString = replace(jsonString, '\t' , '' )
			var arr :   Object =  this.returnJSON(jsonString);
			//var result : Object = arr.results
			var token : AsyncToken = pEvt.token; 
			if ( token.map != null ) 
			{
				arr =this.map( token.map, arr ) ; 
			}
			this.returnResult( arr, pEvt )
		}	
		
		
		private function performOperation(pOperation:String, pListener:Function, pData : Object=null,
										  post : Boolean = false, 
										  returnResultFx : Function = null, faultFx : Function=null): AsyncToken
		{
			
			var url:String =  pOperation;
			//trace( url)						
			var httpservice:HTTPService = new HTTPService();
			httpservice.url = replace( url, '%3A', ':' );
			httpservice.resultFormat = "text";
			if ( post ) 
				httpservice.method = 'POST'
			
			if ( pData == null && this.paramsNotEmpty() ) 
				pData = this.params
			
			
			//httpservice.headers = {Authorization:"Basic " + benq.toString() };  
			//httpservice
			httpservice.showBusyCursor = showBusyCursor ;
			var token:AsyncToken = httpservice.send(pData);
			
			token.addResponder(new Responder( pListener, onFault ) );
			
			if ( returnResultFx != null ) 
				token.returnFx = returnResultFx
			if ( faultFx != null ) 
				token.faultFx = faultFx					
			this.params = new Object()
			
			return token 
		}
		
		/**
		 * Typically when this fails, will try again so allow this to happen 
		 * */
		public function onFault(pFaultEvt:  FaultEvent):void
		{
			var asyncToken : AsyncToken = pFaultEvt.token
			var fault : Fault = pFaultEvt.fault

			trace('request json', 'onFault', 'failure', fault.faultString, fault.faultDetail ) 
			var fxCallFirst_Token : Function = pFaultEvt.token.fxCallFirst_Token
			if ( fxCallFirst_Token  != null )  fxCallFirst_Token(  pFaultEvt.token )  
				
			//if returned bad content, and notify on bad content set, distpach 
			if ( pFaultEvt.fault.faultString == 'HTTP request error' ) 
			{
				if ( asyncToken.fxNotifyOnBadResult  != null )
				{
					//probably should happen later .... 
					asyncToken.fxNotifyOnBadResult( pFaultEvt ) ; 
					return
				}
			}				
				
			if ( asyncToken.faultFx != null ) 
				asyncToken.faultFx(pFaultEvt)
			//responder.fault(pFaultEvt);
		}
		
		private function paramsNotEmpty()  :  Boolean
		{
			var empty : Boolean = true
			var count : int = 0; 
			for ( var prop : Object in this.params )
			{
				count++
			}
			if ( count > 0 ) 
				empty = false
			return empty  == false
		}
		
		
		private function returnResult( data : Object, resultEvent : ResultEvent =null )  : void
		{
			if ( resultEvent != null ) 
			{
				var token : AsyncToken =  resultEvent.token
				var fxCallFirst_Token : Function = resultEvent.token.fxCallFirst_Token
				if ( fxCallFirst_Token  != null ) { fxCallFirst_Token( token )  }
				
				var fx : Function = resultEvent.token.returnFx
				if ( fx  != null ) { fx( data )}
			}
		}
		
		private function returnJSON( pData : String, dataProperty : String = ''  ) : Object
		{
			if( pData!="")
			{		
				var result:Object = JSON.decode(pData);
				if ( ShowClasses ) 
				{
					//trace out each property as var 
					this.traceOutObjects(result ) ; 
				}
				if ( dataProperty != '' ) 
					result  = result[dataProperty]   ;
				
				
			}
			return result
		}					
		
		private function traceOutObjects(json:Object):void
		{
			trace('         '); 
			var later : Array = []; 
			for ( var prop : Object in json ) 
			{
				import flash.utils.getQualifiedClassName; 
				var value : Object = json[prop]; 
				var clazz : String = getQualifiedClassName(value)
				if ( value is String ) 
					clazz = 'String'
				trace( 'public', 'var', prop, ':', clazz+';' );
				if ( value is Array ) 
					later.push( [value, prop] ) ; 
				/*if ( value is Array ) 
				{
				var mapToClass : Class = value[0] 
				json[prop] = this.mapClassOfArray( mapToClass, json[prop] as Array ) ; 
				}*/
			}
			
			for each ( var o :  Array in later ) 
			{
				var items : Array = o[0]
				var property : String = o[1]
				if ( o.length == 0 ) 
				{
					trace('cant trace out one b/c no items', property )
					continue ; 
				}
				this.traceOutObjects( items[0] ) ; 
			}
		} 			
		
		private function returnJSON_( pEvt:ResultEvent, dataProperty : String = ''  ) : Object
		{
			var pData : String = pEvt.result.toString()
			if( pData!="")
			{		
				var result:Object = JSON.decode(pData);
				if ( dataProperty != '' ) 
					result  = result[dataProperty]   ;
			}
			return result
		}					
		
		
		private function parseJSONArray(resultEvt : ResultEvent,  pClass:Class,  dataProperty :  String = '' , individualDataProperty : String = '' ): Array
		{
			var pData :  String = resultEvt.result.toString()
			var mappedList:Array=[];
			if( pData!="")
			{		
				var rawData:Object = JSON.decode(pData);
				if ( dataProperty  != '' ) 
				{
					var list:Array = rawData[dataProperty] as Array ;
				}
				else
				{
					list  = rawData as Array;
				}
			}
			for each ( var jsonObjData : Object in list ) 
			{
				var instance : Object = new pClass()
				if ( individualDataProperty == '' )
					instance.parse( jsonObjData )
				else
					instance.parse( jsonObjData[individualDataProperty] ) 
				mappedList.push( instance ) 
			}
			return mappedList
		}				
		private function parseJSON(resultEvt : ResultEvent,  dataProperty :  String , pClass:Class ):  Object
		{
			var pData :  String = resultEvt.result.toString()
			var mappedList:Array=[];
			if( pData!="")
			{		
				var rawData:Object = JSON.decode(pData);
				var obj:Object = rawData[dataProperty]  ;
			}
			var instance : Object = new pClass()
			instance.parse( obj ) 
			//distpach event
			//var resultEvent:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, mappedList);
			//responder.result( resultEvent );
			return instance
		}					
		
		
		public static function replace ( str : String, match : String, replace : String ):String
		{
			if ( str == null ) 
				return null;  
			var re1:RegExp = new RegExp(match, "gi"); 
			str =  str.replace( re1, replace )
			return str;
		}	
		
		public function map ( map : Object, json : Object ) :   Object
		{
			//script type the map object
			var baseClass : Class = map.__baseClass;
			if ( baseClass != null  ) 
			{
				json = convertObjectToClass(  json, baseClass ); 
			}
			for ( var prop : Object in map ) 
			{
				var value : Object = map[prop]; 
				if ( value is Array ) 
				{
					var mapToClass : Class = value[0] 
					json[prop] = mapClassOfArray( mapToClass, json[prop] as Array ) ; 
				}
			}
			return json
		}
		
		static public function mapClassOfArray(mapToClass:Class, objects:Array):Array
		{
			var arr : Array = []; 
			for each ( var o : Object in objects ) 
			{
				arr.push( convertObjectToClass( o, mapToClass ) ) 
			}
			return arr;
		}
		
		static public function convertObjectToClass(o:Object, mapToClass:Class):Object
		{
			var productRenderer:ClassFactory = new ClassFactory(mapToClass);
			//productRenderer.properties = { showProductImage: true };
			//myList.itemRenderer = 
			
			var lister :   Object = productRenderer.newInstance()   
			for ( var prop : Object in o  ) 
			{
				var value : Object =  o[prop]
				//value = checkForConversionExceptions( value, prop, mapToClass, lister  ) ; 
				lister[prop ] = value
			}			
			return lister;
		}	
		//deprect ... 
		/*
		static public function checkForConversionExceptions(value:Object, prop:Object, mapToClass:Class, obj : Object ):Object
		{
			if ( fxConversionExpections != null ) 
			{
				value = fxConversionExpections( value, prop, mapToClass, obj  ) ; 
			}
			return value;
		}*/
		
	}
}