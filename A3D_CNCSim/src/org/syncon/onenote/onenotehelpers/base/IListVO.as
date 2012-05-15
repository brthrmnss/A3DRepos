package org.syncon.onenote.onenotehelpers.base   
{
	import mx.collections.ArrayCollection;
	
	public interface IListVO
	{
		
		function get name():String
		
		function set name(value:String):void
		
		function get width():Number
		
		function set width(value:Number):void
		
		function get y():Number
		
		function set y(value:Number):void
		
		function get x():Number
		
		function set x(value:Number):void
		
		function set height ( h : Number ) : void
		function get  height () : Number 
		
		function get data(): Object
		
		function set data(value:Object):void
		
		/**
		 * cipped dp, temp storage
		 * */
		
		/**
		 * Storage of lister list is being loaded into ... temp ... use dictionary 
		 * */
		function get loadedIntoLister():Object
		/**
		 * @private
		 */
		function set loadedIntoLister(value:Object):void

	}
}