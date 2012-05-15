package
{
	
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Sphere;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class AdvancedRotation extends AwayTemplate
	{
		private var _sphere:Sphere;
		private var _bitMat:BitmapMaterial;
		private var _canMove:Boolean=false;
		private var _sphereMatrix:Matrix3D=new Matrix3D();
		public function AdvancedRotation()
		{
			super();
			_cam.z=-800;
		}
		override protected function initGeometry():void{
			_sphere=new Sphere({radius:100,material:_bitMat,segmentsH:20,segmentsW:20});
			_view.scene.addChild(_sphere);
			_sphere.position=new Vector3D(0,0,400);
		}
		override protected function initListeners():void{
			super.initListeners();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp,false,0,true);
		}
		override protected function initMaterials():void{
			var bdata:BitmapData=new BitmapData(256,256);
			bdata.perlinNoise(26,26,18,1534,false,true,7,true);
			_bitMat=new BitmapMaterial(bdata);	
		}
		
		override protected function onEnterFrame(e:Event):void
		{	
			if(_canMove){

				var vector:Vector3D=new Vector3D(0,0,1);
				var mouseVector:Vector3D=new Vector3D(400 - mouseX, mouseY - 300, 0);
				var resVector:Vector3D;
				resVector=vector.crossProduct(mouseVector);
				resVector.normalize();
				var mtr:Matrix3D=new Matrix3D();
				var rotDegrees:Number=Math.PI*Math.sqrt(Math.pow( mouseX-400 , 2) + Math.pow(300-mouseY, 2))/100;
				mtr.appendRotation(rotDegrees ,new Vector3D(resVector.x, resVector.y,resVector.z),_sphere.pivotPoint);
				_sphereMatrix.append(mtr);
				_sphereMatrix.position=_sphere.position;
				_sphere.transform=_sphereMatrix;

			}
			super.onEnterFrame(e);	
		}
		
		
		private function onMouseDown(e:MouseEvent):void
		{
			_canMove = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		private function onMouseUp(e:MouseEvent):void
		{
			_canMove = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
		}
		private function onStageMouseLeave(e:Event):void
		{
			_canMove = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
		}
	}
}