package Chapter8Source
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.core.base.Mesh;
	import away3d.core.base.Object3D;
	import away3d.core.base.Segment;
	import away3d.core.base.Vertex;
	import away3d.core.geom.Plane3D;
	import away3d.core.render.BasicRenderer;
	import away3d.core.utils.Cast;
	import away3d.events.MouseEvent3D;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Vector3D;
	
	public class VisualizePlaneOps extends Away3DTemplate
	{
		[Embed(source = "checkerboard.jpg")] 
		protected var CheckerBoardTexture:Class;
		protected var selectedObject:Object3D;
		protected var sphere1:Sphere;
		protected var sphere2:Sphere;
		protected var groundPlane:Plane3D;
		protected var throughScreenVector:Vector3D;
		protected var groundPosition:Vector3D;
		
		public function VisualizePlaneOps()
		{
			super();
		}
		
		protected override function initEngine():void
		{
			super.initEngine();
			camera.lens = new PerspectiveLens();
			view.forceUpdate = true;
		}
		
		protected override function initScene():void
		{
			super.initScene();
			
			camera.position = new Vector3D(0, 100, 0);
			camera.tilt(20);
			
			var planeMaterial:BitmapMaterial = 
				new BitmapMaterial(
					Cast.bitmap(CheckerBoardTexture)
				);
			var plane:Plane = new Plane(
				{
					/*material: planeMaterial,*/
					segments: 10,
					width: 1000,
					height: 1000,
					y: -15,
					z: 250
				}
			);
			plane.screenZOffset = 1000;
			scene.addChild(plane);
			
			sphere1 = new Sphere(
				{
					x: -50,
					z: 250,
					radius: 10,
					ownCanvas: true
				}
			);
			sphere1.ownCanvas = true
			scene.addChild(sphere1);
			
			sphere2 = new Sphere(
				{
					x: 50,
					z: 250,
					radius: 10,
					ownCanvas: true
				}
			);
			scene.addChild(sphere2);
			
			groundPlane = new Plane3D();
			groundPlane.fromNormalAndPoint(
				new Vector3D(0, 1, 0), 
				new Vector3D()
			);
			
			var mesh : Mesh = new Mesh()
			var newMaterial:WireframeMaterial = 
				new WireframeMaterial(0x1E90FF, 
					{
						width:10
					}
				);
			mesh.material = newMaterial; 
			//	newMaterial = null
			
			var line : Segment = new Segment( this.toVertec(sphere1.position), 
				this.toVertec(sphere2.position),
				newMaterial)
			mesh.addSegment( line ) ; 
			line.v0.y = 50
			line.v1.y = 50
			line.vertexDirty = true; 
			this.scene.addChild( mesh ) 
		}
		
		private function toVertec(position:Vector3D):away3d.core.base.Vertex
		{
			return new Vertex(position.x, position.y, position.z ) ; 
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
			
			stage.addEventListener(
				MouseEvent.MOUSE_UP, 
				onMouseUp
			);
			
			sphere1.addEventListener(
				MouseEvent3D.MOUSE_OVER, 
				onMouseOver
			);
			sphere1.addEventListener(
				MouseEvent3D.MOUSE_OUT, 
				onMouseOut
			);
			sphere1.addEventListener(
				MouseEvent3D.MOUSE_DOWN, 
				onMouseDown
			);
			
			sphere2.addEventListener(
				MouseEvent3D.MOUSE_OVER, 
				onMouseOver
			);
			sphere2.addEventListener(
				MouseEvent3D.MOUSE_OUT, 
				onMouseOut
			);
			sphere2.addEventListener(
				MouseEvent3D.MOUSE_DOWN, 
				onMouseDown
			);
		}
		
		protected function onMouseOver(event:MouseEvent3D):void
		{
			event.object.filters = [new GlowFilter()];
		}
		
		protected function onMouseOut(event:MouseEvent3D):void
		{
			event.object.filters = [];
		}
		
		protected function onMouseDown(event:MouseEvent3D):void
		{
			selectedObject = event.object;
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			selectedObject = null;
		}		
		
		protected override function onEnterFrame(event:Event):void
		{
			super.onEnterFrame(event);
			
			if (selectedObject != null)
			{
				throughScreenVector = camera.unproject(
					stage.mouseX - stage.stageWidth / 2, 
					stage.mouseY - stage.stageHeight / 2
				);
				throughScreenVector = 
					throughScreenVector.add(camera.position);
				//so imagine screen point and camera point, now we have a line
				//q: what other plane like objects are there?
				groundPosition = 
					groundPlane.getIntersectionLineNumbers(
						camera.position, 
						throughScreenVector
					);
				selectedObject.position = groundPosition;
			}
		}
	}
}