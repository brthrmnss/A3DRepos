package org.syncon2.utils
{

	public class MakeVOs 
	{
		
		static public function makeObjs(names : Array, class_ : Class, nameField : String = 'name' ): Array
		{
			var output : Array = [] ; 
			for each ( var name : String in names ) 
			{
				var o : Object = new class_() 
				o[nameField] = name; 
				output.push(o)
			}
			
			return output
		}			
		static public function setValOnAll( objs : Array, value : Object, field : String ): void
		{
			for each ( var obj : Object in objs ) 
			{
				obj[field] = value; 
			}
			
		}	
		
		static public function setValOnObjs( objs : Array, values : Object, field : String ): void
		{
			for ( var i : int = 0 ; i < values.length; i++ ) 
			{
				var obj : Object = objs[i] 
				var value : Object = values[i] 
				obj[field] = value;
			}
			
		}			
		
		/**
		 * arrProp is the array  collection 
		 * i is thndex
		 * */
		public static function getItem(obj:Object, arrProp:String, i :int):Object
		{
			return obj[arrProp].getItemAt( i ) 
		}
		
		public static function getNames(options:Array, nameField : String = 'name' ):String
		{
			var names  : Array = []; 
			for each ( var obj : Object in options ) 
			{
				names.push( obj[nameField] ) 
			}
			return names.join(', ') ; 
		}
		static public function makeNames( count  : int, pre : String =  '' ) : Array
		{
			var names : Array = [] ; 
			for ( var i : int = 0 ; i < count; i++ ) 
			{
				names.push( pre+(i+1).toString() ) 
			}
			return names
		}		
		
		 
	}
}