package chp13
{
	import away3d.cameras.HoverCamera3D;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Skybox;
	
	import flash.display.Bitmap;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[SWF(backgroundColor="#677999", frameRate="30", quality="HIGH", width="800", height="600")]
	public class SkyBoxDemo extends AwayTemplate
	{
		//////////////////////embedded/////////////////////
		[Embed(source="assets/skyBoxSet/awayskyWithEarth_bk.jpg")]
		private var BackSky:Class;
		[Embed(source="assets/skyBoxSet/awayskyWithEarth_dn.jpg")]
		private var BottomSky:Class;
		[Embed(source="assets/skyBoxSet/awayskyWithEarth_ft.jpg")]
		private var FrontSky:Class;
		[Embed(source="assets/skyBoxSet/awayskyWithEarth_lf.jpg")]
		private var LeftSky:Class;
		[Embed(source="assets/skyBoxSet/awayskyWithEarth_rt.jpg")]
		private var RightSky:Class;
		[Embed(source="assets/skyBoxSet/awayskyWithEarth_up.jpg")]
		private var TopSky:Class;
		
		
		///////////////////////////////////////////////////
		private var _skyBox:Skybox;
		private var _frontM:BitmapMaterial;
		private var _backM:BitmapMaterial;
		private var _topM:BitmapMaterial;
		private var _bottomM:BitmapMaterial;
		private var _leftM:BitmapMaterial;
		private var _rightM:BitmapMaterial;
		//
		private var _oldMsX:Number=0;
		private var _oldMsY:Number=0;
	    private var _howCam:HoverCamera3D;
		
		private var _lastPanAngle:Number;
		private var _lastTiltAngle:Number;
		private var _canMove:Boolean=false;
		public function SkyBoxDemo()
		{
			super();
			initHoverCam()
			
		}
		
		override protected function initMaterials() : void{
			_frontM=new BitmapMaterial(Bitmap(new BackSky()).bitmapData);
			_leftM=new BitmapMaterial(Bitmap(new RightSky()).bitmapData);///left
			_backM=new BitmapMaterial(Bitmap(new FrontSky()).bitmapData);
			_rightM=new BitmapMaterial(Bitmap(new LeftSky()).bitmapData);////right	
			_topM=new BitmapMaterial(Bitmap(new TopSky()).bitmapData);
			_bottomM=new BitmapMaterial(Bitmap(new BottomSky()).bitmapData);	
		}
		override protected function initGeometry() : void{
			_skyBox=new Skybox(_frontM,_rightM,_backM,_leftM,_topM,_bottomM);
			_view.scene.addChild(_skyBox);			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown,false,0,true);	
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp,false,0,true);
		}
		private function initHoverCam():void{
			_howCam=new HoverCamera3D();
			_view.camera=_howCam;
			_howCam.focus = 40;
		}
		private function onMouseDown(e:MouseEvent):void
		{
			_lastPanAngle = _howCam.panAngle;
			_lastTiltAngle = _howCam.tiltAngle;
			_oldMsX = stage.mouseX;
			_oldMsY = stage.mouseY;
			_canMove = true;
		}
		private function onMouseUp(e:MouseEvent):void
		{
			_canMove = false;
		}
		override protected function onEnterFrame(e:Event):void{
			super.onEnterFrame(e);
			if (_canMove) {
				_howCam.panAngle = 0.3 * (stage.mouseX - _oldMsX) + _lastPanAngle;
				_howCam.tiltAngle = 0.3 * (stage.mouseY - _oldMsY) + _lastTiltAngle;
			}
			_howCam.hover(); 
		}
	}
}