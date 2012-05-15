package
{
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Sphere;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class InteractiveRotate extends AwayTemplate
	{
		private var _sphere:Sphere;
		private var _bitMat:BitmapMaterial;
		private var _lastSphereXRot:Number=0;
		private var _lastSphereYRot:Number=0;
		private var _lastMouseX :Number=0;
		private var _lastMouseY :Number=0;
		private var _lastMouseXUP:Number=0;
		private var _lastMouseYUP :Number=0;
		private var _canMove:Boolean=false;
		private const  EASE:Number=0.2;
		public function InteractiveRotate()
		{
			super();
		}
		override protected function initGeometry():void{
			_sphere=new Sphere({radius:80,material:_bitMat,segmentsH:20,segmentsW:20});
			_view.scene.addChild(_sphere);
			_sphere.z=600;
		}
		override protected function initListeners():void{
			super.initListeners();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp,false,0,true);
		}
		override protected function initMaterials():void{
			var bdata:BitmapData=new BitmapData(256,256);
			bdata.perlinNoise(26,26,18,1534,false,true,7,true);
			_bitMat=new BitmapMaterial(bdata);
			
		}
		override protected function onEnterFrame(e:Event):void{
			super.onEnterFrame(e);
			///////////first option with acceleration and easing////////////////
			if (_canMove) {
				_sphere.rotationY =(stage.mouseX - _lastMouseX)*EASE+ _lastSphereXRot;
				_sphere.rotationX=(stage.mouseY - _lastMouseY)*EASE+ _lastSphereYRot;
			}else{
				if(_lastMouseXUP>=1){
					_lastMouseXUP=0.55;
				}
				if(_lastMouseYUP>=1){
					_lastMouseYUP=0.55;
				}
				_lastMouseX*=_lastMouseXUP;
				_lastMouseY*=_lastMouseYUP; 
				_sphere.rotationY +=_lastMouseX; 
				_sphere.rotationX +=_lastMouseY;
			}
			///////second option////
			/*if (_canMove) {

				_sphere.rotationY=(stage.mouseX - _lastMouseX)+ _lastSphereYRot;
				_sphere.rotationX=(stage.mouseY - _lastMouseY)+ _lastSphereXRot;
			}*/
		}
		private function onMouseDown(e:MouseEvent):void
		{
			_lastSphereXRot = _sphere.rotationX;
			_lastSphereYRot =_sphere.rotationY;
			_lastMouseX = stage.mouseX;
			_lastMouseY = stage.mouseY;
			_canMove = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		private function onMouseUp(e:MouseEvent):void
		{
			_lastMouseXUP=Math.abs(_lastMouseX-stage.mouseX)/1000;
			_lastMouseYUP=Math.abs(_lastMouseY-stage.mouseY)/1000;
			trace(_lastMouseXUP);
			_canMove = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
		}
		private function onStageMouseLeave(event:Event):void
		{
			_canMove = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
		}
	}
}