package org.syncon.onenote.onenotehelpers.base   
{
	import mx.collections.ArrayCollection;
	
	import spark.components.List;
	
	 public interface IListable
	{
		
		 function addEventListener(eventName:String, 
								   listener: Function,
								   useCapture:Boolean=false,
								   priority:int=0,
								   useWeakReference:Boolean=false):void;
		 function removeEventListener(eventName:String, 
								   listener: Function,
								   useCapture:Boolean=false):void;
		
		 //function set newDp(value:Array):void
		 function set data(value:  Object):void
			 
		// function get lister(): List
		 
		 function set id(value:  String):void		
			 
		 function get x():Number
		 function set x(value:Number):void
			 
		 function get y():Number
		 function set y(value:Number):void			
			 
		 function get width():Number
		 function set width(value:Number):void
		 
		 function get height():Number
		 function set height(value:Number):void					 
			 
		 function set visible(value: Boolean):void			 
		 function get  visible():Boolean			 
		/**
		 * Used when resizing list, have to remove all objects so new height will be accurate
		 * ui components may need to clear their old data, so fi th enew data is the same size we will 
		 * know the difference. 
		 * the measure mechanism is listening for the resize event. 
		 * if it hear a resize event but this list is resetting, it will ignore it
		 * */
		 function get resetting():Boolean
		 function set resetting(value:Boolean):void			 
			 
		 /**
		  * Used to set list VO on lister, 
		  * */
		 function set listData(value:IListVO):void			 
		 function get  listData():IListVO	
			 
			 /**
			 * when lister hidden, use this instead of reseting data
			 * all active listeners should be sileneced (as List is loaded in another lister ) 
			 * */
		function goHidden():void
		function goActive():void
	}
}