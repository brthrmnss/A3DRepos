package org.syncon2.utils.view
{
	
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	/**
	 Great for item renererders
	 */
	public class CreateCanvasLines
	{
		private var ui : UIComponent;
		
		static public function makeColors( addTo : UIComponent, 
										   colors : Array, alphas : Array=null, bottomAttach :  Boolean = true ): void
		{
			for ( var i : int = 0 ; i < colors.length; i++ ) 
			{
				var c : Canvas = new Canvas()
				c.height = 1
				c.percentWidth = 100; 
				var color : uint = colors[i] as uint ; 
				c.setStyle('backgroundColor', color )
				var alpha : Number = 1
				if ( alphas != null ) 
					alpha = alphas[i]
				c.alpha = alpha
				if ( bottomAttach ) 
					c.setStyle('bottom', i ) ; 
				addTo.addChild( c ) 
			}
			
		}		
		
	}
}