package
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight3D;
	import away3d.materials.ColorMaterial;
	import away3d.materials.PhongColorMaterial;
	import away3d.materials.ShadingColorMaterial;
	import away3d.primitives.Plane;
	
	import flash.events.Event;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class PlaneUnproject extends AwayTemplate
	{
		private var _tracker:Plane;
		private var _unprojVector:Vector3D;
		private var _phongMat:PhongColorMaterial;
		private var _light:PointLight3D;
		private var _plane:Plane;
		public function PlaneUnproject()
		{
			super();
			_view.camera.lens=new PerspectiveLens();
			_cam.z=-500;
			_cam.y=-400;
			initLight();
		}
		override protected function initMaterials() : void{
			_phongMat=new PhongColorMaterial(0x339944);
		}
		override protected function initGeometry() : void{

			_plane=new Plane({width:1000,height:1000,material:new ShadingColorMaterial(0x229933)});
			_plane.segmentsH=_plane.segmentsW=8;
			_view.scene.addChild(_plane);
			_plane.rotationX=30;
			_plane.position=new Vector3D(0,0,800);
			_tracker=new Plane({width:100,height:100,material:new ColorMaterial(0x446633)});
			_tracker.bothsides=true;
			_view.scene.addChild(_tracker);
			var plpos:Vector3D=_plane.position;
			plpos.y+=200;
			plpos.z-=100;
			_cam.lookAt(plpos);
		}
		override protected function initListeners() : void{
			super.initListeners();
			_plane.addEventListener(MouseEvent3D.MOUSE_MOVE,onMouseMove);
		}
		override protected function onEnterFrame(e:Event) : void{
			
				if(_unprojVector){

					_tracker.transform=_plane.transform.clone();
					_tracker.x=_unprojVector.x;
					_tracker.y=_unprojVector.y;
					_tracker.z=_unprojVector.z;
					_tracker.translate(Vector3D.Y_AXIS,50);

				}
		
			super.onEnterFrame(e);
		}
		private function initLight():void{
			_light=new PointLight3D();
			_view.scene.addLight(_light);
			_light.position=new Vector3D(50,50,50);
		}
		private function onMouseMove(e:MouseEvent3D):void{
			_unprojVector=new Vector3D(e.sceneX,e.sceneY,e.sceneZ);

	    }
	}
}