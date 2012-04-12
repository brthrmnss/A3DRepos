package
{
	import away3d.core.geom.Path;
	import away3d.core.geom.PathCommand;
	import away3d.materials.ColorMaterial;
	import away3d.modifiers.PathAlignModifier;
	import away3d.primitives.TextField3D;
	import flash.geom.Vector3D;
	import flash.events.KeyboardEvent;
	
	import wumedia.vector.VectorText;
	
	public class TextWarpingDemo extends Away3DTemplate
	{
		[Embed(source = "Fonts.swf", mimeType = "application/octet-stream")] 
		protected var Fonts:Class;
		protected var text:TextField3D;
		
		public function TextWarpingDemo()
		{
			super();
		}
		
		protected override function initEngine():void
		{
			super.initEngine();
			VectorText.extractFont(new Fonts());
		}
		
		protected override function initScene():void
		{
			super.initScene();
			this.camera.z = 0;
			followLine();
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
			stage.addEventListener(
				KeyboardEvent.KEY_UP, 
				onKeyUp
			);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case 49:  // 1
					followContinuousCurve();
					break;
				case 50: // 2
					followLine();
					break;
				case 51: // 3
					followCurve();
					break;
			}
		}
		
		protected function setupText():void
		{
			if (text != null) 
			{
				scene.removeChild(text);	
			}
			
			text = new TextField3D("Vera Sans",
				{
					text: "Away3D    Essentials",
					size: 15,
					material: new ColorMaterial(0)
				}
			);			
			scene.addChild(text);
		}
		
		protected function followContinuousCurve():void
		{
			setupText();
			
			var path:Path = new Path();
			
			path.continuousCurve(
				[
					new Vector3D(-100, -50, 300), 
					new Vector3D(-25, 50, 300), 
					new Vector3D(25, -50, 300), 
					new Vector3D(100, 0, 300)
				]
			);
			
			var aligner:PathAlignModifier = 
				new PathAlignModifier(text, path);
			aligner.execute();
		}
		
		protected function followLine():void
		{
			setupText();
			
			var path:Path = new Path();
			
			path.array.push(
				new PathCommand(
					PathCommand.LINE, 
					new Vector3D( -75, -35, 300), 
					null, 
					new Vector3D( -75, 35, 300)
				)
			);
			path.array.push(
				new PathCommand(
					PathCommand.LINE, 
					new Vector3D( -75, 35, 300), 
					null, 
					new Vector3D(75, 35, 300)
				)
			);

			var aligner:PathAlignModifier = 
				new PathAlignModifier(text, path);
			aligner.execute();
		}
		
		protected function followCurve():void
		{
			setupText();
			
			var path:Path = new Path();
			
			path.array.push(
				new PathCommand(
					PathCommand.CURVE, 
					new Vector3D( -75, -45, 300), 
					new Vector3D(0, 50, 300), 
					new Vector3D(75, 0, 300)
				)
			);
			
			var aligner:PathAlignModifier = 
				new PathAlignModifier(text, path);
			aligner.execute();			
		}
	}
}