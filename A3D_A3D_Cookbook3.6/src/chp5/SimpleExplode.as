package chp5
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight3D;
	import away3d.materials.ShadingColorMaterial;
	import away3d.primitives.Sphere;
	import away3d.test.Button;
	import away3d.tools.Explode;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class SimpleExplode extends AwayTemplate
	{
		private var _explodeContainer:ObjectContainer3D;
		private var _sphere:Sphere;
		private var _light:PointLight3D;
		private var _colShade:ShadingColorMaterial;
		private var _canReset:Boolean=false;
		public function SimpleExplode()
		{
			super();
			_cam.z=-1000;
			initLight();
			initGUI();
		}
		override protected function initGeometry() : void{
			setGeometry()
		}
		override protected function initMaterials():void{
			_colShade=new ShadingColorMaterial(0xFD2D2D);
			_colShade.shininess=3
			_colShade.specular=2.4;
			_colShade.ambient=0x127623;
		}
		override protected function initListeners():void{
			super.initListeners();
			_view.addEventListener(MouseEvent3D.MOUSE_DOWN,explodeAll);
		} 
		private function initLight():void{
			_light=new PointLight3D({color:0xFD2D2D, ambient:0.25, diffuse:0.13, specular:6});
			_light.brightness=4;
			_view.scene.addLight(_light);
			_light.position=new Vector3D(150,150,0);
		}
		private function setGeometry():void{
			_sphere=new Sphere({radius:50,material:_colShade,bothsides:true,ownCanvas:true,segmentsH:16,segmentsW:16});
			_view.scene.addChild(_sphere);
		}
		private function explodeAll(e:MouseEvent3D):void{
			//////remove light for performance reason///////////////
			_view.scene.removeLight(_light);
			var explode:Explode=new Explode(true,true);
			
			_explodeContainer=explode.apply(_sphere) as ObjectContainer3D
			_view.scene.addChild(_explodeContainer);
			_view.scene.removeChild(_sphere);
			
			for each(var item:Mesh in _explodeContainer.children)
			{
				item.scaleX = 0.5;
				item.bothsides=true;
				var vector:Vector3D=item.position;
				TweenMax.to(item,25,{x:vector.x*(25+Math.random()*1000-500),y:vector.y*(25+Math.random()*1000-500),z:vector.z*(25+Math.random()*1000-500), ease:Linear.easeOut, onComplete:deleteTri,onCompleteParams:[item]});
				TweenMax.to(item,12,{rotationX:Math.random()*3000-1500,rotationY:Math.random()*3000-1500,rotationZ:Math.random()*3000-1500});
			}
			_canReset=true;
		}
		private function initGUI():void{
			var button:Button=new Button("reset");
			this.addChild(button);
			button.x=100;
			button.y=50;
			button.addEventListener(MouseEvent.CLICK,onButtonClick);
			
		}
		private function onButtonClick(e:MouseEvent):void{
			if(_canReset){
				resetGeometry();
				_canReset=false;
			}
		}
		private function resetGeometry():void{
			_view.scene.removeChild(_sphere);
			_sphere=null;
		///////////deep cleanup////////////////////
			for(var i:int=0;i<_explodeContainer.children.length;i++){
				_explodeContainer.removeChild(_explodeContainer.children[i]);
				_explodeContainer.children[i]=null;
			}
			_view.scene.removeChild(_explodeContainer);
			_explodeContainer=null;
			_view.scene.addLight(_light);
			setGeometry();
		}
		private function deleteTri(item:Mesh):void{
			if(_explodeContainer){
				_explodeContainer.removeChild(item);
			}
			
		}
	}
}