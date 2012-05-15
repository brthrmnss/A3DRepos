package org.syncon.CncSim.vo
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
	public class MapHelper
	{
		private var ShowClasses:Boolean;
		
		
		
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
		
		
		
		
		
		public static function replace ( str : String, match : String, replace : String ):String
		{
			if ( str == null ) 
				return null;  
			var re1:RegExp = new RegExp(match, "gi"); 
			str =  str.replace( re1, replace )
			return str;
		}	
		
		static public function map ( map : Object, json : Object ) :   Object
		{
			var convertedObject : Object = {}
			//script type the map object
			var baseClass : Class = map.__baseClass;
			if ( baseClass != null  ) 
			{
				convertedObject = convertObjectToClass(  json, baseClass ); 
			}
			for ( var prop : Object in map ) 
			{
				if (  prop == '__baseClass' ) continue; 
				var value : Object = map[prop]; 
				if ( value is Array ) 
				{
					var mapToClass : Class = value[0] 
					var 	result : Object =  mapClassOfArray( mapToClass, json[prop] as Array ) ; 
					convertedObject[prop] = result ;
				}
				else
				{
					mapToClass   = value  as Class
					result = convertObjectToClass( json[prop], mapToClass )
					convertedObject[prop] = result
				}				
			}
			return convertedObject
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
				try{
					lister[prop ] = value
				}
				catch ( e : Error  ) {}
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