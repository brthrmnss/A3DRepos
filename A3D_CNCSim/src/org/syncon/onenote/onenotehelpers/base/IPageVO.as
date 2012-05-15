package org.syncon.onenote.onenotehelpers.base   
{
	import mx.collections.ArrayCollection;
	
	 public interface IPageVO
	{
		
		 function get width():Number
		 function set width(value:Number):void
		
		 function set height ( h : Number):void
		 function get height() : Number 
		
		 function set scrollX(value:Number):void			 
		 function get scrollX():Number

		 
		 function set scrollY ( h : Number ) : void
		 function get scrollY () : Number 
			 
		 function get lists():ArrayCollection
		 function set lists(value:ArrayCollection):void
		
	}
}