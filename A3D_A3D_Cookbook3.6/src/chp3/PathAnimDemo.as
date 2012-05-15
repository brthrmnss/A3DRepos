package chp3
{
	import away3d.animators.PathAnimator;
	import away3d.core.geom.Path;
	import away3d.core.utils.Cast;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Skybox6;
	import away3d.primitives.Sphere;
	
	import flash.events.Event;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class PathAnimDemo extends AwayTemplate
	{
		[Embed(source="assets/skybox.jpg")]
		private var SkyBoxTxt:Class;
		private var _skyBox:Skybox6;
		private var _path:Path;
		private var _pathAnimator:PathAnimator;
		private var _colMat:ColorMaterial;
		private var _skyBoxMat:BitmapMaterial;
		private var _sphere:Sphere;
		private var _counter:Number=0;
		private var _camPos:Vector3D=new Vector3D();
		private var _dummy:Sphere=new Sphere();
		public function PathAnimDemo()
		{
			super();
			
		}		
		
		override protected function setup(): void
		{
			setupSkyBox();
			generateRandomGeom();
			initPath();
		
		}
		
		override protected function initGeometry():void{
		   _sphere=new Sphere({radius:30,material:_colMat});
		   _view.scene.addChild(_sphere);
		   _dummy.radius=70;
		   _dummy.material=new ColorMaterial(0x229933);
		//   _view.scene.addChild(_dummy);
		}
		override protected function initMaterials():void{
			_skyBoxMat=new BitmapMaterial(Cast.bitmap(new SkyBoxTxt()));
			_skyBoxMat.smooth=true;
		  _colMat=new ColorMaterial(0x330099);	
		}
		override protected function onEnterFrame(e:Event):void{
			super.onEnterFrame(e);
			if(_pathAnimator){
				_counter=(_counter +0.001>1)? 0 : _counter+0.001;

				_pathAnimator.update(_counter);
			
				_pathAnimator.getPositionOnPath(_camPos,_counter);
				
				_cam.moveTo(_camPos.x,_camPos.y,_camPos.z);
			
				_cam.lookAt(_sphere.position);
			}
		}
		private function generateRandomGeom():void{
			
			for(var i:int=0;i<120;++i){
				var colMat:ColorMaterial=new ColorMaterial();
				colMat.color=Math.floor(Math.random()*0xffffcc);
				var sp:Sphere=new Sphere({radius:Math.random()*50+10,material:colMat,segmentsH:4,segmentsW:4});
				_view.scene.addChild(sp);
				sp.x=Math.random()*6000-3000;
				sp.y=Math.random()*6000-3000;
				sp.z=Math.random()*6000-3000;
			}
		}
		private function setupSkyBox():void{
			_skyBox=new Skybox6(_skyBoxMat);
			_skyBox.scale(6);
			_view.scene.addChild(_skyBox);
		}
		private function initPath():void{
			_path=new Path(fillPathData());
			_pathAnimator=new PathAnimator(_path,_sphere);
			_pathAnimator.fps=12;
			_pathAnimator.alignToPath=true;
			
			_pathAnimator.offset=new Vector3D(0,0,0);
			
			//_pathAnimator.play();
			
		}
		private function fillPathData():Array{
			return [new Vector3D(2250,0,-1098),
				new Vector3D(1479,736.0590873120664,-1308),
				new Vector3D(468,1227.3152579417474,-1255.5),
				new Vector3D(468,1227.3152579417474,-1255.5),
				new Vector3D(-543,1718.5714285714284,-1203),
				new Vector3D(-1143,1823.5714285714355,-592.5),
				new Vector3D(-1143,1823.5714285714355,-592.5),
				new Vector3D(-1743,1928.5714285714425,18),
				new Vector3D(-1212,1349.5474481061212,712.9942699490663),
				new Vector3D(-1212,1349.5474481061212,712.9942699490663),
				new Vector3D(-681,770.5234676407999,1407.9885398981326),
				new Vector3D(286.5,385.26173382039997,1563.7231161029113),
				new Vector3D(286.5,385.26173382039997,1563.7231161029113),
				new Vector3D(1254,0,1719.4576923076897),
				new Vector3D(2647.3750000000073,-1375.0000000000368,856.7547528665441),
				new Vector3D(2647.3750000000073,-1375.0000000000368,856.7547528665441),
				new Vector3D(4040.7500000000146,-2750.0000000000737,-5.948186574601472),
				new Vector3D(2340,0,-888)]
		}
	}
}