package Chapter8Source
{
	import away3d.containers.ObjectContainer3D;
	import away3d.events.MouseEvent3D;
	import away3d.materials.WireColorMaterial;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.Sphere;
	
	public class MouseRollMoveEventDemo extends Away3DTemplate
	{
		public function MouseRollMoveEventDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			var sphere1:Sphere = new Sphere (
				{
					x: 50,
					y: 0,
					z: 500
				}
			);
			
			var sphere2:Sphere = new Sphere (
				{
					x: -50,
					y: 0,
					z: 500			
				}
			);

			var container:ObjectContainer3D = 
				new ObjectContainer3D(sphere1, sphere2);
			scene.addChild(container);
			
			container.addEventListener(
				MouseEvent3D.MOUSE_OVER, 
				function(event:MouseEvent3D):void
				{
					trace("Container Mouse Over");
				}
			);
			container.addEventListener(
				MouseEvent3D.MOUSE_OUT, 
				function(event:MouseEvent3D):void
				{
					trace("Container Mouse Out");
				}
			);			
			container.addEventListener(
				MouseEvent3D.ROLL_OVER, 
				function(event:MouseEvent3D):void
				{
					trace("Container Roll Over");
				}
			);
			container.addEventListener(
				MouseEvent3D.ROLL_OUT, 
				function(event:MouseEvent3D):void
				{
					trace("Container Roll Out");
				}
			);
		}
	}
}