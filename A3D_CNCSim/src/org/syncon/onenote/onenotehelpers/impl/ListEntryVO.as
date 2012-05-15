package org.syncon.onenote.onenotehelpers.impl   
{
	import flashx.textLayout.elements.TextFlow;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	
	public class ListEntryVO
	{
		public var id : int;
	 	public var y : Number;  //only used when clipping 
		public var height : Number; 
		public var width : Number;
		[Transient] public var  tf  :   TextFlow; //  = new ArrayCollection();
		
		public var contents : String = ''; 
		
	}
}