package  
{
	import away3d.core.utils.Cast;
	import away3d.extrusions.Elevation;
	import away3d.extrusions.SkinExtrude;
	import away3d.materials.BitmapMaterial;
	import flash.geom.Vector3D;

	public class SkinExtrusionDemo extends Away3DTemplate
	{
		[Embed(source="heightmap.jpg")]
		protected var Heightmap:Class;
		
		[Embed(source="terrain.jpg")]
		protected var Terrain:Class;
		
		protected var extrude:SkinExtrude;
		
		public function SkinExtrusionDemo() 
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			
			camera.position = new Vector3D(400, 200, 400);
			camera.lookAt(new Vector3D(0, 0, 0));

			var terrainMaterial:BitmapMaterial = 
				new BitmapMaterial(Cast.bitmap(Terrain));
			 
			var elevation:Elevation = new Elevation();
			var verticies:Array = 
				elevation.generate(
					Cast.bitmap(Heightmap), 
					"r", 
					16, 
					16, 
					1, 
					1, 
					0.25
				);

			extrude = new SkinExtrude(verticies, 
				{
					coverall: true, 
					material: terrainMaterial, 
					recenter: true,
					bothsides: true
				}
			);
			
			extrude.rotationX = 90;
			extrude.x = extrude.y = extrude.z = 0;
			 
			scene.addChild(extrude);
		}
	}
}