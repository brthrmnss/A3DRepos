package Chapter6Source
{
	import away3d.loaders.AWData;
	import away3d.loaders.Loader3D;
	
	public class AWDExternalDemo extends Away3DTemplate
	{
		public function AWDExternalDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();			
			var monsterMesh:Loader3D = AWData.load("./monster.awd",
				{
					z: 200
				}
			);
			scene.addChild(monsterMesh);
		}		
	}
}