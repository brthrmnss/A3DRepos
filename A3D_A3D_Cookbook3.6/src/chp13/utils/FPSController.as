package utils
{
	import away3d.core.base.Object3D;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	public class FPSController extends Sprite
	{
		private var _stg:Stage;
		private var _camera:Object3D
		private var _moveLeft:Boolean=false;
		private var _moveRight:Boolean=false;
		private var _moveForward:Boolean=false;
		private var _moveBack:Boolean=false;
		private var _controllerHeigh:Number;
		
		private var _camSpeed:Number=0;/////////speed of camera
		private var _camAccel:Number=2;/// forward acceleration
		
		private var _camSideSpeed:Number=0;
		private var _camSideAccel:Number=2;
		
		private var _forwardLook:Vector3D=new Vector3D();
		private var _sideLook:Vector3D=new Vector3D();
		private var _camTarget:Vector3D=new Vector3D();
		private var _oldPan:Number=0;
		private var _oldTilt:Number=0;
		private var _pan:Number=0;
		private var _tilt:Number=0;
		private var _oldMouseX:Number=0;
		private var _oldMouseY:Number=0;
		private var DEGStoRADs:Number = Math.PI / 180;
		private var _canMove:Boolean=false;
		////////////grvity////////
		private var _gravity:Number=5;
		private var _jumpSpeed:Number=0;
		private var _jumpStep:Number;
		private var _gravAccel:Number=0.2;
		
		private static const MAX_JUMP:Number=100;
		public function FPSController(camera:Object3D,stg:Stage,height:Number=20,gravity:Number=5,jumpStep:Number=5)
		{
			_camera=camera;
			_stg=stg;
			_controllerHeigh=height;
			_gravity=gravity;
			_jumpStep=jumpStep;
			init();
			
		}
		private function init():void{
			//_camera.y=_controllerHeigh;
			addListeners();
		}
		private function addListeners():void{
			_stg.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown,false,0,true);
			_stg.addEventListener(MouseEvent.MOUSE_UP, onMouseUp,false,0,true);
			_stg.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown,false,0,true);
			_stg.addEventListener(KeyboardEvent.KEY_UP, onKeyUp,false,0,true);
			
		}
		
		private function onMouseDown(e:MouseEvent):void{
			_oldPan=_pan;
			_oldTilt=_tilt;
			_oldMouseX=_stg.mouseX+400;
			_oldMouseY=_stg.mouseY-300;
			_canMove=true;
		}
		private function onMouseUp(e:MouseEvent):void{
			_canMove=false;
		}
		private function onKeyDown(e:KeyboardEvent):void{
			switch(e.keyCode)
			{
				//////left/////
				case 65:
					_moveLeft = true;
				break;
				////////right
				case 68:
				
				    _moveRight = true;
				break;
				///move forward////////
				case 87:
				
					_moveForward = true;
				break;
				/////move back
				case 83:
				
					_moveBack = true;
				break;
				case Keyboard.SPACE:
					if(_camera.y<MAX_JUMP+_controllerHeigh){
						_jumpSpeed+=_jumpStep;
					}else{
						_jumpSpeed=0;
					}
					
				break;
				default:
			}
		}
		private function onKeyUp(e:KeyboardEvent):void{
			switch(e.keyCode)
			{
				//////left/////
				case 65:
					_moveLeft = false;
					break;
				////////right
				case 68:
					
					_moveRight = false;
					break;
				///move up////////
				case 87:
					
					_moveForward = false;
					break;
				/////move down
				case 83:
					
					_moveBack = false;
					break;
				case Keyboard.SPACE:
					_jumpSpeed=0;
				break;
				default:
			}
		}
		public function walk(elevationHeight:Number):void{
			_controllerHeigh=elevationHeight;
			//////slowing down the speed by default
			_camSpeed *= (1-0.12);
			_camSideSpeed*= (1-0.12);
			if(_moveForward){ _camSpeed+=_camAccel;}
			if(_moveBack){_camSpeed-=_camAccel;}
			if(_moveLeft){_camSideSpeed-=_camSideAccel;}
			if(_moveRight){_camSideSpeed+=_camSideAccel;}
				
			
			////////////////halting the movement/////////
			if (_camSpeed < 2 && _camSpeed > -2){
				_camSpeed=0;
				
			}
			////////////////halting the side movement/////////
			if (_camSideSpeed < 0.05 && _camSideSpeed > -0.05){
				_camSideSpeed=0;
			}
			//--------------
	//	var mtr:Matrix3D
	//	mtr.
			///
			///_forwardLook.rotate(new Number3D(0,0,1),_camera.transform);replaced by FP10 native
				
			_forwardLook=_camera.transform.deltaTransformVector(new Vector3D(0,0,1));///WORKS FINE :NUmber3D rotate()=Matrix3D deltaTransformVector
			_forwardLook.normalize();
			_camera.x+=_forwardLook.x*_camSpeed;
			_camera.z+=_forwardLook.z*_camSpeed;
		
		//	_sideLook.rotate(new Number3D(1,0,0),_camera.transform);replaced by FP10 native
	
			_sideLook=_camera.transform.deltaTransformVector(new Vector3D(1,0,0));
			_sideLook.normalize();
			_camera.x+=_sideLook.x*_camSideSpeed;
			_camera.z+=_sideLook.z*_camSideSpeed;
			
			_camera.y+=_jumpSpeed;
			
			////////////rotation///////////////
			if(_canMove){
				_pan = 0.3*(_stg.mouseX+400 - _oldMouseX) + _oldPan;
				_tilt = -0.3*(_stg.mouseY-300 - _oldMouseY) + _oldTilt;
				if (_tilt > 70){
					_tilt = 70;
				}
				
				if (_tilt < -70){
					_tilt = -70;
				}
				
				
			}
			/////////////setting camera look target position
			var panRADs:Number=_pan*DEGStoRADs;
			var tiltRADs:Number=_tilt*DEGStoRADs;
			_camTarget.x =  100*Math.sin( panRADs) * Math.cos(tiltRADs) + _camera.x;
			_camTarget.z =  100*Math.cos( panRADs) * Math.cos(tiltRADs) + _camera.z;
			_camTarget.y =  100*Math.sin(tiltRADs) +_camera.y;
			
			
				//////////////jump/////////////////
			
			if(_camera.y>_controllerHeigh){
				_gravity+=2.1*_gravAccel;
				_camera.y-=_gravity;
			
				
			}
			if(_camera.y<=_controllerHeigh ){
				_camera.y=_controllerHeigh;
				_gravity=5;
				
			}
			
			_camera.lookAt(_camTarget);
			
			
		}
	}
}