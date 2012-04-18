package chp13
{
	
	import away3d.core.utils.Cast;
	import away3d.materials.FresnelPBMaterial;
	import away3d.materials.utils.HeightMapDataChannel;
	import away3d.materials.utils.WaterMap;
	import away3d.modifiers.HeightMapModifier;
	import away3d.primitives.Sphere;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	[SWF(backgroundColor="#677999", frameRate="15", quality="LOW",width="800", height="600")]
	public class NormalAnimDemo extends AwayTemplate
	{
		private const CAM_DIST : Number = 500;
		
		[Embed(source="../assets/images/waterNormalMap.png")]
		private var WaterNormalMap : Class;
		[Embed(source="../assets/images/envHDRI.jpg")]
		private const EnvMap : Class;
		[Embed(source="../assets/images/readermapRed.jpg")]
		private const BumpMap : Class;
		private var _waterNormalMap : WaterMap;
		private var _sphere:Sphere;
		private var _fresMat:FresnelPBMaterial;
		private var _extrMod:HeightMapModifier;
		private var _bumpAnim:WaterMap;
		public function NormalAnimDemo()
		{
			super();
			
		}
		private function initPBMaterials():void{
			var objTexture:BitmapData=new BitmapData(512,512);
			objTexture.perlinNoise(65,65,5,23235,true,true,7);
			var normBTM:BitmapData=Cast.bitmap(new WaterNormalMap());
			var envBTM:BitmapData= Cast.bitmap(new EnvMap());
			_waterNormalMap = new WaterMap(objTexture.width, objTexture.height, 128, 128,normBTM );
			_bumpAnim = new WaterMap(objTexture.width, objTexture.height, 128, 128,Cast.bitmap(new BumpMap()) );
			_fresMat=new FresnelPBMaterial(objTexture, _waterNormalMap, envBTM, _sphere,{ envMapAlpha: 0.4, refractionStrength: 69 });
			_fresMat.color=0xFF0500;	
		}
		
		override protected function initGeometry() : void{
			_sphere=new Sphere({radius:150,segmentsW:8,segmentsH:8});
			initPBMaterials();
			_sphere.material=_fresMat;
			_view.scene.addChild(_sphere);
			_extrMod=new HeightMapModifier(_sphere,_bumpAnim,HeightMapDataChannel.RED,255,0.2,10);
		}
		
		
		override protected function onEnterFrame(e:Event) : void
		{
			super.onEnterFrame(e);
			
			_view.camera.x = Math.sin(-_view.mouseX / 400)*CAM_DIST;
			_view.camera.y = Math.sin( _view.mouseY / 120)*CAM_DIST;
			_view.camera.z = -(Math.cos(-_view.mouseX / 400)+Math.cos( _view.mouseY / 120))*CAM_DIST;
			_view.camera.lookAt(new Vector3D(0,0,0));
			_extrMod.execute();
			_bumpAnim.showNext();
			_waterNormalMap.showNext();
		}
	}
}