package chp5
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Vertex;
	import away3d.core.utils.Cast;
	import away3d.lights.DirectionalLight3D;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.ShadingColorMaterial;
	import away3d.primitives.Sphere;
	import away3d.sprites.Sprite3D;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class SoundVisDemo extends AwayTemplate
	{
		[Embed(source="assets/s4.mp3")]
		public var Sound1:Class;
		
		[Embed(source="assets/dofText.png")]
		private var SpriteTexture:Class;
		
		private var _sound:Sound;
		private var _barray:ByteArray=new ByteArray(); 
		private const CHANNEL_LENGTH:int = 256;
		private var _sphere:Sphere;
		private var _mat:ShadingColorMaterial;
		private var _light:DirectionalLight3D;
		private var _colMat:ColorMaterial;
		private var _spritesArr:Array=[];
		private var _container:ObjectContainer3D;
		private var _timer:Timer;
		private var _spectrumArr:Vector.<Number>=new Vector.<Number>();
		private var _spriteMat:BitmapMaterial;
		public function SoundVisDemo()
		{
			super();
		}
		override protected function setup() : void
		{
			_cam.z=-300;
			initLight();
			initSprites();
			initSound();
			_timer=new Timer(20,0);
			_timer.addEventListener(TimerEvent.TIMER,processSound);
			_timer.start();
		}
		override protected function initGeometry() : void{
			_sphere=new Sphere({radius:20,segmentsW:15,segmentsH:15,material:_mat});
			_view.scene.addChild(_sphere);
			_container=new ObjectContainer3D();
			_view.scene.addChild(_container);
		}
		override protected function initMaterials() : void{
			_mat=new ShadingColorMaterial(0x928843);
			_colMat=new ColorMaterial(0x229933);
			_spriteMat=new BitmapMaterial(Cast.bitmap(SpriteTexture));
		}
		override protected function onEnterFrame(e:Event) : void{
			super.onEnterFrame(e);
			_sphere.rotate(new Vector3D(1,1,0),1.3);
			var matr:Matrix3D;
			matr=_sphere.transform.clone();
			matr.invert();
			_container.transform=matr;
		}
		private function initSprites():void{
			var leng:uint=_sphere.vertices.length;
			for(var i:int=0;i<leng;++i){
				var sprite:Sprite3D=new Sprite3D(_spriteMat,10,10,0,"center",0.1);;
				_container.addSprite(sprite);
				var vertex:Vertex=_sphere.vertices[i];
				var posVec:Vector3D;
				posVec=vertex.position.clone();
				posVec.scaleBy(2);
				sprite.x=posVec.x;
				sprite.y=posVec.y;
				sprite.z=posVec.z;
				_spritesArr.push({spr:sprite,pos:posVec});
			}
		}
		private function initLight():void{
			_light=new DirectionalLight3D();
			_view.scene.addLight(_light);
			_light.direction=new Vector3D(110,110,0);
		}
		private function initSound():void{
			_sound=new Sound1()as Sound;
			_sound.play(0,99999);	
		}	
		private function processSound(e:TimerEvent):void{
			_barray.position=0;
			SoundMixer.computeSpectrum(_barray,false,0);
			for (var i:int=0;i<CHANNEL_LENGTH-44;++i){
				_spectrumArr[i]=_barray.readFloat();
				var sprite:Sprite3D=_spritesArr[i].spr;
				sprite.x=_spritesArr[i].pos.x;
				sprite.y=_spritesArr[i].pos.y;
				sprite.z=_spritesArr[i].pos.z;
				var soundData:Number=_spectrumArr[i];
				var posVec:Vector3D=new Vector3D(sprite.x,sprite.y,sprite.z);
				posVec=posVec.add(new Vector3D(0,Math.abs(soundData)*15,0));
				sprite.x=posVec.x;
				sprite.y=posVec.y;
				sprite.z=posVec.z;
				if(Math.abs(soundData)>0.21){
					sprite.scaling=0.21;
				}else if(Math.abs(soundData)<=0.05){
					sprite.scaling=0.1
				}else{	
					sprite.scaling=Math.abs(soundData);
				}
			}
			_sphere.scale(Math.sin(Math.abs(soundData)+2));	
		}
	}
}