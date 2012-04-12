package Chapter3Source
{
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.Sphere;
	
	public class GroupingExample extends Away3DTemplate
	{
		public function GroupingExample()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			
			var container:ObjectContainer3D = new ObjectContainer3D(
				{
					x: 0, 
					y: 0,
					z: 500
				}
			);
			scene.addChild(container);
			
			var sphere:Sphere = new Sphere(
				{
					x: 0, 
					y: 0,
					z: 0
				}
			);
			container.addChild(sphere);			
		}
	}
}