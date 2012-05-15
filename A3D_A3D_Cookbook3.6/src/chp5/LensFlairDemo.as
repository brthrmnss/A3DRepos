package chp5
{
	import away3d.cameras.HoverCamera3D;
	import away3d.core.base.Object3D;
	import away3d.overlays.LensFlare;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#000000", frameRate="30", quality="LOW", width="800", height="600")]
	public class LensFlairDemo extends AwayTemplate
	{
		private var _lensFlair:LensFlare;
		private var _source:Object3D;
		private var _oldMouseX:Number=0;
		private var _oldMouseY:Number=0;
		private static const EASE_FACTOR:Number=0.5;
		private var _hoverCam:HoverCamera3D;
		private var _camTarget:Object3D=new Object3D();
		private var _bitmapContainer:Bitmap;
		private var _renderBData:BitmapData;
		private var _overlay:Sprite;
		private var _blurF:BlurFilter;
		private var _colMatrixF:ColorMatrixFilter;
		private var _drawMatr:Matrix;
		private var _displF:DisplacementMapFilter;
		public function LensFlairDemo()
		{
			super();
			initFilters();
			setHowerCamera();
			initLensFlair();
			_overlay=_view.overlay;
			_renderBData=new BitmapData(stage.stageWidth,stage.stageHeight);
			_bitmapContainer=new Bitmap(_renderBData);
			this.addChild(_bitmapContainer);
			_overlay.visible=false;
		}
		override protected  function initGeometry() : void{
			_source=new Object3D();
			_view.scene.addChild(_source);
			_source.z=1500;
			_source.y=200;
			_source.x=200;
			_view.scene.addChild(_camTarget);
			_camTarget.transform.position=new Vector3D(0,0,0);
		} 
		override protected  function onEnterFrame(e:Event) : void{
			super.onEnterFrame(e);
			if(_hoverCam){				
				_hoverCam.panAngle = (stage.mouseX - _oldMouseX)*EASE_FACTOR ;
				_hoverCam.tiltAngle = (stage.mouseY - _oldMouseY)*EASE_FACTOR ;
				_hoverCam.hover();
			}
			applyFilters();
		}
		private function initLensFlair():void{
			_lensFlair=new LensFlare(_source,_view.camera);
			_lensFlair.haloScaleFactor=79;
			_lensFlair.setHaloAsset(new HaloRing ());
			_lensFlair.addFlareAsset(new FlairRing1());
			_lensFlair.addFlareAsset(new FlairRing2());
			_lensFlair.addFlareAsset(new FlairRing3());
			_lensFlair.addFlareAsset(new FlairRing4());
			_lensFlair.addFlareAsset(new FlairRing5());
		//	_lensFlair.burnMethod=LensFlare.BURN_METHOD_BRIGHTNESS;
			_view.addOverlay(_lensFlair);
			_lensFlair.blendMode=BlendMode.ADD;
		}
		private function initFilters():void{
			_blurF=new BlurFilter(3,3,3);
			var colArr:Array=[0.99,0,0,0,-32,
				              0,0.99,0,0,-21,
				              0,0,0.99,0,-17,
				              0,0,0,0.75,0
			];
			_colMatrixF=new ColorMatrixFilter(colArr);
			var dispBmd:BitmapData=new BitmapData(stage.stageWidth,stage.stageHeight);
			dispBmd.perlinNoise(36,23,12,34543,true,true,7,true);
			_displF=new DisplacementMapFilter(dispBmd,null,BitmapDataChannel.BLUE,BitmapDataChannel.RED,4,4,DisplacementMapFilterMode.WRAP);
			_drawMatr=new Matrix(1,0,0,1,500,180);
		}
		private function applyFilters():void{
			_renderBData.draw(_overlay,_drawMatr);
			_renderBData.applyFilter(_renderBData,_renderBData.rect,new Point(0,0),_blurF);
			_renderBData.applyFilter(_renderBData,_renderBData.rect,new Point(0,0),_colMatrixF);
			_renderBData.applyFilter(_renderBData,_renderBData.rect,new Point(0,0),_displF);
		}
		private function setHowerCamera():void{
			_hoverCam=new HoverCamera3D();
			_view.camera=_hoverCam;
			_hoverCam.target=_camTarget;
			_hoverCam.distance = 1800;
			_hoverCam.maxTiltAngle = 0;
			_hoverCam.minTiltAngle = 0;
		}
		
	}
}