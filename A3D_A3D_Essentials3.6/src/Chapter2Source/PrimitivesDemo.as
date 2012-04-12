package  Chapter2Source
{
	import away3d.core.base.Object3D;
	import away3d.primitives.Cone;
	import away3d.primitives.Cube;
	import away3d.primitives.Cylinder;
	import away3d.primitives.GeodesicSphere;
	import away3d.primitives.GridPlane;
	import away3d.primitives.LineSegment;
	import away3d.primitives.Plane;
	import away3d.primitives.RegularPolygon;
	import away3d.primitives.RoundedCube;
	import away3d.primitives.SeaTurtle;
	import away3d.primitives.Skybox;
	import away3d.primitives.Skybox6;
	import away3d.primitives.Sphere;
	import away3d.primitives.Torus;
	import away3d.primitives.Triangle;
	import away3d.primitives.Trident;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import away3d.materials.BitmapFileMaterial;
	
	public class PrimitivesDemo extends Away3DTemplate
	{
		protected var currentPrimitive:Object3D;
		
		public function PrimitivesDemo():void
		{
			super();
		}
		
		protected override function initEngine():void
		{
			super.initEngine();
			camera.z = -500;
		}
				
		protected override function initScene():void
		{
			super.initScene();
			initSphere();
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		protected override function onEnterFrame(event:Event):void
		{
			super.onEnterFrame(event);
			currentPrimitive.rotationX += 1;
			currentPrimitive.rotationY += 1;
			currentPrimitive.rotationZ += 1;			
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			removeCurrentPrimitive();
			
			switch (event.keyCode)
			{
				case 49:  // 1
					initCone();
					break;
				case 50: // 2
					initCube();
					break;
				case 51: // 3
					initCylinder();
					break;		
				case 52: // 4
					initGeodesicSphere();
					break;		
				case 53: // 5
					initGridPlane();
					break;	
				case 54: // 6
					initLineSegment();
					break;	
				case 55: // 7
					initPlane();
					break;	
				case 56: // 8
					initRegularPolygon();
					break;	
				case 57: // 9
					initRoundedCube();
					break;		
				case 48: // 0
					initTorus();
					break;	
				case 81: // Q
					initTriangle();
					break;	
				case 87: // W
					initSeaTurtle();
					break;	
				case 69: // E
					initSphere();
					break;
				case 82: // R
					initTrident();
					break;		
				case 84: // T
					initSkybox();
					break;
				case 89: // Y
					initSkybox6();
					break;
				default:
					initSphere();
					break;
			}
		}
		
		protected function removeCurrentPrimitive():void
		{
			scene.removeChild(currentPrimitive);
			currentPrimitive = null;
		}
		
		protected function initCone():void
		{
			currentPrimitive = new Cone(
				{
					height: 150
				}
			);
			scene.addChild(currentPrimitive);
		}
		
		protected function initCube():void
		{
			currentPrimitive = new Cube();
			scene.addChild(currentPrimitive);
		}
		
		protected function initCylinder():void
		{
			currentPrimitive = new Cylinder(
				{
					height: 150
				}
			);
			scene.addChild(currentPrimitive);
		}
		
		protected function initGeodesicSphere():void
		{
			currentPrimitive = new GeodesicSphere();
			scene.addChild(currentPrimitive);
		}	
		
		protected function initGridPlane():void
		{
			currentPrimitive = new GridPlane(
				{
					segments: 4
				}
			);
			scene.addChild(currentPrimitive);
		}	
		
		protected function initLineSegment():void
		{
			currentPrimitive = new LineSegment(
				{
					edge: 500
				}
			);
			scene.addChild(currentPrimitive);
		}	
		
		protected function initPlane():void
		{
			currentPrimitive = new Plane(
				{
					bothsides: true
				}
			);
			scene.addChild(currentPrimitive);
		}	
		
		protected function initRegularPolygon():void
		{
			currentPrimitive = new RegularPolygon(
				{
					bothsides: true
				}
			);
			scene.addChild(currentPrimitive);
		}
		
		protected function initRoundedCube():void
		{
			currentPrimitive = new RoundedCube();
			scene.addChild(currentPrimitive);
		}			
		
		protected function initSeaTurtle():void
		{
			currentPrimitive = new SeaTurtle(
				{
					scale: 0.3
				}
			);
			scene.addChild(currentPrimitive);
		}
		
		protected function initSkybox():void
		{
			currentPrimitive = new Skybox(
				new BitmapFileMaterial("Chapter2Source/two.jpg"),
				new BitmapFileMaterial("Chapter2Source/one.jpg"),
				new BitmapFileMaterial("Chapter2Source/four.jpg"),
				new BitmapFileMaterial("Chapter2Source/three.jpg"),
				new BitmapFileMaterial("Chapter2Source/five.jpg"),
				new BitmapFileMaterial("Chapter2Source/six.jpg")
			);
			scene.addChild(currentPrimitive);
		}	
		
		protected function initSkybox6():void
		{
			currentPrimitive = new Skybox6(
				new BitmapFileMaterial("Chapter2Source/map6.jpg")
			);
			scene.addChild(currentPrimitive);
		}	
		
		protected function initSphere():void
		{
			currentPrimitive = new Sphere();
			scene.addChild(currentPrimitive);
		}
		
		protected function initTorus():void
		{
			currentPrimitive = new Torus(
				{
					radius: 75,
					tube: 30		
				}
			);
			scene.addChild(currentPrimitive);
		}
		
		protected function initTriangle():void
		{
			currentPrimitive = new Triangle(
				{
					bothsides: true		
				}
			);
			scene.addChild(currentPrimitive);
		}		
		
		protected function initTrident():void
		{
			currentPrimitive = new Trident(100);
			scene.addChild(currentPrimitive);
		}			
	}
}
