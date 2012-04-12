package Chapter6Source
{
	import away3d.core.base.Mesh;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.Md2;
	import away3d.loaders.data.AnimationData;
	import away3d.materials.BitmapFileMaterial;
	
	public class MD2ExternalDemo extends Away3DTemplate
	{
		protected var mesh:Mesh;
		
		public function MD2ExternalDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			var placeHolder:Loader3D = Md2.load("./ogre.md2",
				{					
					scale: 0.01,
					z: 100,
					rotationY: -90
				}
			);
			placeHolder.addEventListener(Loader3DEvent.LOAD_SUCCESS, onLoadSuccess);
			scene.addChild(placeHolder);			
		}	
		
		protected function onLoadSuccess(event:Loader3DEvent):void
		{
			mesh = event.loader.handle as Mesh;
			mesh.material = new BitmapFileMaterial("ogre.jpg");
			var animationData:AnimationData = mesh.animationLibrary.getAnimation("stand");
			if (animationData != null)
				animationData.animator.play();
		}	
	}
}