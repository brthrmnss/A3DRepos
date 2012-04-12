package Chapter6Source
{
	import away3d.core.utils.Cast;
	import away3d.loaders.Loader3D;
	import away3d.loaders.Max3DS;
	
	public class Max3DSExternalDemo extends Away3DTemplate
	{
		public function Max3DSExternalDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();			
			var monsterMesh:Loader3D = Max3DS.load("./monster.3ds",
				{
					z: 200
				}
			);
			scene.addChild(monsterMesh);
		}		
	}
}