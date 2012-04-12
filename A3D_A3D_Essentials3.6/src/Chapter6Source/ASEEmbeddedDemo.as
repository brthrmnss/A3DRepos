package Chapter6Source
{
	import away3d.core.base.Mesh;
	import away3d.core.utils.Cast;
	import away3d.loaders.Ase;
	import away3d.materials.BitmapMaterial;
	
	public class ASEEmbeddedDemo extends Away3DTemplate
	{
		[Embed(source = "monster.ase", mimeType = "application/octet-stream")] 
		protected var MonsterModel:Class;
		[Embed(source = "monster.jpg")] 
		protected var MonsterTexture:Class;
		
		public function ASEEmbeddedDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();			
			var modelMaterial:BitmapMaterial = 
				new BitmapMaterial(Cast.bitmap(MonsterTexture));
			var monsterMesh:Mesh = 
				Ase.parse(Cast.bytearray(MonsterModel),
				{					
					z: 50
				}
			);
			monsterMesh.material = modelMaterial;
			scene.addChild(monsterMesh);
		}		
	}
}