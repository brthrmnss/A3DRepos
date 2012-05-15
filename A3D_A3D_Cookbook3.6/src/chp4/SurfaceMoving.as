package
{

	import away3d.events.MouseEvent3D;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import utils.Quaternion;

	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class SurfaceMoving extends AwayTemplate
	{
		private var _sphere:Sphere;
		private var _bitMat:BitmapMaterial;
		private var _tracker:Plane;
		private var _clickAngleX:Number=0;
		private var _clickAngleY:Number=0;
		private var _clickAngleZ:Number=0;
		private var clickVectorOld:Vector3D=new Vector3D(0,0,0);
		private var clickVector:Vector3D=new Vector3D(0,0,0);
		private static const DEGStoRADS:Number=Math.PI/180;
		private var tweenObj:Object;
		private var _endMatr:Matrix3D;
		private var _endQ:utils.Quaternion;
		private var qStart:utils.Quaternion;
		private var _tweenFinished:Boolean=true;
		public function SurfaceMoving()
		{
			super();
			_cam.z=-800;
		}
		override protected function initGeometry():void{
			_sphere=new Sphere({radius:100,material:_bitMat,segmentsH:20,segmentsW:20});
			_view.scene.addChild(_sphere);
			_sphere.position=new Vector3D(0,0,0);
			_sphere.addOnMouseDown(onObjMouseDown);
			_tracker=new Plane({width:40,height:40,material:new ColorMaterial(0x229834)});
			_tracker.bothsides=true;
			_tracker.yUp=false;
			_view.scene.addChild(_tracker);
			_tracker.position=new Vector3D(100,100,0);
			_tracker.lookAt(_sphere.position);
		}
		override protected function initListeners():void{
			super.initListeners();
		}
		override protected function initMaterials():void{
			var bdata:BitmapData=new BitmapData(256,256);
			bdata.perlinNoise(26,26,18,1534,false,true,7,true);
			_bitMat=new BitmapMaterial(bdata);
		
		}
		private function onObjMouseDown(e:MouseEvent3D):void{
			if(_tweenFinished){
			clickVector=new Vector3D(e.sceneX,e.sceneY,e.sceneZ);
			clickVector.scaleBy(2.5);
			clickVector.normalize();


			/////////
			qStart=new Quaternion();
			qStart.x=_tracker.x;
			qStart.y=_tracker.y;
			qStart.z=_tracker.z;
			qStart.w=0;
			var startVec:Vector3D=_tracker.position;
			startVec.normalize();
			var cross:Vector3D=startVec.crossProduct(clickVector);
			var rotAngle:Number=Math.acos(startVec.dotProduct(clickVector));
			var q:Quaternion=new Quaternion();
			q.axis2quaternion(cross.x,cross.y,cross.z,rotAngle);
			var invertedQ:Quaternion=Quaternion.conjugate(q);
			_endQ=new Quaternion();
			_endQ.multiply(q,qStart);
			_endQ.multiply(q,_endQ);
			 tweenObj=new Object();
			 tweenObj.intrp=0;
			
				 TweenMax.to(tweenObj,1,{intrp:1,onUpdate:onTweenUpdate,onComplete:onTweenFinished});
				 _tweenFinished=false;
				 trace(_tracker.position);
			 }
			
				
		}
		private function onTweenFinished():void{
			_tweenFinished=true;
		}
		private function onTweenUpdate():void{

			/////////slerp////////////////////////
			
			var slerped:utils.Quaternion=utils.Quaternion.slerp(qStart,_endQ, tweenObj.intrp);
			var endMatr:Matrix3D=new Matrix3D();
		
			 endMatr.appendTranslation(slerped.x,slerped.y,slerped.z);
			 _tracker.x=endMatr.position.x;
			 _tracker.y=endMatr.position.y;
			 _tracker.z=endMatr.position.z;
			_tracker.lookAt(_sphere.position);
			/////////////////////vector interpolation no SLERP/////////
			/*var fr:Number3D=_tracker.position;
			fr.interpolate(new Number3D( _endMatr.tx, _endMatr.ty, _endMatr.tz), tweenObj.intrp);
			trace(fr);
			_tracker.position=fr;*/
		}
	}
}