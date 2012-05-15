package  org.syncon2.utils
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	public class  ArrayListMoveableHelper 
	{
		public var arr1 :  IList;// = new ArrayCollection(); 
		
		public function trypToMoveUp(   o : Object, arr : IList=null):Boolean
		{
			if ( arr == null ) 
				arr = arr1
			var i : int = arr.getItemIndex( o ) 
			if ( i == -1 ) 
				return false; 
			if ( i == 0 ) 
				return false ; 
			if ( i > 0 && arr.length > 1 ) 
			{
				arr.removeItemAt( i ) 
				arr.addItemAt( o, i-1 ) ; 
				return true
			}
			
			return false; 
		}			
		public function trypToMoveDown(   o : Object, arr : IList=null, roundaboue : Boolean = false ):Boolean
		{
			if ( arr == null ) 
				arr = arr1
			var i : int = arr.getItemIndex( o ) 
			if ( i == -1 ) 
				return false; 
			if ( i == arr.length -1  ) 
				return false ; 
			
			arr.removeItemAt( i ) 
			arr.addItemAt( o, i+1 ) ; 
			return true
			
		}
		public function trypToRemove(   o : Object, arr : IList=null ):Boolean
		{
			if ( arr == null ) 
				arr = arr1
			var i : int = arr.getItemIndex( o ) 
			if ( i == -1 ) 
				return false; 
			
			arr.removeItemAt( i ) 
			return true
			
		}
		
		static public function Test() : void
		{
			var arr : ArrayCollection = new ArrayCollection(['a','b', 'c'])
			
			var a : ArrayListMoveableHelper = new ArrayListMoveableHelper()
			a.trypToMoveDown( 'a', arr ); 
			trace( arr.toArray().join(', ')); 
			a.trypToMoveDown( 'a', arr ); 
			trace( arr.toArray().join(', ')); 
			var result : Boolean = 	a.trypToMoveDown( 'a', arr ); 
			trace( arr.toArray().join(', ') , result ); 
			
			 result  = 	a.trypToMoveUp( 'c', arr ); 
			trace( arr.toArray().join(', ') , result ); 
			result  = 	a.trypToRemove( 'b', arr ); 
			trace( arr.toArray().join(', ') , result ); 
			result  = 	a.trypToRemove( 'f', arr ); 
			trace( arr.toArray().join(', ') , result ); 
			
			
			trace('ArrayCollectionMovableHelper', 'test' , 'complete'  ) ; 
			return ;
		}
		
		public static function nextAfter(o: Object, arr: IList): Object
		{
			var i : int = arr.getItemIndex( o ) 
			if ( i == -1 ) 
				return null; 
			if ( i == arr.length -1  ) 
				return null ; 
			
			return arr.getItemAt(   i+1 ) ; 
		}
	}
}