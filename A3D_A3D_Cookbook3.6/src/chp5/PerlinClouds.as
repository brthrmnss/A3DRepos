package chp5
{
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Plane;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class PerlinClouds extends AwayTemplate
	{
		private var _planes:Array=[];
		private var _numberOfPlanes:int=6;
		private var _perlin3D:Array=[];
		private var _plane:Plane;
		private var _planeSize:int=700;
		private var _offsets:Array;
		private   var _colTransform:ColorTransform=new ColorTransform(1,1,4,0.6,8,21,63,-48);
		private var _glowF:GlowFilter=new GlowFilter(0x156EC6,1,3,3,2,2,false,false);
		private var _mainContainer:ObjectContainer3D;
		public function PerlinClouds()
		{
			super();
		}
		override protected function initMaterials() : void{
			
		}
		override protected function initGeometry() :  void{
			_mainContainer=new ObjectContainer3D();
			_view.scene.addChild(_mainContainer);
			_mainContainer.z=4200;
			initCLoudPlanes();
			_cam.lookAt(_mainContainer.position,Vector3D.Y_AXIS);
			
		}
		override protected function onEnterFrame(e:Event) : void{
			super.onEnterFrame(e);
			redraw();
		}
		////////////////////////////////////////////////////////
		private function initCLoudPlanes():void{		
			_offsets = [new Point(0, 0), new Point(0, 0), new Point(0, 0)];
			var scaleFactor:int=1; 
			while ( _numberOfPlanes--) 
			{
				scaleFactor++;
				_plane = new Plane({material:null,width: _planeSize *scaleFactor * 3, height:_planeSize * scaleFactor * 3});
				_plane.rotationX=90;
				//_plane.ownCanvas=true;
				// _plane.blendMode=BlendMode.HARDLIGHT;
				_mainContainer.addChild( _plane);
				_plane.z = _numberOfPlanes * _planeSize/3;
			 
				_planes.push(_plane);
				
			}

		}
		private function draw3DPerlin():void{
			
			
			var textureBdata:BitmapData;
			_perlin3D.pop();
			
			while (_perlin3D.length < 6) 
			{
				textureBdata = new BitmapData(64, 64, true, 0);///
				/////////////////////
				textureBdata.perlinNoise(16,13,17,123456, true, true, 15, false, _offsets);
				textureBdata.colorTransform(textureBdata.rect,  _colTransform);
				textureBdata.applyFilter(textureBdata,textureBdata.rect,new Point(0,0),_glowF);
				_offsets[0].x = _offsets[0].x + 1 ;
				_offsets[0].y = _offsets[0].y + 1 ;
				_offsets[2].x = _offsets[2].x - 1 ;
				_offsets[2].y = _offsets[2].y + 0.5 ;
				_offsets[1].x = _offsets[1].x - 1 ;
				_offsets[1].y = _offsets[1].y - 2.7;
				_perlin3D.splice(0, 0, textureBdata);
			
			}
			
		}
		private function redraw():void{
			var counter:int=0;
			draw3DPerlin();
			while (counter < _planes.length) 
			{
				var bitMat:BitmapMaterial= new BitmapMaterial(_perlin3D[counter]);
				bitMat.smooth=true;
				_planes[counter].material=bitMat; 
				++counter;
				
			}
			
		}
	}
}