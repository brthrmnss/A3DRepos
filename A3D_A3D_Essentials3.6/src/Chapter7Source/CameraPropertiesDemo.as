package Chapter7Source
{
    import away3d.cameras.lenses.OrthogonalLens;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.cameras.lenses.SphericalLens;
	import away3d.cameras.lenses.ZoomFocusLens;
	import away3d.core.utils.Cast;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.WireColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
    import flash.geom.Vector3D;
    import flash.text.TextField;
	
	[SWF(backgroundColor=0xFFFFFF)]
	public class CameraPropertiesDemo extends Away3DTemplate
	{
		[Embed(source="checkerboard.jpg")] protected var CheckerboardTexture:Class;
		protected var increaseFocus:Boolean;
		protected var decreaseFocus:Boolean;
		protected var increaseZoom:Boolean;
		protected var decreaseZoom:Boolean;
		protected var increaseFOV:Boolean;
		protected var decreaseFOV:Boolean;
		protected var cameraSettingsInfo:TextField;
				
		public function CameraPropertiesDemo()
		{
			super();
		}
		
		protected override function initUI():void
		{
			super.initUI();
			
			var background:Shape = new Shape();
			background.graphics.beginFill(0xFF8844, 0.8);
			background.graphics.lineStyle(1, 0x000000);
			background.graphics.drawRoundRect(10, 10, 150, 225, 5);
			background.graphics.endFill();
			addChild(background);
			
			cameraSettingsInfo = new TextField();
			cameraSettingsInfo.x = 10;
			cameraSettingsInfo.y = 10;
			cameraSettingsInfo.width = 150;
			addChild(cameraSettingsInfo);	
			
			var instructions:TextField = new TextField();
			instructions.x = 10;
			instructions.y = 60;
			instructions.width = 150;
			instructions.height = 175;
			instructions.text = 
				"1: Increase Focus" + "\n" + 
				"2: Decrease Focus" + "\n" +
				"3: Increase Zoom" + "\n" +
				"4: Decrease Zoom" + "\n" +
				"5: Increase FOV" + "\n" +
				"6: Decrease FOV" + "\n" +
				"7: Spherical Lens" + "\n" +
				"8: Perspective Lens" + "\n" +
				"9: Orthogonal Lens" + "\n" +
				"0: ZoomFocus Lens" + "\n";
			addChild(instructions);	
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case 49: // 1
					increaseFocus = false;
					break;
				case 50: // 2
					decreaseFocus = false;
					break;
				case 51: // 3
					increaseZoom = false;
					break;
				case 52: // 4
					decreaseZoom = false;
					break;
				case 53: // 5
					increaseFOV = false;
					break;
				case 54: // 6
					decreaseFOV = false;
					break;
				case 55: // 7
					applySphericalLens();
					break;
				case 56: // 8
					applyPerspectiveLens();
					break;
				case 57: //9
					applyOrthogonalLens();
					break;
				case 48: //0
					applyZoomFocusLens();
					break;				
			}
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case 49: // 1
					increaseFocus = true;
					break;
				case 50: // 2
					decreaseFocus = true;
					break;
				case 51: // 3
					increaseZoom = true;
					break;
				case 52: // 4
					decreaseZoom = true;
					break;
				case 53: // 5
					increaseFOV = true;
					break;
				case 54: // 6
					decreaseFOV = true;
					break;
			}
		}
		
		protected override function initScene():void
		{
			super.initScene();
			
			setChildIndex(view, 0);
			
			camera.x = 1000;
			camera.y = 1000;
			camera.z = 1000;
			camera.lookAt(new Vector3D(0, 0, 0));
			
			var plane:Plane = new Plane(
				{
					material: new BitmapMaterial(Cast.bitmap(CheckerboardTexture)),
					width: 5000,
					height: 5000,
					segments: 10
				}
			);
			plane.ownCanvas = true;
			plane.screenZOffset = 10000;
			scene.addChild(plane);
			
			for (var cubeX:int = -2500; cubeX <= 2500; cubeX += 500)
			{
				for (var cubeZ:int = -2500; cubeZ <= 2500; cubeZ += 500)
				{
					scene.addChild(
						new Cube(
							{
								x: cubeX,
								y: 50,
								z: cubeZ,
								width: 200,
								height: 200,
								depth: 200,
								material: new WireColorMaterial("steelblue")	
							}
						)
					);
				}
			}

		}
		
		protected override function onEnterFrame(event:Event):void
		{
			super.onEnterFrame(event);
			
			if (increaseFocus) camera.focus += 5;
			else if (decreaseFocus) camera.focus -= 5;
			if (increaseFOV) camera.fov += 1;
			else if (decreaseFOV) camera.fov -= 1;
			if (increaseZoom) camera.zoom += 0.5;
			else if (decreaseZoom) camera.zoom -= 0.5;
			
			cameraSettingsInfo.text = 
				"Zoom: " + camera.zoom + "\n" +
				"Focus: " + camera.focus + "\n" +
				"FOV: " + camera.fov;
		}
		
		protected function applySphericalLens():void
		{
			camera.lens = new SphericalLens();
		}
		
		protected function applyPerspectiveLens():void
		{
			camera.lens = new PerspectiveLens();
		}
		
		protected function applyOrthogonalLens():void
		{
			camera.lens = new OrthogonalLens();
		}	
		
		protected function applyZoomFocusLens():void
		{
			camera.lens = new ZoomFocusLens();
		}			
	}
}