package  org.syncon.Customizer.view.ui.components
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.Customizer.controller.EditProductCommandTriggerEvent;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon.Customizer.model.NightStandModelEvent;
	import org.syncon.Customizer.vo.FaceVO;  
	
	public class TransformationStageMediator extends Mediator 
	{
		[Inject] public var ui : transformation_stage;
		[Inject] public var model : NightStandModel;
		/**
		 * Flag, if true, will play transitions between faces
		 * */
		private var transitionActive:Boolean = true;
		private var _active:Boolean=true;

		/**
		 * Flag blocks switching faces while transition active
		 * */
		public function get active():Boolean
		{
			return _active;
		}

		/**
		 * @private
		 */
		public function set active(value:Boolean):void
		{
			_active = value;
			trace('set active to ', value ) ; 
		}

		
		override public function onRegister():void
		{
			//possible combine design view mediator stuff here?
			this.ui.addEventListener( transformation_stage.SWITCH_FACE, this.onSwitchFaces ) ; 
			//listen for product change to determine faces ... 
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.BASE_ITEM_CHANGED,
				this.onBaseItemChanged);	
			this.onBaseItemChanged( null ) 
			
			
			eventMap.mapListener(eventDispatcher, EditProductCommandTriggerEvent.FACE_LOADED,
				this.onFaceLoaded );	
		}
		
		private function onFaceLoaded(e:Event):void
		{
			if ( this.transitionActive ) 
			{
				this.ui.fxFade.alphaTo = 0 
				this.ui.fxFade.play(); 
				
				setTimeout( this.hideCover, this.ui.fxFade.duration ) ; 
				
			}
		}
		public function hideCover() : void
		{
			this.ui.cover.visible = false; 
			this.active = true; 
		}
		
		/**
		 * Hide switch button if only 1 face exists ...
		 * */
		/**
		 * Change product display name to match baseStoreItem ...
		 * */
		private function onBaseItemChanged(param0:Object):void
		{
			this.ui.btnSwitchSide.visible = true; 
			this.ui.txtProductName.text = this.model.baseItem.name;
			if ( this.model.baseItem.faces.length == 1 ) 
			{
				this.ui.btnSwitchSide.visible = false; 
				return; 
			}
		}		
		
		private function onSwitchFaces(e:Object):void
		{
			
			if ( this.active == false ) 
				return; 
			
			if ( this.model.baseItem.faces.length == 1 ) 
			{
				//there are no other faces ...
				return; 
			}
			if ( transitionActive == false ) 
			{
				this.loadNextFace() 
			}
			else
			{
				this.ui.cover.visible = true; 
				this.ui.fxFade.alphaTo = 1 ; 
				this.ui.fxFade.play()
				
				setTimeout(  this.loadNextFace , 500)
				this.active = false;
			}
		}
		
		private function loadNextFace() : void
		{
			var currentFace : FaceVO = this.model.currentFace
			var index : int = this.model.baseItem.faces.getItemIndex( currentFace ) ; 
			this.model.currentFace
			var nextIndex : int = index; 
			if ( index >= this.model.baseItem.faces.length - 1 )
			{
				nextIndex =-1 
			}
			nextIndex++
			
			var face : FaceVO = this.model.baseItem.faces.getItemAt( nextIndex ) as FaceVO; 
			
			this.dispatch( new EditProductCommandTriggerEvent(
				EditProductCommandTriggerEvent.LOAD_FACE, face, null ) ) 
		}
		
	}
}