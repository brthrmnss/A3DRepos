package
{
	import away3d.cameras.SpringCam;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Mesh;
	import away3d.core.clip.FrustumClipping;
	import away3d.loaders.Collada;
	import away3d.loaders.Loader3D;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cube;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	
	
	
	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class InterActiveCar extends AwayTemplate
	{
		[Embed(source="../assets/vehicle/PoliceCar.dae",mimeType="application/octet-stream")]
		private var CarModel:Class;
		[Embed(source="../assets/vehicle/TextureDPW.jpg")]
		private var CarTexture:Class;
		private var _loader:Loader3D;
		private var _model:ObjectContainer3D;
		private var _w1:ObjectContainer3D;
		private var _w2:ObjectContainer3D;
		private var _w3:ObjectContainer3D;
		private var _w4:ObjectContainer3D;
		private var _carBody:ObjectContainer3D;
		private var _bitmat:BitmapMaterial;
		private var _speed:Number=0;
		private var _steer:Number=0;
		private var _moveForward:Boolean=false;
		private var _moveBackward:Boolean=false;
		private var _moveRight:Boolean=false;
		private var _moveLeft:Boolean=false;
		private var _maxSpeed:Number=0;
		private var _defaultWheelsRot:Number=90;
		private var _springCam:SpringCam;
		private var _numBuilds:int=5;
		private var _angle:Number=0;
		private var _radius:int=70;
		private var _buildIter:int=1;
		public function InterActiveCar()
		{
			super();
			_view.clipping=new FrustumClipping;
			seedBuildings()
			
		}
		override protected function initListeners() : void{
			super.initListeners();
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,0,true);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
		}
		override protected function initMaterials() : void{
			_bitmat=new BitmapMaterial(Bitmap(new CarTexture()).bitmapData);
		}
		override protected function initGeometry() : void{
			setSpringCam();
			parseModel();
		}
		private function seedBuildings():void{
			for(var b:int=0;b<_numBuilds;++b){
				var h:Number=Math.floor(Math.random()*400+80);
				_angle=Math.PI*2/_numBuilds*b;
				var colMat:ColorMaterial=new ColorMaterial(Math.round(Math.random()*0x565656));
				var build:Cube=new Cube({width:20,height:h,depth:20});
				build.cubeMaterials.back=colMat;
				build.cubeMaterials.bottom=colMat;
				build.cubeMaterials.front=colMat;
				build.cubeMaterials.left=colMat;
				build.cubeMaterials.right=colMat;
				build.cubeMaterials.top=colMat;
				build.movePivot(0,-build.height/2,0);
				build.x=Math.cos(_angle)*_radius*_buildIter*2;
				build.z=Math.sin(_angle)*_radius*_buildIter*2;
				build.y=0;
				_view.scene.addChild(build);
			}
			_buildIter++;
			if(_buildIter<5){
				_numBuilds*=_buildIter/2;
				seedBuildings();
			}
		}
		private function setSpringCam():void{
			_springCam=new SpringCam();
			_view.camera=_springCam;
			_springCam.stiffness=0.55;
			_springCam.damping=5;
			_springCam.mass=45;
			_springCam.zoom=25;
			_springCam.positionOffset=new Vector3D(0,45,170);
		}
		private function parseModel():void{
			var dae:Collada=new Collada();
			_model=dae.parseGeometry(new CarModel())as ObjectContainer3D;
			_view.scene.addChild(_model);
			_w1=_model.getChildByName("node-Cylinder01")as ObjectContainer3D;///wheels:01,07,08,06///left back
			_w2=_model.getChildByName("node-Cylinder07")as ObjectContainer3D;///wheels:01,07,08,06////right back
			_w3=_model.getChildByName("node-Cylinder08")as ObjectContainer3D;///wheels:01,07,08,06////right front
			_w4=_model.getChildByName("node-Cylinder06")as ObjectContainer3D;///wheels:01,07,08,06///left front
			_carBody=_model.getChildByName("node-camaro01")as ObjectContainer3D;
			
			Mesh(_w1.children[0]).material=_bitmat;
			Mesh(_w1.children[0]).scaleX=-1;
			Mesh(_w2.children[0]).material=_bitmat;
			Mesh(_w3.children[0]).material=_bitmat;
			Mesh(_w4.children[0]).material=_bitmat;
			Mesh(_w4.children[0]).scaleX=-1;
			Mesh(_carBody.children[0]).material=_bitmat;
			TweenMax.to(_carBody,0.2,{y:5,yoyo:true,repeat:9999,ease:Linear.easeNone});
			
			_model.scaleX=-1;
			
			_springCam.target=_model;
		}
		
		//////////////////keyboard controls//////////////////
		private function onKeyDown(e:KeyboardEvent ):void
		{
			switch( e.charCode )
			{
				case 119: _moveForward=true;_moveBackward=false;break;/////forward
				case 115:_moveForward=false;_moveBackward=true;break;	/////backward
				case 97:  _moveRight=false;_moveLeft=true;break;////left
				case 100:_moveRight=true;_moveLeft=false;break;  //////right			
			}
		}
		
		private function onKeyUp(e:KeyboardEvent ):void
		{
			switch( e.charCode )
			{
				case 119:	_moveForward=false;break;	/////forward
				case 115:   _moveBackward=false;break;/////backward
				case 97:	_moveLeft=false;break;////left		
				case 100:	_moveRight=false;break;//////right		
			}
		}
		private function updateCar():void{
			// Speed
			if( _moveForward ){_maxSpeed = 5;}
			else if( _moveBackward )	{_maxSpeed = -5;}
			else	{_maxSpeed = 0;}
			
			_speed -= ( _speed - _maxSpeed ) / 20;
			if( _moveRight )
			{
				//	trace(_w3.rotationY);
				if(_w3.rotationY >= 120 ){
					_steer=0;
				}else{
					_steer+=8;
				}
				
			}
			else if( _moveLeft )
			{
				if( _w4.rotationY >=120 ){
					_steer=0;
				}else{
					_steer+=-8;
				}
			}else{
				_steer=0;
			}
			
		}
		
		override protected function onEnterFrame(e:Event) : void{
			super.onEnterFrame(e);
			
			if(_model){
				_springCam.view;
				_w1.children[0].yaw(-_speed*2)
				_w2.children[0].yaw(_speed*2);
				_w3.children[0].yaw(_speed*2);
				_w4.children[0].yaw(-_speed*2);
				
				_w3.rotate(new Vector3D(0,1,0),_steer);
				_w4.rotate(new Vector3D(0,1,0),-_steer);
				
				var modelRot:Number=(Math.ceil(_w4.rotationY)-_defaultWheelsRot)* Math.abs(_speed)/100;///*10 ;
				trace(_carBody.y);
				if(_moveForward){
					_model.yaw(modelRot );
				}else{
					_model.yaw(-modelRot );
				}
				
				_model.moveBackward( _speed );
				updateCar();
				
			}
			
		}
	}
}