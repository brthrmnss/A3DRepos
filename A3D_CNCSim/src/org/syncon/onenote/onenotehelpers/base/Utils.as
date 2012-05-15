package org.syncon.onenote.onenotehelpers.base   
{
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	public class Utils 
	{
		 static public function DoesPtOccurWithinComponent ( pt : Point, box : UIComponent ) :  Boolean
		 {
			 var ptTL : Point = box.localToGlobal( new Point( 0, 0 ) ) ; 
			 var ptBL : Point = box.localToGlobal( new Point( box.width, box.height ) ) ; 
			 trace('debug', pt, ptTL, ptBL)
			 if ( pt.x  <  ptTL.x  ||   pt.x  >  ptBL.x  )   
			 {
				 return false 
			 }			 
			 if ( pt.y  <  ptTL.y  ||   pt.y  >  ptBL.y  )   
			 {
				 return false 
			 }					 
			 return true; 
		 }
			 
		
		
	}
}