package  
{
	import away3d.extrusions.LinearExtrusion;
	import flash.events.Event;
	import flash.geom.Vector3D;

	public class LinearExtrusionDemo extends Away3DTemplate
	{
		protected var walls:LinearExtrusion;
		
		public function LinearExtrusionDemo() 
		{
			super();
		}
		
		protected override function initScene():void 
		{
			super.initScene();
			
			camera.position = new Vector3D(1000, 750, 1000);
			camera.lookAt(new Vector3D(0, 0, 0));
			
			var wallPoints:Array = 	
				[ 
					new Vector3D( -250, 0, -250), 
					new Vector3D( 0, 0, -250), 
					new Vector3D(0, 0, 0), 
					new Vector3D(250, 0, 0), 
					new Vector3D(250, 0, 250),
					new Vector3D(-250, 0, 250),
					new Vector3D( -250, 0, -250)
					
				];
				
			walls = new LinearExtrusion(
				wallPoints, 
				{ 
					thickness:10,
					offset: 150,
					recenter:true
				} 
			);
			
			scene.addChild(walls);
		}
	}
}