package chp13
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.core.base.Face;
	import away3d.core.base.Vertex;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.WireColorMaterial;
	import away3d.materials.utils.data.Ray;
	import away3d.primitives.LineSegment;
	import away3d.primitives.Sphere;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Vector3D;
	
	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class CollisionDemo extends AwayTemplate
	{
		private var _objA:Sphere;
		private var _objB:Sphere;
		private var _matA:ColorMaterial;
		private var _matB:ColorMaterial;
		private var _lineSeg:LineSegment;
		private var _wireMat:WireColorMaterial;
		private var _startVertex:Vertex=new Vertex(0,0,0);
		private var _endtVertex:Vertex=new Vertex(0,0,0);
		private var _gFilter:GlowFilter=new GlowFilter();
		private var _bitMap:BitmapMaterial;
		public function CollisionDemo()
		{
			super();


		}
		override protected function initMaterials() : void{
			_matA=new ColorMaterial(0xFF1255);
			_matB=new ColorMaterial(0x00FF11);
			_wireMat=new WireColorMaterial(0x220033);
			var bdata:BitmapData=new BitmapData(128,128);
			bdata.perlinNoise(13,13,12,324234,true,true);
			_bitMap=new BitmapMaterial(bdata);
		}
		override protected function initGeometry() : void{
			_view.camera.lens=new PerspectiveLens();
			_cam.z=-300;
			
			
			_objA=new Sphere({radius:30,material:_matA}); 
			_objB=new Sphere({radius:30,material:_bitMap});
			_view.scene.addChild(_objA); 
			_view.scene.addChild(_objB);
			
		  //  _objB.ownCanvas=true;
			//_objA.debugbs=true;
			//_objB.debugbs=true;
			_objA.transform.position=new Vector3D(-80,0,100);
			_objB.transform.position=new Vector3D(0,20,100);
			_lineSeg=new LineSegment();
			_view.scene.addChild(_lineSeg);
			_lineSeg.material=_wireMat;
		
		}
		override protected function initListeners() : void{
			super.initListeners();
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		override protected function onEnterFrame(e:Event) : void{
			RayFaceTest();
		
			super.onEnterFrame(e);
		//	trace(RayAABSTest());
			/*if(RayAABSTest()){
			_objB.filters=[_gFilter];
			}else{
			_objB.filters=[];
			}*/
			
              _objB.rotate(Vector3D.X_AXIS,5);

			
		}
		private function AABSTest():Boolean{
			///first approach/////////////
			var dist:Number=Vector3D.distance(_objA.position,_objB.position);
			if(dist<=(_objA.radius+_objB.radius)){
				return true;
			}
			return false;
			//second optional (more math oriented) aproach///
			//var centerDiff:Vector3D=_objA.position.subtract(_objB.position);
			//var radSum:Number=_objA.radius+_objB.radius;
			//trace(centerDiff.dotProduct(centerDiff)<=radSum*radSum);
		}
		private function RayAABSTest():Boolean{
			var ray:Ray=new Ray();
			ray.orig=_objA.position;
			var d:Vector3D=new Vector3D(0,100,0);
			var dir:Vector3D=_objA.transform.transformVector(d);
			ray.dir=dir;
			_startVertex.x=ray.orig.x;
			_startVertex.y=ray.orig.y
			_startVertex.z=ray.orig.z
			_lineSeg.start=_startVertex;
			_endtVertex.x=ray.dir.x;
			_endtVertex.y=ray.dir.y;
			_endtVertex.z=ray.dir.z;
			_lineSeg.end=_endtVertex;
			_view.scene.addChild(_lineSeg);
			_lineSeg.material=_wireMat;
		     ray.orig.normalize();
		     ray.dir.normalize();
			return ray.intersectBoundingRadius( _objB.position,_objB.boundingRadius);	
		}
		private function RayFaceTest():Vector3D{
			var intersectVector:Vector3D;
			var ray:Ray=new Ray();

			for(var i:int=0;i<_objB.faces.length;++i){
				var p0:Vector3D=_objB.sceneTransform.transformVector(_objB.faces[i].vertices[0].position);
				var p1:Vector3D=_objB.sceneTransform.transformVector(_objB.faces[i].vertices[1].position);
				var p2:Vector3D=_objB.sceneTransform.transformVector(_objB.faces[i].vertices[2].position);

				ray.orig=_objA.position;
				var dd:Vector3D=new Vector3D(0,400,0);
				var dird:Vector3D=_objA.transform.transformVector(dd);
				
				ray.dir=dird;
				rayDebug(ray.orig,ray.dir);
				intersectVector=ray.getIntersect(ray.orig,ray.dir,p0,p1,p2);
			
			   if(intersectVector){
				   trace(intersectVector);
				   var fc:Face=_objB.faces[i];
				   _objB.removeFace(fc);
				   break;
			   }
		//	   trace("continue loop");
			}
			trace(_objB.faces.length);
			////if the for loop above finished executing after all the triangles were deleted
			///we still want to draw the visual ray
		    if(_objB.faces.length==0){
				ray.orig=_objA.position;
				var dd1:Vector3D=new Vector3D(0,400,0);
				var dird1:Vector3D=_objA.transform.transformVector(dd1);
				ray.dir=dird1;
				rayDebug(ray.orig,ray.dir);
			}
		
			
			return intersectVector;
		}
		private function rayDebug(orig:Vector3D,dir:Vector3D):void{
			_startVertex.x=orig.x;
			_startVertex.y=orig.y
			_startVertex.z=orig.z
			_lineSeg.start=_startVertex;
			_endtVertex.x=dir.x;
			_endtVertex.y=dir.y;
			_endtVertex.z=dir.z;
			_lineSeg.end=_endtVertex;
		}
		private function AABBTest():Boolean{
			if(_objA.parentMinX>_objB.parentMaxX||_objB.parentMinX>_objA.parentMaxX){
				return false;
			}
			if(_objA.parentMinY>_objB.parentMaxY||_objB.parentMinY>_objA.parentMaxY){
				return false;
			}
			if(_objA.parentMinZ>_objB.parentMaxZ||_objB.parentMinZ>_objA.parentMaxZ){
				return false;
			}
			return true;
		}
		private function onKeyDown(e:KeyboardEvent):void{
			switch(e.keyCode){
				case 38:_objA.moveUp(5);	break;
				case 40:_objA.moveDown(5);break;
				case 37:	_objA.moveLeft(5);	break;	
				case 39:	_objA.moveRight(5);break;	
				case 65:_objA.rotationZ-=3;break;///A/////
				case 83:_objA.rotationZ+=3;break;	///S////
				default:
			}
		}
	}
}