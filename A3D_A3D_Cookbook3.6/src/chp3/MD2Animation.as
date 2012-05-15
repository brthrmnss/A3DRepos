package chp3
{
	import away3d.animators.VertexAnimator;
	import away3d.animators.data.*;
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.utils.*;
	import away3d.loaders.*;
	import away3d.loaders.utils.AnimationLibrary;
	import away3d.materials.*;
	import away3d.test.Button;
	
	import flash.display.*;
	import flash.events.*;
	
	[SWF(backgroundColor="#000000", frameRate="30", quality="LOW", width="800", height="600")]
	
	public class MD2Animation extends AwayTemplate
	{
		
		
		
		[Embed(source="../assets/animatedSpy/spyAnimatedReady.md2",mimeType="application/octet-stream")]
		private var SpyModel:Class;
		
		
		[Embed(source="../assets/animatedSpy/spyObjRe.jpg")]
		private var SpyTexture:Class;
		
		private var _hoverCam:HoverCamera3D;
		private var _bitMat:BitmapMaterial;
		private var _md2:Md2;
		private var _model:Mesh;
		private var _standBut:Button;
		private var _walksBut:Button;
		private var _move:Boolean = false;
		private var _lastPanAngle:Number;
		private var _lastTiltAngle:Number;
		private var _lastMouseX:Number;
		private var _lastMouseY:Number;
		private var _animStand:VertexAnimator;
		private var _walkAnim:VertexAnimator;
		public function MD2Animation()
		{
			super();
			initButtons();
		}
		private function initHoverCam():void
		{

			_hoverCam = new HoverCamera3D();
			_hoverCam.zoom=3;
			_hoverCam.panAngle = 45;
			_hoverCam.tiltAngle = 20;
			_hoverCam.hover();
			_view.camera = _hoverCam;
	
		}

		override protected function initMaterials() : void
		{
			_bitMat = new BitmapMaterial(Cast.bitmap(SpyTexture));
		}
		override protected function initGeometry() : void{
			_md2 = new Md2();
			_model = _md2.parseGeometry(SpyModel) as Mesh;
	    	_model.material = _bitMat;
			_model.scale(0.05);
			_view.scene.addChild(_model);
			_animStand=accessAnimationByName("stand",0,false,true,20);
			_walkAnim=accessAnimationByName("walk",0,true,true,20);
		}
		private function accessAnimationByName(str:String,delay:Number=0,loop:Boolean=true,interp:Boolean=true,fps:Number=30):VertexAnimator{
			var animdata:AnimationLibrary=_model.animationLibrary;
			var anim:VertexAnimator=animdata.getAnimation(str).animator as VertexAnimator;
			anim.delay=delay;
			anim.loop=loop;
			anim.interpolate=interp;
			anim.fps=fps;
			return anim;
		}
		
		private function initButtons():void
		{
			_standBut = new Button("Stand", 100);
			_standBut.x = 580;
			_standBut.y = 40;
			addChild(_standBut);
			_walksBut = new Button("Walk", 100);
			_walksBut.x = 580;
			_walksBut.y = 80;
			addChild(_walksBut);
		}
		override protected function initListeners():void
		{
			initHoverCam();
			super.initListeners();
			addEventListener(MouseEvent.CLICK, onButtonClick);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
	
		private function onButtonClick(event:Event):void
		{
			var button:Button = event.target as Button;
		
			switch(button) {
				case _standBut:
				_animStand.play();
					break;
				case _walksBut:
					_walkAnim.play();
					break;
			}
		}

		override protected  function onEnterFrame(e:Event):void
		{
			super.onEnterFrame(e);
			if (_model)
				_model.rotationY += 0.5;
			
			if (_move) {
				_hoverCam.panAngle = 0.3 * (stage.mouseX - _lastMouseX) + _lastPanAngle;
				_hoverCam.tiltAngle = 0.3 * (stage.mouseY - _lastMouseY) + _lastTiltAngle;
			}
			_hoverCam.hover();  
			
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			_lastPanAngle = _hoverCam.panAngle;
			_lastTiltAngle = _hoverCam.tiltAngle;
			_lastMouseX = stage.mouseX;
			_lastMouseY = stage.mouseY;
			_move = true;
		}
	
		private function onMouseUp(e:MouseEvent):void
		{
			_move = false;
		    
		}
		
	}
}