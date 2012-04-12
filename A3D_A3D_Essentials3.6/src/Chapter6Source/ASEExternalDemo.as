package Chapter6Source
{
	import away3d.core.base.Mesh;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.Ase;
	import away3d.loaders.Loader3D;
	import away3d.materials.BitmapFileMaterial;
	
	public class ASEExternalDemo extends Away3DTemplate
	{
		public function ASEExternalDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();			
			var monsterMesh:Loader3D = Ase.load("./monster.ase",
				{
					z: 200
				}
			);
			monsterMesh.addOnSuccess(onLoadSuccess);
			scene.addChild(monsterMesh);
		}	
		
		protected function onLoadSuccess(event:Loader3DEvent):void
		{
			(event.loader.handle as Mesh).material = 
				new BitmapFileMaterial("monster.jpg");
		}	
	}
}