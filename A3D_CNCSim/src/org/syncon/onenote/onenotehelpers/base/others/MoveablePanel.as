package   org.syncon.onenote.onenotehelpers.base.others
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.Button;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.CursorManager;
	
	import spark.components.Group;
	import spark.components.Panel;
	import spark.primitives.Rect;
	
	import sss.Shelpers.Shelpers.other.TweenerHelpers;
	
	
	public class MoveablePanel
	{
		
		static public const  EvtMovingState_Entered : String = 'Moving Stated Entered'
		static public const EvtMovingState_Exit : String = 'Moving Stated Exit'
		static public const EvtMovingState_Moved  : String = 'EvtMovingState_Moved' 
		static public const EvtMovingState_BroughtToFront: String = 'EvtMovingState_BroughtToFront' 
		/**
		 * Stores starting x valu e
		 * */
		private var xOriginal:Number;
		private var yOriginal:Number;			
		private var offsetX:Number;
		private var offsetY:Number;			
		
		public var fxMaxY:Function;	
		public var fxMaxX:Function;	
		public var fxMinY:Function;	
		public var fxMinX:Function;			
		
		public var enableHorizonalMovement : Boolean = true
		public var enableVerticalMovement : Boolean = true				
		private static var resizeCursor:Class;
		private var resizeCur:Number		= 0;			
		public var dragging : Boolean = false; 
		
		public var titleBar:UIComponent;
		
		public var moveObject : UIComponent; 
		// add event listeners by overriding partAdded method
		public function registerTitleBar(titleBar:UIComponent):void
		{
			this.titleBar = titleBar; 
			this.titleBar.addEventListener(MouseEvent.MOUSE_DOWN, titleBarDownHandler, false, 0, true )
			this.titleBar.addEventListener(MouseEvent.MOUSE_UP, titleBarUpHandler, false, 0, true )
			this.titleBar.addEventListener(MouseEvent.MOUSE_OVER, this.titlebarMoveOverHandler, false, 0, true ) 
			this.titleBar.addEventListener(MouseEvent.MOUSE_OUT, this.titlebarMoveOutHandler, false, 0, true ) 
		}		
		
		/**
		 * Basic 
		 * @param moveObject
		 * @param bringToFrontWhenClicked
		 * 
		 */
		public function registerMoveObject(moveObject:UIComponent, bringToFrontWhenClicked : Boolean = true ):void
		{
			this.moveObject = moveObject;
			if ( bringToFrontWhenClicked )
				this.moveObject.addEventListener(MouseEvent.CLICK, panelClickHandler, false, 0, true ) 
		}				
		public function panelClickHandler(event:MouseEvent):void {
			this.titleBar.removeEventListener(MouseEvent.MOUSE_MOVE, titleBarMoveHandler);
			this.bringToFront()
 		//disatpch bringtofront event
			this.panelFocusCheckHandler();
		}		
		
		
		/**
		 * If esc pressed an currently moving, leave moving mode
		 * */
		public function onKeyUp( e:   KeyboardEvent) : void
		{
			if ( e.keyCode == Keyboard.ESCAPE   ) 
			{
				this.cancelDrag()
			}  						
		}		
		
		
		
		public function titleBarDownHandler(event:MouseEvent):void {
			// if closed button clicked do not do anything 
			if ( this.moveObject.hasOwnProperty('closeBtn') && 
				event.target ==  (this.moveObject as Object).closeBtn )
			{
				return;
			}
			
			this.startDrag(event)
		}
		
		public function titleBarUpHandler(event:MouseEvent):void {
			// if closed button clicked do not do anything 
			if ( this.moveObject.hasOwnProperty('closeBtn') && 
				event.target ==  (this.moveObject as Object).closeBtn )
			{
				return;
			}
			
			//there is a issue with using mouse down, on mouse up user is stuck dragging .. prevent this 
			//or check for if it is at the same position? leave this mode 
			if ( this.xOriginal == this.moveObject.x && this.yOriginal == this.moveObject.y )
				this.cancelDrag()
		/*	var time : Date = new Date(); 
			//if the user actually clicked it less than 1 second ago 
			if ( this.dragging && time.getTime() < startTime.getTime + 1000  ) 
				this.cancelDrag(); */
		}		
		
		private function startDrag(event:MouseEvent) : void
		{
			//this.titleBar.addEventListener(MouseEvent.MOUSE_MOVE, titleBarMoveHandler, false, 0, true ) 
			this.moveObject.stage.addEventListener(MouseEvent.MOUSE_MOVE, titleBarMoveHandler, false, 0, true ) 
			this.moveObject.stage.addEventListener( KeyboardEvent.KEY_UP , this.onKeyUp, false, 0, true ) 
			offsetX = event.stageX - this.moveObject.x;
			offsetY = event.stageY - this.moveObject.y;			
			this.xOriginal = this.moveObject.x; 
			this.yOriginal = this.moveObject.y; 
			this.moveObject.dispatchEvent( new Event( EvtMovingState_Entered ) ) 		
			this.dragging = true; 
		}
		
		private function cancelDrag() : void
		{
			titleBarDragDropHandler(new MouseEvent('fake'), true)
			this.moveObject.x = this.xOriginal
			this.moveObject.y = this.yOriginal
			if ( this.resizeCur != 0 ) 
			{
				CursorManager.removeCursor(CursorManager.currentCursorID);
				this.resizeCur = 0; 
			}		
		}
		
		private function finishCleanUpDrag() : void
		{
			this.dragging = false; 
			this.moveObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, titleBarMoveHandler);
			this.moveObject.stage.removeEventListener( KeyboardEvent.KEY_UP , this.onKeyUp  ) 
			Application.application.parent.removeEventListener(MouseEvent.MOUSE_UP, titleBarDragDropHandler);
			this.titleBar.removeEventListener(DragEvent.DRAG_DROP,titleBarDragDropHandler);	
			TweenerHelpers.TProp(this.moveObject, 'alpha', 1, 2 )
		}
		
		public function titleBarMoveHandler(event:MouseEvent):void {
			if (this.moveObject.width < this.moveObject.screen.width) {
				Application.application.parent.addEventListener(MouseEvent.MOUSE_UP, titleBarDragDropHandler);
				this.titleBar.addEventListener(DragEvent.DRAG_DROP,titleBarDragDropHandler);
				this.bringToFront(); 
				this.panelFocusCheckHandler();
				//this.alpha = 0.5;
				TweenerHelpers.TProp(this.moveObject, 'alpha', 0.7, 2 ) 
				this.dragObject( event )
				//this.startDrag(false, new Rectangle(0, 0, screen.width - this.moveObject.width, screen.height - this.height));
			}
		}
		
		public function bringToFront() : void
		{
			try {
				this.moveObject.parent.setChildIndex(this.moveObject, this.moveObject.parent.numChildren - 1);
			}
			catch ( e : Error ) 
			{
				var g : Group = this.moveObject.parent as Group
				moveObject.depth = g.numElements -1
				//g.swapElements( this.moveObject, g.getElementAt( this.moveObject.parent.numChildren -1 ) ) 
				//this.moveObject.parentDocument
				//(this.moveObject.parent as Object).setElementIndex(this.moveObject, this.moveObject.parent.numChildren - 1 )
					
				this.moveObject.dispatchEvent( new Event(  EvtMovingState_BroughtToFront  ) ) 
			}
			
		}
		
		
		
		public function dragObject(event:MouseEvent):void
		{
			// Move the dragged object to the location of the cursor, maintaining 
			// the offset between the cursor's location and the location 
			// of the dragged object.
			if ( this.enableHorizonalMovement )
				this.moveObject.x = event.stageX - offsetX;
			if ( this.enableVerticalMovement )
				this.moveObject.y = event.stageY - offsetY;
			//if ( this.fxMax != null ) 
			//var dbg  : Array = [ this.fxMaxX() , this.fxMaxY(), this.fxMinX() 		, this.fxMinY()   ]
			if ( this.fxMaxY != null ) 
				if ( this.fxMaxY() < this.moveObject.y   + this.moveObject.height + 5 ) 
					this.moveObject.y = this.fxMaxY() - (this.moveObject.height + 5)  
			if ( this.fxMaxX != null ) 
				if ( this.fxMaxX() < this.moveObject.x + this.moveObject.width ) 
					this.moveObject.x = this.fxMaxX() - (this.moveObject.width + 5)   			
						
			if ( this.fxMinY != null ) 
				if ( this.fxMinY() + 10  > this.moveObject.y  ) 
					this.moveObject.y = this.fxMinY() + 10
			if ( this.fxMinX != null ) 
				if ( this.fxMinX() + 10> this.moveObject.x   ) 
					this.moveObject.x = this.fxMinX() + 10			
						
			if( this.dragFx != null ) this.dragFx();
			
			// Instruct Flash Player to refresh the screen after this event.
			// event.updateAfterEvent();
		}
		public var dragFx :  Function;
		
		/**
		 * Called when user lets off the titlebar 
		 * @param event
		 * @param fake - if this is from a canceling action, do not dispatch the moved event as content my try to save itself
		 * 
		 */
		public function titleBarDragDropHandler(event:MouseEvent, fake :  Boolean = false):void {
			//this.titleBar.removeEventListener(MouseEvent.MOUSE_MOVE, titleBarMoveHandler);
			if ( this.moveObject.stage == null ) 
				return; 

			this.finishCleanUpDrag()
			//if fake
			if ( fake == false ) 
				this.moveObject.dispatchEvent( new Event( EvtMovingState_Moved ) ) 
			//this.alpha = 1.0;
			//this.stopDrag();
			
			this.moveObject.dispatchEvent( new Event(  EvtMovingState_Exit ) ) 
				
		}
		
		/**
		 * Removes all listeners from dragging component 
		 * 
		 */
		public function dropMe()  : void
		{
			if ( this.moveObject.stage != null ) 
				this.moveObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, titleBarMoveHandler);
			Application.application.parent.removeEventListener(MouseEvent.MOUSE_UP, titleBarDragDropHandler);
			this.titleBar.removeEventListener(DragEvent.DRAG_DROP,titleBarDragDropHandler);				
		}
		/**
		 * Plz explalin this in english 
		 * */
		public function panelFocusCheckHandler():void {
			for (var i:int = 0; i < this.moveObject.parent.numChildren; i++) {
				var child:UIComponent = UIComponent(this.moveObject.parent.getChildAt(i));
				if (this.moveObject.parent.getChildIndex(child) < this.moveObject.parent.numChildren - 1) {
					/*	child.setStyle("headerColors", this.unfocusedColors);
					child.setStyle("borderColor", 0x686868);
					var ee : Object = this.getStyle('titleStyleName') 	;
					child.setStyle('titleStyleName',  this.normalTitleStyle )*/
				} 
				else if (this.moveObject.parent.getChildIndex(child) == this.moveObject.parent.numChildren - 1) {
					/*child.setStyle("headerColors",  this.focusedColors) 
					child.setStyle("borderColor", 0x686868);
					child.setStyle('titleStyleName',  this.selectedTitleStyle )*/
				}
			}
		}		
		
		
		public function titlebarMoveOverHandler(event:MouseEvent):void {
			//this.resizeCur = CursorManager.setCursor(resizeCursor);
			if ( CustomCursor.resizeCursorS != null ) 
				this.resizeCur = CursorManager.setCursor(CustomCursor.resizeCursorS, 2, -8 , -8);
		}
		
		public function titlebarMoveOutHandler(event:MouseEvent):void {
			CursorManager.removeCursor(CursorManager.currentCursorID);
		}		
		
		
		
	}
}