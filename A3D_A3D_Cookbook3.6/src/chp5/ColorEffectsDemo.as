package chp5
{
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Sphere;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class ColorEffectsDemo extends AwayTemplate
	{
		private var _sphereArr:Array=[];
		private var _bitmapContainer:Bitmap;
		private var _renderBData:BitmapData;
		private var _blurF:BlurFilter;
		private var _colMatrixF:ColorMatrixFilter;
		private var _colMat:ColorMaterial;
		private var _displF:DisplacementMapFilter;
		private var _hoverCam:HoverCamera3D;
		private var _camDummy:ObjectContainer3D;
		private var _oldMouseX:Number=0;
		private var _oldMouseY:Number=0;
		private static const EASE_FACTOR:Number=0.5;
		public function ColorEffectsDemo()
		{
			super();
		}
		override protected function setup() : void
		{
			_cam.z=-400;
			setHowerCamera();
			initFilters();
			_renderBData=new BitmapData(stage.stageWidth,stage.stageHeight);
			_bitmapContainer=new Bitmap(_renderBData);//_brs.getBitmapContainer(_view);
			this.addChild(_bitmapContainer);
		}
		
		private function initFilters():void{
			_blurF=new BlurFilter(3,3,2);
			var colArr:Array=[0.989,0,2,0,38,
				0,0.827,0,0,38,
				0,0,0.876,0,38,
				0,0,0,1.1,0
			];
			_colMatrixF=new ColorMatrixFilter(colArr);
			var dispBmd:BitmapData=new BitmapData(stage.stageWidth,stage.stageHeight);
			dispBmd.perlinNoise(25,25,12,34543,true,true,7,true);
			_displF=new DisplacementMapFilter(dispBmd,null,BitmapDataChannel.RED,BitmapDataChannel.BLUE,12,12,DisplacementMapFilterMode.WRAP);
		}
		private function applyFilters():void{
			_renderBData.lock();
			_renderBData.draw(this);
			_renderBData.applyFilter(_renderBData,_renderBData.rect,new Point(0,0),_colMatrixF);
			_renderBData.applyFilter(_renderBData,_renderBData.rect,new Point(0,0),_blurF);
			_renderBData.applyFilter(_renderBData,_renderBData.rect,new Point(0,0),_displF);
			_renderBData.unlock();
		}
		private function setHowerCamera():void{
			_hoverCam=new HoverCamera3D();
			_view.camera=_hoverCam;
			_hoverCam.target=_camDummy;
			_hoverCam.distance = 500;
			_hoverCam.maxTiltAngle = 80;
			_hoverCam.minTiltAngle = 0;
			_hoverCam.wrapPanAngle=true;
			_hoverCam.steps=16;
			_hoverCam.yfactor=1///def 2	
		}
		private function updateSceneObjectsPos():void{
			var arrLength:uint=_sphereArr.length;
			for(var i:int=0;i<arrLength;++i){
				_sphereArr[i].vx+=Math.random()*0.5-0.25;
				_sphereArr[i].vy+=Math.random()*0.5-0.25;
				_sphereArr[i].vz+=Math.random()*0.5-0.25;
				_sphereArr[i].x+=_sphereArr[i].vx;
				_sphereArr[i].y+=_sphereArr[i].vy;
				_sphereArr[i].z+=_sphereArr[i].vz;
				if(_sphereArr[i].x>400){
					_sphereArr[i].x=-400;
				}else if(_sphereArr[i].x<-400){
					_sphereArr[i].x=400;
				}
				/////y///////////
				if(_sphereArr[i].y>300){
					_sphereArr[i].y=-300;
				}else if(_sphereArr[i].y<-300){
					_sphereArr[i].y=300;
				}
				///////z///////////////
				if(_sphereArr[i].z>300){
					_sphereArr[i].z=-300;
				}else if(_sphereArr[i].z<-300){
					_sphereArr[i].z=300;
				}		
			}
		}
		override protected function initMaterials() : void{
			_colMat=new ColorMaterial(0x229933);
		}
		override protected function initGeometry() : void{
			for(var i:int=0;i<24;++i){
				var sphere:FSphere=new FSphere({radius:20,material:new ColorMaterial(Math.floor(Math.random()*0xFFFFFF))});
				sphere.ownCanvas=true;
				sphere.segmentsH=5;
				sphere.segmentsW=5;
				_sphereArr.push(sphere);
				sphere.x=Math.random()*800-400;
				sphere.y=Math.random()*600-300;
				sphere.z=Math.random()*600-300;
				_view.scene.addChild(sphere);
			}
			_camDummy=new ObjectContainer3D();
			_camDummy.transform.position=new Vector3D(0,0,100);	
		}
		override protected function onEnterFrame(e:Event) : void{
			super.onEnterFrame(e);
			var screenVect:Vector3D=_cam.unproject(_view.mouseX,_view.mouseY);
			//screenVect.z=0;
			//_sphere.position=screenVect;
			applyFilters();
			updateSceneObjectsPos();
			if(_hoverCam){
				_hoverCam.panAngle = (stage.mouseX - _oldMouseX)*EASE_FACTOR ;
				_hoverCam.tiltAngle = (stage.mouseY - _oldMouseY)*EASE_FACTOR ;
				_hoverCam.hover();
			}
		}
	}
}
import away3d.primitives.Sphere;

class FSphere extends Sphere{
	public var vx:Number=0;
	public var vy:Number=0;
	public var vz:Number=0;
	public function FSphere(init:Object=null){
		super(init);
	}
}
