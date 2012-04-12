package Chapter6Source
{
	import away3d.core.base.Face;
	import away3d.core.base.Mesh;
	import away3d.core.utils.Cast;
	import away3d.loaders.Obj;
	import away3d.materials.BitmapMaterial;
	
	public class OBJEmbeddedDemo extends Away3DTemplate
	{
		[Embed(source = "monster.obj", mimeType = "application/octet-stream")] 
		protected var MonsterModel:Class;
		[Embed(source = "monster.jpg")] 
		protected var MonsterTexture:Class;
		
		public function OBJEmbeddedDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();			
			var modelMaterial:BitmapMaterial = 
				new BitmapMaterial(Cast.bitmap(MonsterTexture));
			var monsterMesh:Mesh = 
				Obj.parse(Cast.bytearray(MonsterModel),
				{
					z: 200,
					useMtl: false
				}
			) as Mesh;
			for each (var face:Face in monsterMesh.faces)
				face.material = modelMaterial; 
			scene.addChild(monsterMesh);
		}		
	}
}