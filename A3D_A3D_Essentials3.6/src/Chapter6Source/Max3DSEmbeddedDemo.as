package Chapter6Source
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Mesh;
	import away3d.core.utils.Cast;
	import away3d.loaders.Max3DS;
	import away3d.materials.BitmapMaterial;
	
	public class Max3DSEmbeddedDemo extends Away3DTemplate
	{
		[Embed(source = "monster.3ds", mimeType = "application/octet-stream")] 
		protected var MonsterModel:Class;
		[Embed(source = "monster.jpg")] 
		protected var MonsterTexture:Class;
		
		public function Max3DSEmbeddedDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();			
			var modelMaterial:BitmapMaterial = 
				new BitmapMaterial(Cast.bitmap(MonsterTexture));
			var monsterMesh:ObjectContainer3D = 
				Max3DS.parse(Cast.bytearray(MonsterModel),
				{
					autoLoadTextures: false,
					z: 200
				}
			);
			for each (var child:Mesh in monsterMesh.children)
				child.material = modelMaterial;
			scene.addChild(monsterMesh);
		}		
	}
}