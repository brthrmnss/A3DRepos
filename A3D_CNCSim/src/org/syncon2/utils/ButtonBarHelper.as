package  org.syncon2.utils
{
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import spark.components.Button;
	
	public class  ButtonBarHelper 
	{
		public var dict : Dictionary = new Dictionary(true); 
		public var fxSendString : Function ; 
		public function load_Strings(  buttons : Array, holder : Object, fx : Function):void
		{
			fxSendString  = fx; 
			for each ( var o : Array in buttons ) 
			{
				var btn : Button = new Button()
				btn.label = o[0]
				dict[btn]=o[1]
				btn.addEventListener(MouseEvent.CLICK, this.onClick_Strings, false, 0, true ) 
				holder.addElement( btn )
			}
		}			
		protected function onClick_Strings(event:MouseEvent):void
		{
			var str :  String = this.dict[event.currentTarget] 
			if ( str != null ) fxSendString(str); 
		}
		
		public function load_Fxs(styleName : String, buttons : Array, holder : Object):void
		{
			
			for each ( var o : Array in buttons ) 
			{
				var btn : Button = new Button()
				btn.label = o[0]
				dict[btn]=o[1]
				btn.addEventListener(MouseEvent.CLICK, this.onClick, false, 0, true ) 
				holder.addElement( btn )
			}
		}			
		
		protected function onClick(event:MouseEvent):void
		{
			var fx : Function = this.dict[event.currentTarget] 
			if ( fx != null ) fx()
		}
		
	}
}