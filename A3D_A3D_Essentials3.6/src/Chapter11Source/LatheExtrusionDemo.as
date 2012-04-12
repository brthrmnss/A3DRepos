package  
{
	import away3d.extrusions.LatheExtrusion;
	import flash.geom.Vector3D;

	public class LatheExtrusionDemo extends Away3DTemplate
	{	
		protected var vase:LatheExtrusion;
		
		public function LatheExtrusionDemo() 
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			
			camera.position = new Vector3D(0, 500, 500);
			camera.lookAt(new Vector3D(0, 0, 0));
			
			var profile:Array = [
				new Vector3D(50, 200, 0),
				new Vector3D(40, 150, 0),
				new Vector3D(60, 120, 0),
				new Vector3D(40, 0, 0)
			];
			
			vase = new LatheExtrusion(
				profile,
				{
					subdivision: 12,
					centerMesh: true,
					thickness: 10,
					flip: true
				}
			);
			scene.addChild(vase);
		}
	}
}