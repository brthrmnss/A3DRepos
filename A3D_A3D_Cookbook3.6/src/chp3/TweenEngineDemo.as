package chp3
{
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.utils.DofCache;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Sphere;
	import away3d.sprites.DepthOfFieldSprite;
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	


	[SWF(backgroundColor="#000000", frameRate="30", quality="HIGH", width="800", height="600")]
	public class TweenEngineDemo extends AwayTemplate
	{
		private static const MAX_NUM:int = 180;
		private var _animObjectsArr:Array=[];
		private var _matArrL:Array=[];
		private var _targetVertices:Array=[];
		private var _canProcess:Boolean=false;
		private var _hoverCam:HoverCamera3D;
		private var _move:Boolean = false;
		private var _lastPanAngle:Number;
		private var _lastTiltAngle:Number;
		private var _lastMouseX:Number;
		private var _lastMouseY:Number;
		private var _mainContainer:ObjectContainer3D;
		private var _spriteMat:BitmapMaterial;
	
		public function TweenEngineDemo()
		{
			super();
			
			initTweenData();
			initHoverCam();
			//_cam.z=-4700;
			DofCache.usedof=true;
			DofCache.maxblur=28;
			DofCache.focus=20;
			DofCache.aperture=23;
			DofCache.doflevels=10;
		}
		override protected function initListeners() : void{
			super.initListeners();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		override protected function initMaterials() : void{
			var bdata:BitmapData=new BitmapData(64,64);
			bdata.perlinNoise(12,12,15,18,false,true,7,false);
			_spriteMat=new BitmapMaterial(bdata);
			
		}
		private function initHoverCam():void
		{
			_hoverCam = new HoverCamera3D();
			_hoverCam.zoom=3;
			_hoverCam.panAngle = 45;
			_hoverCam.tiltAngle = 20;
			_view.camera = _hoverCam;
			_hoverCam.target=_mainContainer;
			
		}
		private function initTweenData():void{
			_mainContainer=new ObjectContainer3D();
			_view.scene.addChild(_mainContainer);
			var vertexPosArr:Array=[];
			/////////////////////////////////
			vertexPosArr[0]=[];
			var cube:Cube=new Cube({width:1200,height:300,depth:1200});
			cube.segmentsD=10;
			cube.segmentsH=10;
			cube.segmentsW=10;
			//cube.visible=false;
			//_view.scene.addChild(cube);
			for (var i:int =0; i < cube.vertices.length /3-10; i++){
				
					vertexPosArr[ 0 ][ i ] = new Vector3D(cube.vertices[ i*3 ].x, cube.vertices[ i*3 + 1 ].y, cube.vertices[ i*3 + 2 ].z);
				
			}
			///////////////////////////////////optional////////////////
				/*var cube1:Cube=new Cube({width:1000,height:1000,depth:1000});
				cube1.segmentsD=10;
				cube1.segmentsH=10;
				cube1.segmentsW=10;
				cube1.visible=false;
				_view.scene.addChild(cube1);*/
			var sphere:Sphere=new Sphere({radius:500});
			sphere.segmentsH=25;
			sphere.segmentsW=25;
			//sphere.visible=false;
			//_view.scene.addChild(sphere);
		    vertexPosArr [1] = [];
			for (var f:int = 0; f < sphere.vertices.length / 3-10; ++f)	{
				vertexPosArr[ 1 ][ f ] = new Vector3D(sphere.vertices[ f*3 ].x, sphere.vertices[ f*3 + 1 ].y, sphere.vertices[ f*3 + 2 ].z);
			}
			////////////////////
			vertexPosArr[2]=[];
			for (var k:int=0; k < MAX_NUM; ++k){
				
				vertexPosArr[ 2 ][ k ] = new Vector3D((Math.random() - 0.5) * 2000, (Math.random() - 0.5) * 2000, (Math.random() - 0.5) * 2000);
			}
			////////////////////////////
			for (var v:int = 0; v < MAX_NUM; v++) {
				var colMat:ColorMaterial=new ColorMaterial(Math.floor(Math.random()*0xffffff));
				_matArrL[v]=colMat;
				var sprite:DepthOfFieldSprite=new DepthOfFieldSprite(_spriteMat);
				_view.scene.addSprite(sprite);
				_animObjectsArr[v]=sprite;
				
			}
			///////init tweens//////////////
			var tweenGroup:Array=[];
			var tweenSequence:TimelineMax=new TimelineMax();
			for (var d:int = 0; d < MAX_NUM; d++) {
				var tween1:Vector3D = vertexPosArr[ 0 ][ d ];
				var tween2:Vector3D = vertexPosArr[ 1 ][ d ];
				var tween3:Vector3D = vertexPosArr[ 2 ][ d ];
				_targetVertices[d]=tween2;

				var tMax1:TweenMax=new TweenMax(_targetVertices[d],4,{ x: tween1.x, y: tween1.y, z: tween1.z ,ease:Linear.easeInOut});
				var tMax1a:TweenMax=new TweenMax(_targetVertices[d],4,{ x: tween3.x, y: tween3.y, z: tween3.z,ease:Linear.easeInOut });
				var tMax2:TweenMax=new TweenMax(_targetVertices[d],4,{ x: tween2.x, y: tween2.y, z: tween2.z,ease:Linear.easeInOut });
				var tMax2a:TweenMax=new TweenMax(_targetVertices[d],4,{ x: tween1.x, y: tween1.y, z: tween1.z,ease:Linear.easeInOut });
				var tMax3:TweenMax=new TweenMax(_targetVertices[d],4,{ x: tween3.x, y: tween3.y, z: tween3.z,ease:Linear.easeInOut });
				var tMax3a:TweenMax=new TweenMax(_targetVertices[d],4,{ x: tween2.x, y: tween2.y, z: tween2.z,ease:Linear.easeInOut});
			
				tweenSequence.insertMultiple([tMax1,tMax1a,tMax2,tMax2a,tMax3,tMax3a],0,TweenAlign.SEQUENCE,1);
			}
			tweenSequence.delay=1;
			tweenSequence.repeat=1200;
			tweenSequence.play();
			_canProcess=true;
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
		override protected function onEnterFrame(e:Event) : void{
			super.onEnterFrame(e);
			if(_canProcess){
				for (var i:int = 0; i < MAX_NUM; i++) {
					_animObjectsArr[i].x=_targetVertices[i].x;
					_animObjectsArr[i].y=_targetVertices[i].y;
					_animObjectsArr[i].z=_targetVertices[i].z;
				}
				
			}
			if (_move) {
				_hoverCam.panAngle = 0.3 * (stage.mouseX - _lastMouseX) + _lastPanAngle;
				_hoverCam.tiltAngle = 0.3 * (stage.mouseY - _lastMouseY) + _lastTiltAngle;
			}
			  
			_hoverCam.hover();
			
		}
	}
}