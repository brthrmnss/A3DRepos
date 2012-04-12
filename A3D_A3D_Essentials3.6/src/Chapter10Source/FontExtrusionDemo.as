package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.extrusions.TextExtrusion;
	import away3d.primitives.TextField3D;
	
	import flash.events.Event;
	
	import wumedia.vector.VectorText;
	
	public class FontExtrusionDemo extends Away3DTemplate
	{
		[Embed(source = "Fonts.swf", mimeType = "application/octet-stream")] 
		protected var Fonts:Class;
		protected var container:ObjectContainer3D;
		protected var text:TextField3D;
		protected var extrusion:TextExtrusion;
		
		public function FontExtrusionDemo()
		{
			super();
		}
		
		protected override function initEngine():void
		{
			super.initEngine();
			this.camera.z = 0;
			VectorText.extractFont(new Fonts());
		}
		
		protected override function initScene():void
		{
			super.initScene();
			
			text = new TextField3D("Vera Sans",
				{
					text: "Away3D Essentials",
					align: VectorText.CENTER
				}
			);			
			
			extrusion = new TextExtrusion(text, 
				{
					depth: 10,
					bothsides:true
				}
			);
			
			container = new ObjectContainer3D(text, extrusion,
				{
					z: 300
				}
			);
			scene.addChild(container);
		}
		
		protected override function onEnterFrame(event:Event):void
		{
			super.onEnterFrame(event);
			container.rotationY = 
				(container.rotationY + 1) % 360;
			
			if (container.rotationY > 90 && 
				container.rotationY < 270)
				text.screenZOffset = 10;
			else
				text.screenZOffset = -10;
		}
	}
}