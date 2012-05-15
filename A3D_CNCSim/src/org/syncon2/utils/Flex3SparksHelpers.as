package org.syncon2.utils
{
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	import spark.components.Image;
	import mx.containers.Canvas;

	public class Flex3SparksHelpers 
	{
		
		static public function setBackground(canvasSkinnable : Canvas )  : void
		{
			var s : CSSStyleDeclaration = StyleManager.getStyleDeclaration('.'+canvasSkinnable.styleName); 
			var o : Object = s.getStyle('backgroundImage' ) 
			var source : Object = new o(); 
			if ( source == null ) 
				return; 
			var img : Image= new Image()
			img.source = source; 
			canvasSkinnable.addChildAt( img, 0 ) 
			img.percentHeight = img.percentWidth = 100; 
		}			
		 
		 
	}
}