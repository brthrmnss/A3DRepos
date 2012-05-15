package org.syncon2.utils.data
{
	
	/**
	 * Object model of flex xml processing is tedious
	 * */
	public class XMLHelpers
	{
		
		static public function renameTag( a : XML,  nodeName : String, copyAttributes : Boolean = false ): XML
		{
			var xml2: XML = XML( '<'+nodeName.toString()+'/>')
			copyChildren( a, xml2 ) 
			return xml2
		}				
		
		static public function makeNodeFromString(  nodeName : String ): XML
		{
			var xml2: XML = XML( '<'+nodeName.toString()+'/>')
			return xml2
		}		
		
		//shouldn't use copy children in both cases? 
		static public function removeOuterTagAndWrapWith( a : XML, xmlOrTagName : Object): XML
		{
			if ( xmlOrTagName is String ) 
			{
				var xml2: XML = XML( '<'+xmlOrTagName.toString()+'/>')
			}
			else
			{
				copyChildren( a, xmlOrTagName as XML ) 
			}
			return xmlOrTagName as XML
		}
		
		
		static public function copyChildren( a : XML, b : XML ):void
		{
			for each (var i: XML in a.children()) {
				
				//tf.appendChild(i.copy());
				b.appendChild(i);
			}
		}		
		
		static public function hasAttributeEqualTo( a : XML,attributeName : String, val : Object = null  ): Boolean 
		{
			if ( a.attribute(attributeName).length() > 0 ) 
			{
				
				if ( val == null ) 
				{
					return true; 	
				}
				else
				{
					var value :  Object = a.@[attributeName]
					value = value.toString()
					if ( value	== val ) 
						return true 
					else 
						return false 
				}
			}
			return false; 
		}		
		
		static public function hasAttribute( a : XML,attributeName : String ): Boolean 
		{
			return hasAttributeEqualTo(a, attributeName) ; 
		}				
		
		static public function replace(   a :  XML, b : XML  ): void
		{
			a.parent().replace( a.childIndex(), b );
		}				
		
		
		public static function getChildNode(i:XML, attrName:String, value:String='', type : String = '*'):Object
		{
			
			for each (var ii: XML in i.descendants()) {
				
				if ( XMLHelpers.hasAttributeEqualTo( ii, attrName, value ) ) 
				{
					return ii// XMLHelpers.getAttribute( ii, attrName ) 
				}
			}
			return null;
		}
		public static function getNodeBreadcrumb(i:XML, indexes:Array, offset : Boolean =  false):XML
		{
			var lastNode : XML = i; 
			var count : int = 0 
			for each (var index: int in indexes ) 
			{
				count++
				if ( offset ) index--
				try {
					
					lastNode = lastNode.children()[index]
				}
				catch ( e : Error ) 
				{
					trace('failed at', lastNode, count , index ) 
					return null; 
				}
			}
			return lastNode;
		}
		public static function getAttribute(i:XML, attributeName:String ): Object
		{
			return  i.@[attributeName];
		}
	}
}