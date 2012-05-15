package org.syncon2.utils.data.IO
{
	import flash.utils.describeType;
	
	public class ExportHelper
	{
		/**
		 * return all propers 
		 * getters that have public setters
		 * if it is an arry of something, put in seperate block 
		 * */
		public function introspect( obj  : Object  ) : void
		{
			// Get the Button control's E4X XML object description.
			var classInfo:XML = describeType(obj);
			
			// Dump the entire E4X XML object into ta2.
			/*trace(classInfo.toString() )
			*/
			// List the class name.
			trace("Class " + classInfo.@name.toString() + "\n");
			
			// List the object's variables, their values, and their types.
			/*for each (var v:XML in classInfo..variable) 
			{
			trace(   "Variable", v.@name + "=" + obj[v.@name],
			"(" + v.@type + ")\n" )
			}
			*/
			var propsSimple : Array = [] ; 
			var propsAdv : Array = []
			var propsAdvArray : Array = [] ;
			var output : String = '['; 
			for each (var v:XML in classInfo..variable) 
			{
				var varName : String = v.@name
				/*if ( output != '[' ) output += ', '
				output +=  "'"+  v.@name +  "'" */
				var data : Object = obj[v.@name]
				if ( isSimple( data ) || isSimple2( v.@type )  )  {
					propsSimple.push( varName )
					continue
				}
				else if ( data is Array )
				{
					//if ( isSimple( data )  {
					propsAdvArray.push( varName )
					continue
				}
				else
				{
					propsAdv.push( varName )
					continue
				}
			}
			for each (var a:XML in classInfo..accessor) {
				// Do not get the property value if it is write only.
				if (a.@access == 'writeonly' || a.@access == 'readonly' ) {
					continue; 
				}
				
				varName  = v.@name
				/*if ( output != '[' ) output += ', '
				output +=  "'"+  v.@name +  "'" */
				data  = obj[v.@name]
				if ( isSimple( data ) || isSimple2( v.@type )  )  {
					propsSimple.push( varName )
					continue
				}
				else if ( data is Array )
				{
					//if ( isSimple( data )  {
					propsAdvArray.push( varName )
					continue; 
				}
				else
				{
					propsAdv.push( varName )
				}
				
			}
			
			propsAdv = this.wrapInStrings( propsAdv ) 
			propsAdvArray = this.wrapInStrings( propsAdvArray ) 
			propsSimple = this.wrapInStrings( propsSimple ) 
			
			trace( arr( propsSimple ) )
			trace( arr( propsAdv ) )
			trace( arr( propsAdvArray ) )			
			/*
			// List accessors as properties.
			for each (var a:XML in classInfo..accessor) {
			// Do not get the property value if it is write only.
			if (a.@access == 'writeonly') {
			ta1.text += "Property " + a.@name + " (" + a.@type +")\n";
			}
			else {
			ta1.text += "Property " + a.@name + "=" + 
			button1[a.@name] +  " (" + a.@type +")\n";
			}
			} 
			*/
			/*
			// List the object's methods.
			for each (var m:XML in classInfo..method) {
			ta1.text += "Method " + m.@name + "():" + m.@returnType + "\n";
			}
			*/
		}
		
		private function arr(input:Array): String
		{
			var str : String = '['
			str += input.join(', ' ) ; 
			str += ']'
			return str;
		}
		
		private function isSimple(data:Object):Boolean
		{
			if ( data is String ) return true; 
			if ( data is Boolean ) return true; 
			if ( data is int ) return true; 
			if ( data is Number ) return true; 			
			return false;
		}
		private function isSimple2(data: String):Boolean
		{
			if ( data == 'String' ) return true; 
			if ( data == 'Boolean' ) return true; 
			if ( data == 'int' ) return true; 
			if ( data == 'Number' ) return true; 			
			return false;
		}
		
		
		private function wrapInStrings(arr: Array ):Array
		{
			var arr2 : Array = [] ; 
			for each ( var o : Object in arr ) 
			{
				arr2.push( '"'+o+'"') 
			}
			return arr2
		}
		private function traceS(...rest):String
		{
			trace.apply( this, rest ) ; 
			
			return rest.join(' ');
		}
	}
}