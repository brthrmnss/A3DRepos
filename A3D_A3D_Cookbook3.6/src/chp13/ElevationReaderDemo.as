package chp13
{
	import away3d.core.clip.NearfieldClipping;
	import away3d.core.utils.Cast;
	import away3d.extrusions.Elevation;
	import away3d.extrusions.ElevationReader;
	import away3d.extrusions.SkinExtrude;
	import away3d.materials.BitmapMaterial;
	
	import com.bit101.components.Label;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.text.TextFormat;
	
	import utils.FPSController;
	
	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class ElevationReaderDemo extends AwayTemplate
	{
		[Embed(source="../assets/images/readermap1.jpg")]
		private var ElevMap : Class;
		
		[Embed(source="../assets/images/terrainMap1.jpg")]
		private var HeightMapTexture : Class;
		private var _elevation:Elevation;
		private var _skinExtrud:SkinExtrude;
		private var _bitMat:BitmapMaterial;
		private var _reader:ElevationReader;
		private var _walker:FPSController;
		private var _bdata:BitmapData;
		private var _tf:Label;
		public function ElevationReaderDemo()
		{
			super();
			_view.clipping=new NearfieldClipping();
			initGUI();
		}
		private function initGUI():void{
			var tFormat:TextFormat=new TextFormat(null,11,0xFF0011);
			var label:Label=new Label(this,10,100,"Current Elevation:");
			_tf=new Label(this,label.x+110,100);
			_tf.textField.defaultTextFormat=tFormat;
			tFormat.color=0x000000;
			label.textField.defaultTextFormat=tFormat;
		}
		override protected function initMaterials() : void{
			_bitMat=new BitmapMaterial(Cast.bitmap(new HeightMapTexture()));
			_bdata=Cast.bitmap(new ElevMap());
		}
		override protected function initGeometry() : void{
			_elevation=new Elevation();
			_elevation.minElevation=0;
			_elevation.maxElevation=255;
			
			var elevatonData:Array=_elevation.generate(_bdata,"r",70,70,5,5,0.8);
			_skinExtrud=new SkinExtrude(elevatonData,{recenter:true, closepath:false, coverall:true, subdivision:1, bothsides:false, flip:false});
			
			
			_skinExtrud.material=_bitMat;
			_skinExtrud.rotationX=90;
			_view.scene.addChild(_skinExtrud);
			_skinExtrud.position=new Vector3D(-100,-100,0);
			_skinExtrud.scale(1);
			_reader=new ElevationReader(3);
			///	_reader.setSource(_bdata,"r",2,2,0.6);
			_reader.traceLevels(_bdata,"r",70,70,5,5,0.8);
			
			_cam.x=_skinExtrud.x;
			_cam.y=1000;
			_cam.z=_skinExtrud.z+200;
			_skinExtrud.ownCanvas=true;
			_walker=new FPSController(_view.camera,stage);
		}
		override protected function onEnterFrame(e:Event) : void{
			
			var level:Number=_reader.getLevel(_cam.x,_cam.z,20);
			_tf.text=level.toPrecision(6);
			_walker.walk(level);
			trace(_cam.position);
			super.onEnterFrame(e);
		}
	}
}