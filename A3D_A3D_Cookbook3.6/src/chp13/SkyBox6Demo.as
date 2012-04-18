package chp13
{
	import away3d.cameras.HoverCamera3D;
	import away3d.core.utils.Cast;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Skybox6;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[SWF(backgroundColor="#677999", frameRate="30", quality="HIGH", width="800", height="600")]
	public class SkyBox6Demo extends AwayTemplate
	{
		[Embed(source="assets/skyBoxSet/SkyBox6TextureReady.jpg")]
		private var SkyBoxTxt:Class;
		
		////////////////
		private var  _skyBoxMat:BitmapMaterial;
		private var _skyBox:Skybox6;
		private var _oldMsX:Number=0;
		private var _oldMsY:Number=0;
		private var _howCam:HoverCamera3D;
		
		private var _lastPanAngle:Number;
		private var _lastTiltAngle:Number;
		private var _canMove:Boolean=false;
		public function SkyBox6Demo()
		{
			super();
			initHoverCam();
			
		}
		override protected function initMaterials() : void{
			
			
			_skyBoxMat=new BitmapMaterial(Cast.bitmap(new SkyBoxTxt()));
			_skyBoxMat.smooth=true;
			
		}
		override protected function initGeometry() : void{
			_skyBox=new Skybox6(_skyBoxMat);
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
		
		private function onMouseUp(event:MouseEvent):void
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