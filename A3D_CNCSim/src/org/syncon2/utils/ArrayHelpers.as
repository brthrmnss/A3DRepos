package org.syncon2.utils
{
	
	//http://active.tutsplus.com/tutorials/actionscript/quick-tip-how-to-randomly-shuffle-an-array-in-as3/
	public class ArrayHelpers
	{
		
		public static function doIt(tArray:Array, shuffleTimes : int = 1):Array {
			
			for ( var i : int = 0; i < shuffleTimes ; i++ )
			{
				tArray =  shuffle( tArray ) ; 
				tArray.sort(randomSort)
			}
			return tArray;
		}
		
		private static function shuffle(arr:Array):Array
		{
			var shuffledLetters:Array = new Array(arr.length);
			
			var randomPos:Number = 0;
			for (var i:int = 0; i < shuffledLetters.length; i++)
			{
				randomPos = int(Math.random() * arr.length);
				shuffledLetters[i] = arr.splice(randomPos, 1)[0];   //since splice() returns an Array, we have to specify that we want the first (only) element
			}
			return shuffledLetters; 
		}
		public	static		function randomSort(a:Object, b:Object):int {
			return Math.round(Math.random()*-1+Math.random());
		}
		
		/*		public static function doRandomSort(tempCollection:ArrayCollection):void {
		function randomCompare(a:Object, b:Object, fields:Array = null):int {
		return Math.round(Math.random()*-1+Math.random());
		}
		var sort:Sort = new Sort();
		sort.compareFunction = randomCompare;
		tempCollection.sort = sort;
		tempCollection.refresh();
		}*/
		/*		
		public static function getRandomSet(items:Array, count:int):Array
		{
		var output : Array = []
		var diff : Array = doIt( items ) ; 
		for ( var i : int = 0; i < count; i++)
		{
		output.push( diff[i] ) ; 
		}
		return output;
		}
		*/
		public static function getRandomSet(items:Array, count:int, includeItem : Object = null, reserve : Array=null, minSize : int = -1):Array
		{
			items = items.concat() //clone so we can add without modifying original 
			var output : Array = []
			if ( items.length < count && reserve != null  ) 
			{
				if ( minSize > 0 ) 
				{
					count = minSize
				}
				var iterationCount : int = 0 ; 
				reserve = doIt( reserve, 4 ) ; 
				for (  i =items.length; i < reserve.length; i++)
				{
					if ( items.length >= count ) 
						continue; 
					var nextReserveItem : Object = reserve[iterationCount]; 
					iterationCount++;
					if ( includeItem != null && includeItem == nextReserveItem ) 
						continue; 
					if ( items.indexOf( nextReserveItem ) == -1 ) 
					{
						items.push( nextReserveItem ) ; 
					}
					
				}
			}
			if ( items.length < count  ) 
			{
				trace('ArrayHelpers', 'Min', 'Can not get accruate items for count request'); 
			}
			var diff : Array = doIt( items ) ; 
			for ( var i : int = 0; i < count; i++)
			{
				if ( diff[i] != null ) //this function can fail to meet requirements ...
					output.push( diff[i] ) ; 
			}
			/*			if ( output.length < count ) 
			{
			for (  i =output.length; i < count; i++)
			{
			output.push( diff[i] ) ; 
			}
			}*/
			
			
			//add in item to include ... 
			if ( includeItem != null ) 
			{
				if ( output.indexOf( includeItem ) == -1 ) 
				{
					var randomIndex : int = 0 ; 
					randomIndex = output.length*Math.random()
					if ( randomIndex == output.length )
						randomIndex = output.length-1
					output[randomIndex]= includeItem; 
				}
			}
			return output;
		}
		
		
	}
}