package  chp1
{
	import away3d.primitives.Sphere;
	
	public class SphereDemo extends Away3DTemplate
	{
		public function SphereDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			var sphere:Sphere = new Sphere();
			
			scene.addChild(sphere);
		}
	}
}