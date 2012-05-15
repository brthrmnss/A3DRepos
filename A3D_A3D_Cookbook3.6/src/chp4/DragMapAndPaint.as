package
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.events.MouseEvent3D;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.MovieMaterial;
	import away3d.primitives.Sphere;
	
	import com.bit101.components.ColorChooser;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class DragMapAndPaint extends AwayTemplate
	{
		
	    private var _sphere:Sphere;
		private var _bitMat:BitmapMaterial;
		private var _movieMat:MovieMaterial;
		private var brush:Sprite=new Sprite();
		private var _canPaint:Boolean=false;
		private var _selectedColor:uint=0xffffff;
		public function DragMapAndPaint()
		{
			super();
			setLens();
			initColorPicker();
		}
		private function setLens():void{
			_view.camera.lens=new PerspectiveLens();
		}
		override protected function initGeometry():void{
			_sphere=new Sphere({radius:100,material:_movieMat,segmentsH:20,segmentsW:20});
			_view.scene.addChild(_sphere);
			_sphere.position=new Vector3D(0,0,400);

			_sphere.addOnMouseDown(onMouse3DDown);
			_sphere.addOnMouseUp(onMouseUp);
			_sphere.addOnMouseMove(onMouseMove);
		}
		
		override protected function initMaterials():void{
			var bdata:BitmapData=new BitmapData(256,256);
			bdata.perlinNoise(26,26,18,1534,false,true,7,false);
			var defaultSprite:Sprite=new Sprite();
			defaultSprite.graphics.beginBitmapFill(bdata);
			defaultSprite.graphics.drawRect(0,0,256,256);
			defaultSprite.graphics.endFill();
			_movieMat=new MovieMaterial(defaultSprite);
			_movieMat.interactive=true;
			_movieMat.smooth=true;
		}
		
		private function initColorPicker():void{
			var colorPiker:ColorChooser=new ColorChooser(this,100,100,0xcccccc,onColorPick);
			colorPiker.usePopup=true;
			colorPiker.draw();
		}
		private function onColorPick(e:Event):void{
			var validLengthString:String=e.target.value.toString();
				_selectedColor=e.target.value;
		}
		private function onMouse3DDown(e:MouseEvent3D):void{
			_canPaint=true;
		}
		private function  onMouseUp(e:MouseEvent3D):void{
			_canPaint=false;
		}
		private function onMouseMove(e:MouseEvent3D):void{
			if(_canPaint){
				draw(e.uv.u,1-e.uv.v);
			}
		}
		private function draw(u:Number,v:Number):void{
				var mClip:Sprite=_movieMat.movie as Sprite;
				mClip.graphics.beginFill(_selectedColor);
				mClip.graphics.drawCircle(u*mClip.width,v*mClip.height,2);
				mClip.graphics.endFill();
				

				///////second approach (using blending modes//////////////
				/*var shape:Shape=new Shape();
				shape.blendMode=BlendMode.ADD;
				shape.graphics.beginFill(_selectedColor);
				shape.graphics.drawCircle(u*mClip.width,v*mClip.height,2);
				shape.graphics.endFill();
				mClip.addChild(shape);*/
				

		}
	}
}