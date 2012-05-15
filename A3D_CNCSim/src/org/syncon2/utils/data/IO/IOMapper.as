package org.syncon2.utils.data.IO
{
	import com.adobe.serialization.json.JSON;
	
	import flash.utils.describeType;
	
	public class IOMapper
	{
		
		/*		public function importObj(props : Array , from : Object, to : Object ) : void
		{
		for each ( var prop : Object in props ) 
		{
		var val : Object = from[prop] 
		to[prop] = val; 
		}
		}*/
		/**
		 * 
		 * Each property is a string , convert it to the object type 
		 * */
		public function importObj(props : Array , from : Object, to : Object,types : Array=null ) : void
		{
			for ( var i : int = 0 ; i < props.length; i++ )
			{
				var prop : String = props[i]; 
				var val : Object = from[prop] 
				
				if ( types != null ) 
				{
					var type :  Class = types[i]
					if ( type != null ) 
					{
						var newObj : Object = new type(); 
						if ( newObj is Number && val == null ) 
							val = NaN;
					}
				}
				to[prop] = val; 
			}
		}
		
		public function exportObj( props : Array, from : Object, to : Object ) : void
		{
			for each ( var prop : Object in props ) 
			{
				var val : Object = from[prop] 
				to[prop] = val; 
			} 			 
		}
		
		/**
		 * 
		 * Each property is a string , convert it to the object type 
		 * */
		public function importObjAdvProps(props : Array ,types : Array, from : Object, to : Object ) : void
		{
			var index : int = -1 ; 
			for each ( var prop : String in props ) 
			{
				index++
					this.importObjAdv( prop, types[index], from, to ) ; 
			}
		}
		
		
		public function exportObjAdvProps( props : Array, from : Object, to : Object ) : void
		{
			for each ( var prop : String in props ) 
			{
				this.exportObjAdv( prop, from, to ) ; 
			} 
		}
		
		public function importObjAdvPropsArray(props : Array , types : Array,  from : Object, to : Object ) : void
		{
			var index : int = -1 ; 
			for each ( var prop : String in props ) 
			{
				index++
				var objsImport : Array = from[prop] as Array; 
				var objs : Array = [] ; 
				for each ( var objImport : Object in objsImport )
				{
					//var clazz : Class = objImport.constructor
					var newVal : Object = new types[index]; 
					newVal.importObj( objImport ) 
					objs.push( newVal ) ; 
				}
				to[prop] = objs; 
			}
		}
		
		
		public function exportObjAdvPropsArray( props : Array, from : Object, to : Object ) : void
		{
			for each ( var prop : String in props ) 
			{
				var objsExport : Array = from[prop] as Array; 
				var objs : Array = [] ; 
				for each ( var objExport : Object in objsExport )
				{
					var newVal  : Object = objExport.export(); 
					objs.push( newVal ) ; 
				}
				to[prop] = objs; 
			} 
		}
		
		
		public function importObjAdv(prop : String , type : Class,  from : Object, to : Object ) : void
		{
			var val : Object = from[prop] 
			//var clazz : Class = val.constructor
			var newVal : Object = new type(); 
			
			if ( newVal is Date ) 
			{
				var d : Date = new Date();
				d.setTime( Number( val ) ) ; 
				newVal = d; 
				if ( val  == null ) 
					newVal = null
			}
			else
			{
				newVal.importObj( val ) 
				//newVal = val.export(); 
			}
			to[prop] =newVal
		}
		
		public function exportObjAdv( prop : String, from : Object, to : Object ) : void
		{
			
			var val : Object = from[prop] 
			var newVal : Object;
			if ( val is Date ) 
			{
				var d : Date = val as Date 
				var v : Object = d.getTime()
				newVal = val.getTime(); //toString()
			}
			else if ( val == null ) 
			{
				newVal = null
			}
			else
			{
				newVal = val.export(); 
			}
			to[prop] =newVal
		}
		
		
		public function getInput(input:Object):Object
		{
			if ( input is String ) 
			{
				var json : Object = JSON.decode( input.toString() ) ; 
			}
			else
			{
				json = input; 
			}  
			if ( json == null ) 
				json = {} ; 
			return json;
		}
	}
}