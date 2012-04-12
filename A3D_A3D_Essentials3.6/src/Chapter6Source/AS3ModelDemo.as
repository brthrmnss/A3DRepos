package Chapter6Source
{
	import away3d.core.base.Mesh;
	import away3d.core.utils.Cast;
	import away3d.materials.BitmapMaterial;
	
	public class AS3ModelDemo extends Away3DTemplate
	{
		[Embed(source = "ogre.jpg")] 
		protected var AS3Material:Class;
		protected var model:Mesh;
		
		public function AS3ModelDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();			
			var modelMaterial:BitmapMaterial = 
				new BitmapMaterial(Cast.bitmap(AS3Material));
			model = new Ogre(
				{					
					scaling: 0.01
				}
			);
			model.material = modelMaterial;
			model.z = 100;
			scene.addChild(model);
		}		
	}
}