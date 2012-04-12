package 
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Away3DTemplate extends Sprite
	{
		protected var scene:Scene3D;
		protected var camera:Camera3D;
		protected var view:View3D;
		
		public function Away3DTemplate():void
		{
			initUI();
			initEngine();
			initScene();
			initListeners();
		}
		
		protected function initEngine():void
		{
			view = new View3D();
			scene = view.scene;
			camera = view.camera;
			
			addChild(view);
			
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
		}
		
		protected function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			view.render();
		}
		
		protected function initScene():void {}
		protected function initUI():void {}
	}
}
