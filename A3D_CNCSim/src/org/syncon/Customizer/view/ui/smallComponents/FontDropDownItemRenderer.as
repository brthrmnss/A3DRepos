package org.syncon.Customizer.view.ui.smallComponents
{
	import org.syncon.Customizer.model.CustomEvent;
	
	import spark.skins.spark.DefaultItemRenderer;
	
	public class FontDropDownItemRenderer extends DefaultItemRenderer
	{
		static public var GET_FONT_FAMILY_FOR : String = 'GET_FONT_FAMILY_FOR'; 
		override public function set label(value:String):void
		{
			super.label = value; 
			/*if (value == _label)
			return;
			
			_label = value;
			this.
			// Push the label down into the labelDisplay,
			// if it exists
			if (labelDisplay)
			labelDisplay.text = _label;*/
			var e : CustomEvent = new CustomEvent( GET_FONT_FAMILY_FOR, value ,true ) 
			//this.dispatchEvent(  e ) ;
			//distapching on this does not bubble up b/c it is in a datagroup? 
			this.parentDocument.dispatchEvent(  e ) ;
			if ( e.isDefaultPrevented() ) 
			{
				value = e.data.toString(); 
				this.labelDisplay.setStyle('fontFamily', value ) ; 
				this.parentDocument.parentDocument
			}
		}
	}
}