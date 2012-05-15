package  org.syncon.Customizer.vo
{
	public class ProductVO 
	{
		public var name  :  String = ''; 
		public var url : String = ''; 
		
		public var layers:Array = [];
		
		public static var Type:String= 'LED';
		public var color_overlay_layer:Object;
		public function get type():String
		{
			return Type;
		}
		
		public function importObj ( on : Object,  obj : Object)  : void 
		{
	/*		ObjectUtil.getClassInfo(object)

				obj
			var props : Object = ObjectUtil.getClassInfo( obj[0] ) 
			
				
				for  each ( var prop :   QName in props.properties ) 
				{
					if ( on.hasOwnProperty( prop.localName ) )
						on[prop.localName] = obj[prop.localName] 
				}
				}*/
			for ( var k : Object in obj ) 
			{
				
				if ( k == 'type' ) continue; 
				
				try {
					on[k] = obj[k]
				}
				catch ( e : Error ) 
				{
					trace('skipped attribute' , k); 
				}
			}
			return  ;
		}
		
	}
}