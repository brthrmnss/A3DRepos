package Chapter3Source
{
	import flash.geom.Vector3D;
	import away3d.primitives.Sphere;
	
	import com.greensock.TweenLite;
	
	public class TweeningExample extends Away3DTemplate
	{
		protected var sphere:Sphere;
		
		public function TweeningExample()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			
			camera.position = new Vector3D(0, 2000, -2000);
			camera.lookAt(new Vector3D(0, 0, 0));
			
			sphere = new Sphere();
			scene.addChild(sphere);	
			
			tweenToRandomPosition();		
		}
		
		protected function tweenToRandomPosition():void
		{
			TweenLite.to(sphere, 1, 
				{
					x: Math.random() * 1000 - 500, 
					z: Math.random() * 1000 - 500,
					scaleX: Math.random() * 1.5 + 0.5,
					scaleY: Math.random() * 1.5 + 0.5,
					scaleZ: Math.random() * 1.5 + 0.5,
					rotationY: Math.random() * 180,
					onComplete: tweenToRandomPosition		
				}
			);
		}
	}
}