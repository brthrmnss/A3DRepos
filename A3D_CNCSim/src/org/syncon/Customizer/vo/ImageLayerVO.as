package  org.syncon.Customizer.vo
{
	public class ImageLayerVO  extends  LayerBaseVO
	{
		public var hiSpeedMode : Boolean = true; 
		
		public static var Type:String= 'IMAGE';
		
		private var _image_source : String = ''; 

		/**
		 * Specifies limits on change this image ...internally does nothing
		 * ...replaced with subtype ...
		 * */
		public function get image_source():String
		{
			//return _image_source;
			return this.subType; 
		}

		/**
		 * @private
		 */
		public function set image_source(value:String):void
		{
			_image_source = value;
			super.subType = value; 
		}

		override public function set subType( value : String ) : void
		{
			this._image_source = value 
			super.subType = value; 
		}
		
		/***
		 * when specifying default picks, this notifies us that the user did not change this 
		 * */
		public var default_url : String = ''; 
		
		/**
		 * wtf? ... should be titled global mask or make speerate type ...
		 * */
		public var mask:Boolean;
		/**
		 * Needed so we know size of base layer at all times ... or you could just look it up 
		 * */
		public var base_layer:Boolean;
		/**
		 * dispatched when layer is resized ...
		 * ignored by itemrenderer to prevent updating loops
		 * */
		
		/**
		 * used as a collary to the url ... 
		 * for uploading images, they are stored here
		 * */
		public var source:Object;
		
		public static var RESIZE_COMPLETE:String= 'resizecom';
		/**
		 * ignore the adove resize_complete, dispatches when souce explicity changed
		 * */
		public static var SOURCE_CHANGED:String= 'SOURCE_CHANGED';

		public override function get type():String 	{ return Type; }
		
/*		override public function clone() : LayerBaseVO
		{
			var img : ImageLayerVO = super.clone() as ImageLayerVO
			img.image_source = this.image_source
			img.mask = this.mask; 
			return img; 
		}*/
		
		override  public function clone() : LayerBaseVO
		{
			var img : ImageLayerVO = new ImageLayerVO()
			this.copyPropsTo(img)  
			img.image_source = this.image_source
			img.mask = this.mask; 
			img.default_url = this.default_url;
			img.source = img.source; 
			return img; 
		}
		
	}
}