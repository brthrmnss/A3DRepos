package Chapter3Source
{
	import away3d.primitives.Sphere;
	
	public class LocalAxisMovement extends Away3DTemplate
	{
		public function LocalAxisMovement()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			
			var sphere:Sphere = new Sphere(
				{
					x: 0,
					y: 0,
					z: 500
				}
			);
			scene.addChild(sphere);
			sphere.rotationY = -90;
			
			
			sphere.moveForward(50);
		}
		
	}
}