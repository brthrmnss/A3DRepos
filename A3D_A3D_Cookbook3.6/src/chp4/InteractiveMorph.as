package
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.core.base.Face;
	import away3d.core.vos.FaceVO;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight3D;
	import away3d.materials.ShadingColorMaterial;
	import away3d.primitives.Plane;
	import away3d.test.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class InteractiveMorph extends AwayTemplate
	{
		private var _light:PointLight3D;
		private var _plane:Plane;
		private var _pushVector:Vector3D=new Vector3D(0,20,0);
		private var _but1:Button;
		private var _but2:Button;
		private var _canExtrude:Boolean=false;
		
		public function InteractiveMorph()
		{
			super();
			_view.camera.lens=new PerspectiveLens();
			_cam.z=-100;
			initLight();
			initControls();
			
		}
		
		override protected function initGeometry() : void{
			
			_plane=new Plane({width:1000,height:1000,material:new ShadingColorMaterial(0x229933)});
			_plane.segmentsH=_plane.segmentsW=35;
			_view.scene.addChild(_plane);
			_plane.rotationX=30;
			_plane.position=new Vector3D(0,0,800);
			_plane.ownCanvas=true;
			
		}
		override protected function initListeners() : void{
			super.initListeners();
			_plane.addEventListener(MouseEvent3D.MOUSE_DOWN,onMouse3dDown);
			_plane.addEventListener(MouseEvent3D.MOUSE_MOVE,onMouse3dMove);
			_plane.addEventListener(MouseEvent3D.MOUSE_UP,onMouse3dUp);
			_plane.addEventListener(MouseEvent3D.MOUSE_OUT,onMouse3dOut);
		}
		override protected function onEnterFrame(e:Event) : void{
			
			super.onEnterFrame(e);
		}
		private function initControls():void{
			_but1=new Button("push up");
			_but2=new Button("push down");
			_view.addChild(_but1);_view.addChild(_but2);
			_but1.x=_but2.x=-300;
			_but1.y=-280;_but2.y=_but1.y+35;
			_but1.addEventListener(MouseEvent.CLICK,onMouseClick);
			_but2.addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		private function onMouseClick(e:MouseEvent):void{
			switch(e.currentTarget){
				case _but1:
					_pushVector=new Vector3D(0,20,0);
					break;
				case _but2:
					_pushVector=new Vector3D(0,-20,0);
					break;
			}
		}
		private function initLight():void{
			_light=new PointLight3D
			_view.scene.addLight(_light);
			_light.position=new Vector3D(50,50,50);
		}
		private function onMouse3dDown(e:MouseEvent3D):void{
			_canExtrude=true;
		     
		}
		private function onMouse3dMove(e:MouseEvent3D):void{
			var face:Face=FaceVO(e.elementVO).face;
			if(_canExtrude&&face is Face){
				for(var i:int=0;i<face.vertices.length;++i){
					face.vertices[i].setValue(face.vertices[i].x+=_pushVector.x,face.vertices[i].y+=_pushVector.y,face.vertices[i].z+=_pushVector.z);
				}
			}
		}
		private function onMouse3dUp(e:MouseEvent3D):void{
			_canExtrude=false;
		}
		private function onMouse3dOut(e:MouseEvent3D):void{
			_canExtrude=false;
		}
	}
}