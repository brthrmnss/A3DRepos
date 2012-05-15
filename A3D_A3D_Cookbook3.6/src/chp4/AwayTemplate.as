package chp3
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	
	import flash.display.Sprite; 
	import flash.events.Event;
	
	/**
	 * This is basic template for away3d scene setup
	 * 
	 * */
	//[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class AwayTemplate extends Sprite
	{
		
		protected var _view:View3D;
		protected var _cam:Camera3D;
		public function AwayTemplate()
		{
			//initAway();
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.onInitAway ) ; 
		}
		private function onInitAway(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onInitAway ) ; 
			///	var brenderer:BasicRenderer=new BasicRenderer(new ZDepthFilter(1000));
			_view=new View3D({x:400,y:300});
			//_view.width=800;
			//_view.height=600;
			_cam=new Camera3D();
			_cam.lens=new PerspectiveLens();
			_view.camera=_cam;
			
			
			addChild(_view);
			var aws:AwayStats=new AwayStats(_view);
			this.addChild(aws);
			
			 
			
			initMaterials();
			initGeometry();
			this.setup() ; 
			initListeners();
		}
		protected function initListeners():void{
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		protected function setup():void{
		}
		
		protected function initMaterials():void{
			
		}
		protected function initGeometry():void{
			
		}
		protected function onEnterFrame(e:Event):void{
			_view.render();
		}
	}
}