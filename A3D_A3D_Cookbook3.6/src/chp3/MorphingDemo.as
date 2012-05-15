package chp3
{
	import away3d.cameras.HoverCamera3D;
	import away3d.core.base.Morpher;
	import away3d.core.base.Vertex;
	import away3d.lights.DirectionalLight3D;
	import away3d.materials.PhongBitmapMaterial;
	import away3d.primitives.Sphere;
	import away3d.test.Button;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class MorphingDemo extends AwayTemplate
	{
		private var _sphere:Sphere;
		private var _morphPattern:Sphere;
		private var _phongBit:PhongBitmapMaterial;
		private var _dirLight:DirectionalLight3D;
		private var _button:Button;
		private var _morpher:Morpher;
		private var _hoverCam:HoverCamera3D;
		private var _move:Boolean = false;
		private var _lastPanAngle:Number;
		private var _lastTiltAngle:Number;
		private var _lastMouseX:Number;
		private var _lastMouseY:Number;
		private var _defaultSphere:Sphere;
		public function MorphingDemo()
		{
			super();
		}
		
		override protected function setup(): void
		{
			initHoverCam();
			initLight();
			initUI();
		}
		
		private function initHoverCam():void
		{
			_hoverCam = new HoverCamera3D();
			_hoverCam.zoom=22;
			_hoverCam.panAngle = 45;
			_hoverCam.tiltAngle = 20;
			_hoverCam.hover();
			_view.camera = _hoverCam; 
			_hoverCam.target=_sphere;
		}
		private function initLight():void{
			_dirLight=new DirectionalLight3D();
			_dirLight.color=0xf3c3c5;
			_dirLight.specular=0.23;
			_dirLight.brightness=4.23;
			_dirLight.diffuse=4;
			_dirLight.ambient=4;
			_view.scene.addLight(_dirLight);
			_dirLight.direction=_sphere.position;
			
		}
		override protected function initListeners():void
		{
			super.initListeners();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
		}
		override protected function initMaterials() : void{
			var btmd:BitmapData=new BitmapData(256,256);
			btmd.perlinNoise(24,24,9,17,true,true,7,false);
			_phongBit=new PhongBitmapMaterial(btmd);
			_phongBit.smooth=true;
		}
		override protected function initGeometry() : void{
			_defaultSphere=new Sphere({radius:70,segmentsW:20,segmentsH:20})
			_sphere=new Sphere({radius:70,material:_phongBit,segmentsW:20,segmentsH:20});
			_morphPattern=new Sphere({radius:70,material:_phongBit,segmentsW:20,segmentsH:20});
			_view.scene.addChild(_sphere);
			_sphere.z=500;
			_morphPattern.y=-140;
			_morphPattern.x=100;
			_morphPattern.z=500;
			deformPattern();
			_morpher=new Morpher(_sphere);
			
		}
		private function initUI():void{
			_button=new Button("distort more",140);
			_button.y=-260;
			_button.x=-260;
			_view.addChild(_button);
			_button.addEventListener(MouseEvent.CLICK,onMouseClick,false,0,true);
		}
		private function onMouseClick(e:MouseEvent):void{
			if(_morpher){
				deformPattern();
			}
		}
			
		private function deformPattern():void{
			
			
			for(var i:int=0;i<_morphPattern.vertices.length;++i){
				
				var vert:Vertex=_morphPattern.vertices[i] as Vertex;
				var multFactor:Number=Math.random()*0.5;
				var vector:Vector3D=vert.position;
				vector.scaleBy(multFactor);
				vert.add(vector);
			}
		}
		override protected function onEnterFrame(e:Event) : void{
			super.onEnterFrame(e);
			if(_morpher){
				_morpher.start();
				_morpher.mix(_morphPattern,1+Math.sin(getTimer()/1000));		
				_morpher.finish(_defaultSphere);
			}
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