package Chapter2Source
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Mesh;
	import away3d.core.utils.Cast;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Sphere;
	import away3d.sprites.Sprite3D;
	import flash.geom.Vector3D;
	
	import flash.events.Event;

	public class CompareSprite3DTriMesh extends Away3DTemplate
	{
		[Embed(source="earthbillboard.png")]
		protected var EarthBillboardTex:Class;
		
		[Embed(source="earth.jpg")]
		protected var EarthTex:Class;
		
		protected var container:ObjectContainer3D;
		
		public function CompareSprite3DTriMesh()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			
			container = new ObjectContainer3D();
			
			var mesh:Mesh = new Mesh(
				{
					x: -200
				}
			);
			var sprite:Sprite3D = new Sprite3D(new BitmapMaterial(Cast.bitmap(EarthBillboardTex)));
			mesh.addSprite(sprite);
			this.container.addChild(mesh);
			
			var sphere:Sphere = new Sphere(
				{
					material: new BitmapMaterial(Cast.bitmap(EarthTex)),
					radius: 128,
					x: 200
				}
			);
			this.container.addChild(sphere);
			
			this.scene.addChild(container);
			
			this.camera.position = new Vector3D(0, 0, -2000);
		}
		
		protected override function onEnterFrame(event:Event):void
		{
			super.onEnterFrame(event);
			++this.container.rotationY;
		}
	}
}