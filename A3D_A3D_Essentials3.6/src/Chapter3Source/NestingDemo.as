package Chapter3Source
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Mesh;
	import away3d.core.utils.Cast;
	import away3d.materials.BitmapMaterial;
	
	import flash.events.Event;
	
	public class NestingDemo extends Away3DTemplate
	{
		[Embed(source = "texture.jpg")] 
		protected var Texture:Class;
		protected var container:ObjectContainer3D;
				
		public function NestingDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			
			var material:BitmapMaterial = 
				new BitmapMaterial(Cast.bitmap(Texture));
			
			var fighter:Mesh = new Fighter();
			fighter.material = material;
			
			var gun1:Mesh = new Gun();
			gun1.material = material;
			gun1.x = -150;
			gun1.y = 75;
			gun1.z = -115;
			
			var gun2:Mesh = new Gun();
			gun2.material = material;
			gun2.x = 150;
			gun2.y = 75;
			gun2.z = -115;
			
			container = new ObjectContainer3D(
				fighter, gun1, gun2,
				{
					z: 2000	
				}
			);
			
			scene.addChild(container);
		}
		
		protected override function onEnterFrame(event:Event):void
		{
			super.onEnterFrame(event);
			++container.rotationX;
			++container.rotationZ;
		}
	}
}