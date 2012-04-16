package Chapter8Source
{
	import away3d.core.base.UV;
	import away3d.core.utils.Cast;
	import away3d.events.MouseEvent3D;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.data.CubeMaterialsData;
	import flash.geom.Vector3D;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	public class MouseMoveDemo2 extends Away3DTemplate
	{
		[Embed(source="boxtexture.jpg")] protected var BoxTexture:Class;
		protected var drawing:Boolean;
		protected var lastEvent:MouseEvent3D;
		
		public function MouseMoveDemo2()
		{
			super();
		}
		
		protected override function initScene():void
		{
			super.initScene();
			
			view.forceUpdate = true;
			
			camera.position = new Vector3D(0, 100, 0);
			camera.tilt(20);
			
			var cube:Cube = new Cube(
				{
					cubeMaterials: new CubeMaterialsData(
						{
							left: new BitmapMaterial(Cast.bitmap(BoxTexture)),
							right: new BitmapMaterial(Cast.bitmap(BoxTexture)),
							bottom: new BitmapMaterial(Cast.bitmap(BoxTexture)),
							top: new BitmapMaterial(Cast.bitmap(BoxTexture)),
							front: new BitmapMaterial(Cast.bitmap(BoxTexture)),
							back: new BitmapMaterial(Cast.bitmap(BoxTexture))
						}
					),
					rotationY: 45,
					z: 300
				}
			);
			scene.addChild(cube);
			
			cube.addEventListener(MouseEvent3D.ROLL_OUT, onRollOut);
			cube.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			cube.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			drawing = false;
			lastEvent = null;
		}
		
		protected function onRollOut(event:MouseEvent3D):void
		{
			drawing = false;
			lastEvent = null;
		}
		
		protected function onMouseDown(event:MouseEvent3D):void
		{
			drawing = true;
		}
		
		protected function onMouseMove(event:MouseEvent3D):void
		{
			if (drawing)
			{
				if (lastEvent != null && lastEvent.material == event.material)
				{
					var material:BitmapMaterial = event.material as BitmapMaterial;
					var bitmap:BitmapData = material.bitmap;

					drawLine(
						lastEvent.uv.u * bitmap.width,
						(1 - lastEvent.uv.v) * bitmap.height,
						event.uv.u * bitmap.width,
						(1 - event.uv.v) * bitmap.height,
						bitmap,
						0x4488FF);
				}
				
				lastEvent = event;
			}
		}
		
		protected function drawLine(x1:int, y1:int, x2:int, y2:int, bitmap:BitmapData, col: int):void
		{
			var x:int, y:int;
			var dx:int, dy:int;
			var incx:int, incy:int
			var balance:int;
			if (x2>= x1){
				dx = x2 - x1;
				incx = 1;
			}else{
				dx = x1 - x2;
				incx = -1;
			}
			if (y2>= y1){
				dy = y2 - y1;
				incy = 1;
			}else{
				dy = y1 - y2;
				incy = -1;
			}
			x = x1;
			y = y1;
			if (dx>= dy){
				dy <<= 1;
				balance = dy - dx;
				dx <<= 1;
				while (x != x2){
					bitmap.setPixel(x, y, col);
					if (balance>= 0){
						y += incy;
						balance -= dx;
					}
					balance += dy;
					x += incx;
				}
				bitmap.setPixel(x, y, col);
			}else{
				dx <<= 1;
				balance = dx - dy;
				dy <<= 1;
				while (y != y2){
					bitmap.setPixel(x, y, col);
					if (balance>= 0){
						x += incx;
						balance -= dy;
					}
					balance += dx;
					y += incy;
				}
				bitmap.setPixel(x, y, col);
			}
		}		
	}
}