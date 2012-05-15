package org.syncon.onenote.onenotehelpers.base.others
	{
    import mx.controls.Button;
    import mx.styles.StyleManager;

/**
 *  The skin for the busy cursor
 *
 *  @default mx.skins.halo.BusyCursor
 */
[Style(name="formatPainter", type="Class", inherit="no")]

    public class CustomCursor extends  Button
    {

        public function CustomCursor()
        {
/*  			var newSkinClass: Class = Class(getStyle('formatPainter'));
	         newSkin = IFlexDisplayObject(new newSkinClass());
	         newSkin.setActualSize(16, 16);	 
	         this.formatPainter = newSkin      */
	       
        }
        public function goAhead() : void
        {
/*         	var db1 : Object = StyleManager.getStyleDeclaration(".formatPainterIcon").getStyle( 'overSkin')
        	var db2 : Object = StyleManager.getStyleDeclaration(".formatPainterIcon")//.getStyle( 'overSkin')
        	var db3 : Object = StyleManager.getStyleDeclaration(".resizeCursorIcon")//.getStyle( 'overSkin') */
        	var iconName : String = 'resizeCursorIcon'
        	if ( StyleManager.getStyleDeclaration('.'+iconName)   == null )
        		return; 
	         resizeCursorS = resizeCursor = StyleManager.getStyleDeclaration(".resizeCursorIcon").getStyle( 'overSkin')
        }
 	//	public  var formatPainter: IFlexDisplayObject; 
 		public function getFormatPainter()  :  Class
 		{
 			var bb : Object = StyleManager.getStyleDeclaration("CustomCursor")//.setStyle("busyCursor",myBusyCursor)
 			var bdb : Object = StyleManager.getStyleDeclaration(".formatPainterIcon").getStyle( 'overSkin')
 		/* 	var sdf : Object = this.getStyle('formatPainter') 
 			var dd: Object = this.getStyle('upSkin' ) 
 			var headerClass:Class = getStyle("headerClass"); */
			return  Class(bdb);
 		}
 		
 		public function getIcon( iconName : String )  :  Class
 		{
 			if ( StyleManager.getStyleDeclaration('.'+iconName)   == null )
 				return null  			
 			var bdb : Object = StyleManager.getStyleDeclaration('.'+iconName).getStyle( 'overSkin')

			return  Class(bdb);
 		} 		
 		
 		
		 public var resizeCursor : Class 	 		
		static public var resizeCursorS : Class 		
 		
    }
}