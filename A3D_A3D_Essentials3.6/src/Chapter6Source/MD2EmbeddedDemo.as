package Chapter6Source
{
	import away3d.core.base.Mesh;
	import away3d.core.utils.Cast;
	import away3d.loaders.Md2;
	import away3d.loaders.data.AnimationData;
	import away3d.materials.BitmapMaterial;
	
	public class MD2EmbeddedDemo extends Away3DTemplate
	{
		[Embed(source = "ogre.md2", mimeType = "application/octet-stream")] 
		protected var MD2Model:Class;
		[Embed(source = "ogre.jpg")] 
		protected var MD2Texture:Class;
		protected var md2Mesh:Mesh;
		
		public function MD2EmbeddedDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();			
			var modelMaterial:BitmapMaterial = new BitmapMaterial(Cast.bitmap(MD2Texture));
			md2Mesh = Md2.parse(Cast.bytearray(MD2Model),
				{
					scale: 0.01,
					z: 100,
					rotationY: -90
				}
			);
			md2Mesh.material = modelMaterial;
			scene.addChild(md2Mesh);
			var animationData:AnimationData =  md2Mesh.animationLibrary.getAnimation("stand");
			if (animationData != null)
				animationData.animator.play();
		}	
	}
}