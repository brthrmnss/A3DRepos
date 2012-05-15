package chp3
{
	import away3d.animators.FaceLink;
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Mesh;
	import away3d.core.utils.Cast;
	import away3d.loaders.Max3DS;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Sphere;
	
	import com.bit101.components.Knob;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	[SWF(backgroundColor="#000000", frameRate="30", quality="HIGH", width="800", height="600")]
	public class FaceLinkDemo extends AwayTemplate
	{
		[Embed(source="../assets/spyDifferentFormatsExport/spyObjReady.3ds",mimeType="application/octet-stream")]
		private var SpyModel3ds:Class;
		[Embed(source="../assets/spyDifferentFormatsExport/spyObjReady.jpg")]
		private var SpyTexture:Class;
		[Embed(source="../assets/spyDifferentFormatsExport/spyRadio.3ds",mimeType="application/octet-stream")]
		private var SpyRadio:Class;
		[Embed(source="../assets/spyDifferentFormatsExport/sapper_flat.jpg")]
		private var RadioTexture:Class;
		private var _knobUI:Knob;
		private var _model3ds:ObjectContainer3D;
		private var _radio:ObjectContainer3D;
		private var _bitMat:BitmapMaterial;
		private var _hoverCam:HoverCamera3D;
		private var _move:Boolean = false;
		private var _lastPanAngle:Number;
		private var _lastTiltAngle:Number;
		private var _lastMouseX:Number;
		private var _lastMouseY:Number;
		private var _faceLink:FaceLink;
		private var _demoSph:Sphere;
		private var _extractedMesh:Mesh;
		private var _radioMaterial:BitmapMaterial;
		public function FaceLinkDemo()
		{
			super();
			initHoverCam();
			initUI();
			initFaceLink();
		}
		private function initHoverCam():void
		{
			_hoverCam = new HoverCamera3D();
			_hoverCam.zoom=22;
			_hoverCam.panAngle = 45;
			_hoverCam.tiltAngle = 20;
			_view.camera = _hoverCam;
			_hoverCam.target=_extractedMesh;
		}
		private function initUI():void{
			_knobUI=new Knob(_view,-250,-250,"animate position",onKnobMove);
			_knobUI.mouseRange=400;
			_knobUI.labelPrecision=0;
			_knobUI.minimum=0;
			_knobUI.maximum=_extractedMesh.faces.length;
		}
		private function initFaceLink():void{
			_faceLink=new FaceLink(_radio,_extractedMesh,_extractedMesh.faces[0],10,true);
		}
		private function parse3ds():void{
			var max3ds:Max3DS=new Max3DS();
			_model3ds=max3ds.parseGeometry(SpyModel3ds)as ObjectContainer3D;
			_model3ds.materialLibrary.getMaterial("spy_red").material=_bitMat;
			_extractedMesh=_model3ds.children[0]as Mesh;
			_view.scene.addChild(_extractedMesh);
			_extractedMesh.z=300;
			max3ds=new Max3DS();
			_radio=max3ds.parseGeometry(SpyRadio)as ObjectContainer3D;
			_radio.materialLibrary.getMaterial("sapper").material=_radioMaterial;
			_view.scene.addChild(_radio);
			
		}
		private function onKnobMove(e:Event):void{
			var indexVal:uint=Math.floor(e.target.value);
			if(indexVal<_extractedMesh.faces.length){
				_faceLink.face=_extractedMesh.faces[indexVal];
			}
				_faceLink.update();
			
		}
		override protected function initListeners() : void{
			super.initListeners();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		override protected function initMaterials() : void{
			_bitMat=new BitmapMaterial(Cast.bitmap(new SpyTexture()));
			_radioMaterial=new BitmapMaterial(Cast.bitmap(new RadioTexture()));
		}
		override protected function initGeometry() : void{
			parse3ds();
			
		}
	    override protected function onEnterFrame(e:Event) : void{
			super.onEnterFrame(e);
			if (_move) {
				_hoverCam.panAngle = 0.3 * (stage.mouseX - _lastMouseX) + _lastPanAngle;
				_hoverCam.tiltAngle = 0.3 * (stage.mouseY - _lastMouseY) + _lastTiltAngle;
			}
			_hoverCam.hover();  
		}
		private function onMouseDown(e:MouseEvent):void
		{
			_lastPanAngle = _hoverCam.panAngle;
			_lastTiltAngle = _hoverCam.tiltAngle;
			_lastMouseX = stage.mouseX;
			_lastMouseY = stage.mouseY;
			_move = true;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_move = false;	
		}
	}
}