package chp3
{
	import away3d.animators.BonesAnimator;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.utils.Cast;
	import away3d.events.AnimatorEvent;
	import away3d.loaders.Collada;
	import away3d.loaders.utils.AnimationLibrary;
	import away3d.materials.BitmapMaterial;
	import away3d.test.Button;
	
	import flash.events.MouseEvent;
	
	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class ColladaAnimationDemo extends AwayTemplate
	{
		[Embed(source="assets/animatedSpy/spyJumpAndWalk.dae",mimeType="application/octet-stream")]
		private var SpyModel:Class;
		[Embed(source="assets/animatedSpy/spyObjRe.jpg")]
		private var SpyTexture:Class;
		
		private var _bitMat:BitmapMaterial;
		private var _modelDAE:ObjectContainer3D;
		private var _animMode:String="stand";///"jump","walk"//
		private var _skinAnimator:BonesAnimator;
		private var _jumpAnimBut:Button;
		private var _walkAnimBut:Button;
		public function ColladaAnimationDemo()
		{
			super();
			initUI();
		}
		override protected function initMaterials() : void{
			_bitMat=new BitmapMaterial(Cast.bitmap(new SpyTexture()));
		}
		override protected function initGeometry() : void{
			parseDAE();
		}
		private function initUI():void{
			_jumpAnimBut=new Button("start jumping",120,30);
			_walkAnimBut=new Button("start walking",120,30);
			_view.addChild(_jumpAnimBut);_jumpAnimBut.x=-400;_jumpAnimBut.y=-180;
			_view.addChild(_walkAnimBut);_walkAnimBut.x=-400;_walkAnimBut.y=-140;
			_jumpAnimBut.addEventListener(MouseEvent.CLICK,onMousePress,false,0,true);
			_walkAnimBut.addEventListener(MouseEvent.CLICK,onMousePress,false,0,true);
		}
		private function  onMousePress(e:MouseEvent):void{
			switch(e.currentTarget){
				case _jumpAnimBut:
					_skinAnimator.gotoAndPlay(1);
					_animMode="jump";
					break;
				case _walkAnimBut:
					_skinAnimator.stop();
					_skinAnimator.gotoAndPlay(50);
					_animMode="walk";
					break;
			}
		}
		
		private function accessAnimationData():void{
			/////////////animation//////////////
			var animLib:AnimationLibrary=_modelDAE.animationLibrary;
			
			_skinAnimator=animLib.getAnimation("default").animator as BonesAnimator;
			_skinAnimator.interpolate=true;
			_skinAnimator.addOnEnterKeyFrame(onAnimKeyFrameEnter);
			//_skinAnimator.play();
		}
		private function parseDAE():void{
			
			var _dae:Collada=new Collada();
			_dae.centerMeshes=true;
			
			_modelDAE=_dae.parseGeometry(SpyModel)as ObjectContainer3D;
			_view.scene.addChild(_modelDAE);
			_modelDAE.materialLibrary.getMaterial("spy_red").material=_bitMat;
			_modelDAE.scale(1);
			//_modelDAE.centerMeshes();
			//_modelDAE.centerPivot();
			_modelDAE.x=120;
			_modelDAE.y=-170;
			_modelDAE.z=2500;
			
			accessAnimationData();
		}
		private function onAnimKeyFrameEnter(e:AnimatorEvent):void{
			trace(e.animator.currentFrame);
			
			if(e.animator.currentFrame>=50){
				if(_animMode=="jump"){
					e.animator.gotoAndPlay(1);
				}
			}
			if(e.animator.currentFrame>=75){
				if(_animMode=="walk"){
					e.animator.gotoAndPlay(50);
				}
			}
		}
		
	}
}