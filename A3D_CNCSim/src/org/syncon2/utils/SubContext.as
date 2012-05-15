package  org.syncon2.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.mvcs.Context;
	
	/**
	 * Subcontext base class 
	 * allows context to be injected in 
	 * or can be run individually 
	 * */
	public class  SubContext extends Context //    implements IContextBridgeable
	{
		/**
		 * For mediating views that ar eplaced above context
		 * */
		public var creationComplete : Boolean = false; 		
		
		public function SubContext()
		{
			super();
		}
		
		public function subLoad( this_ : Context, 
								 injector_ : IInjector, commpandMap_ : ICommandMap, 
								 mediatorMap_ : IMediatorMap, contextView_ : DisplayObjectContainer  ) : void
		{
			this.subLoad2( 		this_  , 
				injector_ , commpandMap_ , 
				mediatorMap_, contextView_ )
		}
		/**
		 * Non strict version for openplug
		 * */
		public function subLoad2( this_ :  Object, 
								  injector_ : Object, commpandMap_ : Object, 
								  mediatorMap_ : Object, contextView_ : Object  ) : void
		{
			//hack to get around type casting 
			this['injector'] = injector_
			this['commandMap'] = commpandMap_
			this['mediatorMap'] = mediatorMap_
			this['_this_'] = this_
			//perhabs set this as a 'sub' so ti doesnt not duplicate event listners, but all events are on app 
			//s o should be ok ...
			//this['contextView'] = contextView_
			//just use this._this..
			//is this really necessary? ... 
			//this.contextView = contextView_ 
			this.startup()			
			
			this.creationComplete = true; 
			this.tryToRegisterEarlyMediations()
			tryToMediateEarlyViews()				
		}
		
		protected  var _this_   :Context;
		protected function get _this () :  Context
		{
			if ( this._this_ == null ) return this; 
			return this._this_ 
		}
		/*		
		override public function startup():void
		{
		// Model
		// Controller
		// Services
		// View
		//use _this_
		//mediatorMap.mapView( popup_drag_listerV2 , PopupDragListerMediator, null, false, false );	
		//this._this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, 
		//popup_drag_listerV2, 'popup_drag_lister', false, false  ) ); 
		}
		*/
		override public function dispatchEvent(event:Event):Boolean
		{
			return this._this.dispatchEvent( event ) 
		}
		
		private var earlyMediations : Array = []; 
		private var earlyViews : Array = []; 
		/**
		 * Allows  import of view componets tha tmight be place on top of this one ....
		 * */
		public function mapMediator(view:Object=null) : void
		{
			if ( this.creationComplete == false ) 
			{
				this.earlyViews.push( view )
				return; 
			}
			mediatorMap.createMediator(view)
		}		
		
		private function tryToMediateEarlyViews() : void
		{
			for each ( var ui : Object in earlyViews )
			{
				mapMediator(ui)
			}
		}		
		
		private function tryToRegisterEarlyMediations() : void
		{
			for each ( var args  :  Array in this.earlyMediations )
			{
				mapView.apply( this, args ) ; 
			}			
		}
		
		//will add this to an inteface later
		/**
		 * Expose map view to manually  bridge events
		 * https://github.com/robotlegs/robotlegs-framework/blob/master/src/org/robotlegs/base/MediatorMap.as
		 * */
		public function  mapView(viewClassOrName:*, mediatorClass:Class, injectViewAs:* = null, 
								 autoCreate:Boolean = true, autoRemove:Boolean = true):void
		{	
			if ( this.creationComplete  == false ) 
			{
				this.earlyMediations.push( [ viewClassOrName, mediatorClass, injectViewAs, autoCreate, autoRemove] )
				return; 				
			}
			this.mediatorMap.mapView( viewClassOrName, mediatorClass, injectViewAs, autoCreate, autoRemove )
			
		}				
		public function  unmapView(viewClassOrName:*):void
		{			
			this.mediatorMap.unmapView( viewClassOrName);
		}				
	}
}