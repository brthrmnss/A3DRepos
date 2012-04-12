package Chapter6Source
{
	import away3d.core.base.Object3D;
	import away3d.core.utils.Cast;
	import away3d.loaders.AWData;
	import away3d.materials.BitmapMaterial;
	import away3d.core.base.Mesh;
	import away3d.containers.ObjectContainer3D;
	
	public class AWDEmbeddedDemo extends Away3DTemplate
	{
		[Embed(source = "monster.awd", mimeType = "application/octet-stream")] 
		protected var MonsterModel:Class;
		[Embed(source = "monster.jpg")] 
		protected var MonsterTexture:Class;
		
		public function AWDEmbeddedDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			var modelMaterial:BitmapMaterial = 
				new BitmapMaterial(Cast.bitmap(MonsterTexture));
			var monsterMesh:ObjectContainer3D = 
				AWData.parse(Cast.bytearray(MonsterModel),
				{
					z: 200
				}
			) as ObjectContainer3D;
			
			for each (var object:Object3D in monsterMesh.children)
			{
				var mesh:Mesh = object as Mesh;
				if (mesh != null)
					mesh.material = modelMaterial;
			}
			
			scene.addChild(monsterMesh);
		}		
	}
}