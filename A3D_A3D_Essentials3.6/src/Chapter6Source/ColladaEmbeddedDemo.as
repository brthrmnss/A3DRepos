package Chapter6Source
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.utils.Cast;
	import away3d.loaders.Collada;
	import away3d.loaders.data.AnimationData;
	import away3d.materials.BitmapMaterial;
	
	import flash.events.Event;
	
	public class ColladaEmbeddedDemo extends Away3DTemplate
	{
		[Embed(source = "beast.dae", mimeType = "application/octet-stream")] 
		protected var ColladaModel:Class;
		[Embed(source = "beast.jpg")] 
		protected var ColladaMaterial:Class;
		
		public function ColladaEmbeddedDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();			
			var modelMaterial:BitmapMaterial = new BitmapMaterial(Cast.bitmap(ColladaMaterial));
			var colladaContainer:ObjectContainer3D = Collada.parse(Cast.bytearray(ColladaModel),
				{
					materials:
						{
							monster: modelMaterial
						},
					rotationY: 90	
				}
			);
			colladaContainer.scaleX = 
				colladaContainer.scaleY = 
				colladaContainer.scaleZ = 20; 
			scene.addChild(colladaContainer);
			
			var animationData:AnimationData = 
				colladaContainer.animationLibrary.getAnimation("default");
			if (animationData != null)
				animationData.animator.play();
		}		
	}
}