package  Chapter11Source
{
	import away3d.core.geom.Path;
	import away3d.core.utils.Cast;
	import away3d.extrusions.PathExtrusion;
	import away3d.materials.BitmapMaterial;
	import flash.geom.Vector3D;

	public class PathExtrusionDemo extends Away3DTemplate
	{
		[Embed(source="away3dlogo.jpg")]
		protected var Away3DLogo:Class;
		
		public function PathExtrusionDemo() 
		{
			super();
		}
		
		protected override function initScene():void 
		{
			super.initScene();
			
			camera.position = new Vector3D(0, 500, 500);
			camera.lookAt(new Vector3D(0, 0, 0));
				
			var path:Path = new Path(
				[
					new Vector3D(-150, 0, 0),
					new Vector3D(-100, 0, 75),
					new Vector3D(0, 0, 0),
					new Vector3D(0, 0, 0),
					new Vector3D(100, 0, -75),
					new Vector3D(150, 0, 0)
				]
			);
				
			var profile : Array = 
				[
					new Vector3D(0, -100, 0),
					new Vector3D(0, 100, 0)
				];
			
			var extrusion:PathExtrusion = new PathExtrusion(
				path, 
				profile, 
				null,
				null,
				{
					material: new BitmapMaterial(Cast.bitmap(Away3DLogo)),
					bothsides: true,
					subdivision: 10
				}
			);
			scene.addChild(extrusion);
		}
		
	}

}