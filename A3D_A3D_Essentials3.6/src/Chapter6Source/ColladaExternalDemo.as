package Chapter6Source
{
	import away3d.animators.Animator;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.Collada;
	import away3d.loaders.Loader3D;
	import away3d.loaders.data.AnimationData;
	
	import flash.events.Event;
	
	public class ColladaExternalDemo extends Away3DTemplate
	{
		public function ColladaExternalDemo()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();			
			var placeHolder:Loader3D = Collada.load("./beast.dae", 
				{
					rotationY: 90
				}
			);
			placeHolder.addOnSuccess(onLoadSuccess);
			scene.addChild(placeHolder);
		}
		
		protected function onLoadSuccess(event:Loader3DEvent):void
		{
			event.loader.handle.scaleX = 
				event.loader.handle.scaleY = 
				event.loader.handle.scaleZ = 20;
			var animationData:AnimationData = 
				event.loader.handle.animationLibrary.getAnimation("default");
			if (animationData != null)
				animationData.animator.play();
		}
	}
}