package chp5
{
	import away3d.core.base.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.WireColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Sphere;
	
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;

	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class ViewMasking extends AwayTemplate
	{
		private var _v1Sphere:Sphere;
		private var _v2Sphere:Sphere;
		private var _maskCube:Mesh;
		private var _realCube:Cube;
		private var _colMat:ColorMaterial;
		private var _wireMat:WireColorMaterial;
		public function ViewMasking()
		{
			super();
		}
		
		override protected function setup(): void
		{
			_cam.z=-200;
		}
		override protected function initMaterials() : void{
			_colMat=new ColorMaterial(0x23ff99);
			_wireMat=new WireColorMaterial(0x128733);
		}	
		override protected function initGeometry() : void{
			_v1Sphere=new Sphere({radius:40,material:_wireMat,ownCanvas:true});
			_v1Sphere.z=200;
			_v1Sphere.screenZOffset=10;
			_v2Sphere=new Sphere({radius:40,material:_colMat,ownCanvas:true});
			_v2Sphere.z=200;
			_v2Sphere.screenZOffset=20;
			_view.scene.addChild(_v2Sphere);
			_view.scene.addChild(_v1Sphere);
			var maskedSprite:Sprite=_v1Sphere.session.getContainer(_view) as Sprite;
			_realCube=new Cube({material:new ColorMaterial(0x092287),width:300,height:40,depth:80,ownCanvas:true});
			_realCube.cubeMaterials.front=new ColorMaterial(0x000000);
			_realCube.cubeMaterials.back=new ColorMaterial(0x000000);
			_realCube.z=150;
			_realCube.y=100;
			_realCube.rotationZ=20;
			_realCube.alpha=0.3;
			_view.scene.addChild(_realCube);
			_maskCube=_realCube.clone()as Mesh;
			_maskCube.z=150;
			_view.scene.addChild(_maskCube);
			_maskCube.ownCanvas=true;
			var maskSprite:Sprite=_maskCube.ownSession.getContainer(_view) as Sprite;
			maskedSprite.mask=maskSprite;
			TweenMax.to(_realCube,3,{y:-100,rotationY:180,repeat:-1,yoyo:true});
		}
		override protected function onEnterFrame(e:Event) : void{
			super.onEnterFrame(e);
			_maskCube.transform=_realCube.transform;
		}
		
	}
}