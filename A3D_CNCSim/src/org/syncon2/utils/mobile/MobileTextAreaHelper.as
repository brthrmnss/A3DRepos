package   org.syncon2.utils.mobile
{
	import mx.collections.ArrayCollection;
	
	import spark.components.TextArea;
	
	public class  MobileTextAreaHelper 
	{
		 
		static public function setHeight(    txt  :  TextArea, offset : int = 10 ):void
		{
			txt.textDisplay['height'] = txt.textDisplay['textHeight'] +offset 
			txt.height =txt.textDisplay['height']
		}			
		static public function setWidth(    txt  :  TextArea, offset : int = 0 ):void
		{
			txt.textDisplay['width'] = txt.textDisplay['textWidth'] +offset 
			txt.width =txt.textDisplay['width']
		}					
	 
	}
}