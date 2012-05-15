package  org.syncon.CncSim.vo
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import org.syncon.onenote.onenotehelpers.base.IPageVO;
	
	/**
	 * Face image
	 * */
	public class CollectiveLayerPriceVO   
	{
		
		public var name : String = ''; 
		/*	public var url : String  = ''; */
		public var description : String = ''; 
		 
		private var _layer : LayerBaseVO;
		public function get layer():LayerBaseVO
		{
			return _layer;
		}

		public function set layer(value:LayerBaseVO):void
		{
			if ( value == null ) 
			{
				trace( 'CollectiveLayerPriceVO', 'set layer to null' ) ; 
			}
			_layer = value;
		}

 // : Object = [] ;
		
		public var price : Number = 0 ; 
		public var type : String = ''; 
		public var subtype : String = ''; 
		
		/**
		 * flag, if true, will override any set prices,( not NaN )
		 * */
		public var overrideSetPrices : Boolean = false; 
	
		
		public var tooltipMessage : String  = ''; 
	}
}