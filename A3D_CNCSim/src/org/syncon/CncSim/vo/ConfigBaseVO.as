package  org.syncon.CncSim.vo
{
	public class ConfigBaseVO 
	{
		public var hiSpeedMode : Boolean = true; 
		
		public static var Type:String= 'LED';
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