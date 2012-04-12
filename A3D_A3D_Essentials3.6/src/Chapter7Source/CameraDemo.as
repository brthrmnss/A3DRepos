package Chapter7Source
{
	import away3d.cameras.HoverCamera3D;
	import away3d.cameras.SpringCam;
	import away3d.cameras.TargetCamera3D;
	import away3d.core.clip.FrustumClipping;
	import away3d.core.render.Renderer;
	import away3d.core.utils.Cast;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class CameraDemo extends Away3DTemplate
	{
		[Embed(source="checkerboard.jpg")]
        protected var CheckerBoardTexture:Class;
		protected var sphere:Sphere;		
		protected var hoverCamera:HoverCamera3D;
		protected var springCamera:SpringCam;
		protected var targetCamera:TargetCamera3D;
		protected var lastStageX:Number;
		protected var lastStageY:Number;
		protected var mouseButtonDown:Boolean;
		protected var moveForward:Boolean;
		protected var moveBackward:Boolean;
		protected var turnLeft:Boolean;
		protected var turnRight:Boolean;
			
		public function CameraDemo()
		{
			super();
		}
		
		protected override function initEngine():void
		{
			super.initEngine();
			view.renderer = Renderer.CORRECT_Z_ORDER; 
			view.clipping = new FrustumClipping();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			sphere = new Sphere(
				{
					radius: 10,
					y: 10
				}
			);			
			scene.addChild(sphere);
			
			var plane:Plane = new Plane(
				{
					material: new BitmapMaterial(Cast.bitmap(CheckerBoardTexture)),
					width: 500,
					height: 500
				}
			);
			scene.addChild(plane);
			
			addHoverCamera();
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		protected override function onEnterFrame(event:Event):void
		{
			super.onEnterFrame(event);
			
			if (hoverCamera != null) hoverCamera.hover();
			if (springCamera != null) springCamera.view;
				
			if (moveForward) sphere.moveForward(5);
			else if (moveBackward) sphere.moveBackward(5);
			if (turnLeft) sphere.yaw(-5);
			else if (turnRight) sphere.yaw(5);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			mouseButtonDown = true;
			lastStageX = event.stageX;
			lastStageY = event.stageY;
		}	
		
		protected function onMouseUp(event:MouseEvent):void
		{
			mouseButtonDown = false;
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case 38: // UP ARROW
					moveForward = true;
					break;
				case 40: // DOWN ARROW
					moveBackward = true;
					break;
				case 37: // LEFT ARROW
					turnLeft = true;
					break;
				case 39: // RIGHT ARROW
					turnRight = true;
					break;
			}
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case 38: // UP ARROW
					moveForward = false;
					break;
				case 40: // DOWN ARROW
					moveBackward = false;
					break;
				case 37: // LEFT ARROW
					turnLeft = false;
					break;
				case 39: // RIGHT ARROW
					turnRight = false;
					break;
				case 49: // 1
					addHoverCamera();
					break;
				case 50: // 2
					addSpringCamera();
					break;
				case 51: // 3
					addTargetCamera();
					break;
			}
		}
		
		protected function addTargetCamera():void
		{
			hoverCamera = null;
			springCamera = null;
			
			targetCamera = new TargetCamera3D(
				{
					target: sphere,
					y: 100
				}
			);
			
			view.camera = targetCamera;
		}
		
		protected function addHoverCamera():void
		{
			springCamera = null;
			targetCamera = null;
			
			hoverCamera = new HoverCamera3D(
				{
					target: sphere,
					distance: 100,
					mintiltangle: 5,
                    tiltAngle: 45
				}
			);
			
			view.camera = hoverCamera;
		}

		protected function onMouseMove(event:MouseEvent):void
		{
			if (mouseButtonDown && hoverCamera != null)
			{
				var pan:int = (event.stageX - lastStageX);
				var tilt:int = (event.stageY - lastStageY);

				hoverCamera.panAngle += pan;
				hoverCamera.tiltAngle += tilt;

				lastStageX = event.stageX;
				lastStageY = event.stageY;
			}
		}        
		
		protected function addSpringCamera():void
		{
			hoverCamera = null;
			targetCamera = null;
			
			springCamera = new SpringCam();
			springCamera.target = sphere;
			view.camera = springCamera;
			
		}
	}
}