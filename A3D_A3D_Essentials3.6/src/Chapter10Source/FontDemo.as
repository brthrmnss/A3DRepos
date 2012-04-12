package
{
	import away3d.primitives.TextField3D;
	import wumedia.vector.VectorText;
	
	public class FontDemo extends Away3DTemplate
	{
		[Embed(source = "Fonts.swf", mimeType = "application/octet-stream")] 
		protected var Fonts:Class;
		
		public function FontDemo()
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
			var text:TextField3D = new TextField3D("Vera Sans",
				{
					text: "Away3D Essentials",
					align: VectorText.CENTER,
					z: 300
				}
			);			
			scene.addChild(text);
		}
	}
} 
