package Chapter6Source
{
	import away3d.loaders.Loader3D;
	import away3d.loaders.Obj;
	
	public class OBJExternalDemo extends Away3DTemplate
	{
		public function OBJExternalDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();			
			var monsterMesh:Loader3D = Obj.load("./monster.obj",
				{
					z: 200
				}
			);
			scene.addChild(monsterMesh);
		}		
	}
}