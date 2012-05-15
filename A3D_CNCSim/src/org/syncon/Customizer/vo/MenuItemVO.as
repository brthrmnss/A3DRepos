package  org.syncon.Customizer.vo
{
	
	public class MenuItemVO 
	{
		public var fxNoParams : Function
		public var fxSendData : Function 
		
		public var data : Object; 
		public var name : String = '' 
		
		public function automate():void
		{
			// TODO Auto Generated method stub
			if ( this.fxNoParams != null ) 
			{ 
				this.fxNoParams(); 
				return;
			}
			if ( this.fxSendData != null ) 
			{ 
				if ( data == null ) 
					data = this.name; 
				this.fxSendData(data); 
				return;
			}			 
		}
	}
}