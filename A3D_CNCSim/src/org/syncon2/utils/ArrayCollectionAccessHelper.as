package org.syncon2.utils
{
	import mx.collections.ArrayCollection;
	
	public class ArrayCollectionAccessHelper 
	{
		public var arr : ArrayCollection; 
		//public var arr1 : ArrayCollection; 
		public var arr2 : String; 
		public function load( arr1 : ArrayCollection, arr2b : String ): void
		{
			arr = arr1
			arr2 = arr2b
		}			
  
		public  function getItem(  i :int, y : int ):Object
		{
			var o : Object = arr.getItemAt( i );
			var o2 : Object = o[this.arr2]
			var o3 : Object = o2.getItemAt(y )
				
			return o3; // arr.getItemAt( i )[arr2].getItemAt(y )
		}
		
		
	}
}