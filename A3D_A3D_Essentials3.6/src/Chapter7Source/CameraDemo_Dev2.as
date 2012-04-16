package Chapter7Source
{
	import away3d.cameras.HoverCamera3D;
	import away3d.cameras.SpringCam;
	import away3d.cameras.TargetCamera3D;
	import away3d.core.base.Face;
	import away3d.core.base.Object3D;
	import away3d.core.clip.FrustumClipping;
	import away3d.core.render.Renderer;
	import away3d.core.utils.Cast;
	import away3d.core.vos.FaceVO;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	
	import fl.controls.CheckBox;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import utils.GoThroughEach;
	import away3d.core.base.Mesh;
 
	public class CameraDemo_Dev2 extends Away3DTemplate
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
		private var  chk :  CheckBox
		private var modeActive:Boolean= false;
		private var faces:Array;
		private var go:GoThroughEach;
		private var currentFace: Face;
		private var cont:Mesh;
			
		public function CameraDemo_Dev2()
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
			sphere.alpha = 0.3
			var plane:Plane = new Plane(
				{
					material: new BitmapMaterial(Cast.bitmap(CheckerBoardTexture)),
					width: 500,
					height: 500
				}
			);
			scene.addChild(plane);
			
			addHoverCamera();
			
			chk = new    CheckBox(); 
			chk.label = 'Activate'
			chk.addEventListener(Event.CHANGE, this.onChangeActivateChkbox );
			chk.selected = this.modeActive; 
			this.stage.addChild( chk ) 
				
				
			
			//container for made up faces
			this.cont = new Mesh()
			this.cont.y = 10; 
			scene.addChild( cont  )
				
				
			this.faces = []
			for  each ( var f : Face in this.sphere.faces ) 
			{
				this.faces.push( f )
			}
			go = new GoThroughEach()
			go.go( this.faces, this.onNextFace, this.onFacesDone, 500/10 ) 
			if ( this.modeActive ) 
			{

			}
			

			
		}
		
		private function onNextFace(f : Face):void
		{
			// TODO Auto Generated method stub
			if ( this.currentFace != null ) 
				this.currentFace.material = null
			//f.material = new  ColorMaterial( 0xFF );
			//f.offset( 2,2,2 )
			this.currentFace = f; 
			
			//materialText.text = "WireframeMaterial";
			var newMaterial:WireframeMaterial = 
				new WireframeMaterial(0x1E90FF, 
					{
						width: 2
					}
				);
			f.material = newMaterial;
			//f.v0.x += Math.random()*10
				
			//f.v0.y += Math.random()*10
			//f.v0.z += Math.random()*10
			var vf : Face = new Face()
			vf = f.clone()
				vf.v0 = f.v0.clone()
				vf.v1 = f.v1.clone()
				vf.v2 = f.v2.clone()					
			vf.moveTo(0,0,-50 )
			vf.v0.z -= 50 ;
			vf.v1.z -= 50 ;
			vf.v2.z -= 50 ;
			this.faceFace( f ) ; 
			this.cont.addFace( vf ); 
			this.go.next(); 
		}
		

		
		
		private function onFacesDone():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function onChangeActivateChkbox( e : Event ) : void
		{
			this.modeActive = 	chk.selected; 
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
		
		private function faceFace(f:Face):void
		{
			// TODO Auto Generated method stub
			
		}		
		
	}
}