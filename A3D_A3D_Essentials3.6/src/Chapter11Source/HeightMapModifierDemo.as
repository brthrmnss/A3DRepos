package  
{
	import away3d.core.utils.Cast;
	import away3d.materials.utils.HeightMapDataChannel;
	import away3d.modifiers.HeightMapModifier;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	import flash.geom.Vector3D;

	public class HeightMapModifierDemo extends Away3DTemplate
	{
		[Embed(source="sphere.jpg")]
		protected var SphereTex:Class;
		
		protected var sphere:Sphere;
		
		public function HeightMapModifierDemo() 
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			
			camera.position = new Vector3D(0, 0, 500);
			camera.lookAt(new Vector3D(0, 0, 0));

			sphere = new Sphere(
				{
					segmentsW: 32,
					segmentsH: 32
				}
			);
			
			scene.addChild(sphere);
			
			var modifier:HeightMapModifier = new HeightMapModifier(
				sphere, 
				Cast.bitmap(SphereTex),
				HeightMapDataChannel.RED,
				16
			);
			modifier.execute();
		}
	}
}