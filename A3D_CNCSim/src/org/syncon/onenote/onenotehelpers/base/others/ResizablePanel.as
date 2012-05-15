package  org.syncon.onenote.onenotehelpers.base.others
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	
	
	
	public class ResizablePanel
	{
		public var snapToGrid: Boolean = false; 
		public var minWidth : Number  = 300
		public var maxWidth : Number =  NaN
		public var minHeight : Number = NaN
		public var maxHeight : Number = NaN
		static public var EvtMovingState_Entered : String = 'Moving Stated Entered'
		static public var EvtMovingState_Exit : String = 'Moving Stated Exit'
		static public var EvtMovingState_Moved  : String = 'EvtMovingState_Moved' 
		/**
		 * Stores starting x valu e
		 * */
		private var xOriginal:Number;
		private var yOriginal:Number;			
		private var offsetX:Number;
		private var offsetY:Number;			
		
		private var oW:Number;
		private var oH:Number;
		private var oX:Number;
		private var oY:Number;
		
		private var oPoint: Point 			= new Point();		
		
		public var enableHorizontalResize : Boolean = true; 
		public var enableVertcialResize : Boolean = true; 	
		
		public var enableHorizonalMovement : Boolean = true
		public var enableVerticalMovement : Boolean = true				
		private static var resizeCursor:Class;
		public var useCustomCursor : Boolean = false; 
		private var resizeCur:Number		= 0;			
		public var dragging : Boolean = false; 
		
		public var resizeHandler:UIComponent;
		
		public var moveObject : UIComponent; 
		// add event listeners by overriding partAdded method
		public function registerTitleBar(titleBar:UIComponent):void
		{
			this.resizeHandler = titleBar; 
			
			this.resizeHandler.addEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler, false, 0, true ) 
			this.resizeHandler.addEventListener(MouseEvent.MOUSE_OUT, resizeOutHandler, false, 0, true ) 
			this.resizeHandler.addEventListener(MouseEvent.MOUSE_DOWN, resizeDownHandler, false, 0, true ) 
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
			//this.titleBar.removeEventListener(MouseEvent.MOUSE_MOVE, titleBarMoveHandler);
			this.bringToFront()
			
			this.panelFocusCheckHandler();
		}		
		
		
		
		public function resizeOverHandler(event:MouseEvent):void {
			if ( this.useCustomCursor ) 
				this.resizeCur = CursorManager.setCursor(CustomCursor.resizeCursorS);
		}
		
		public function resizeOutHandler(event:MouseEvent):void {
			CursorManager.removeCursor(CursorManager.currentCursorID);
			this.resizeCur = 0; 
		}
 
		public function resizeDownHandler(event:MouseEvent):void {
			Application.application.parent.addEventListener(MouseEvent.MOUSE_MOVE, resizeMoveHandler);
			Application.application.parent.addEventListener(MouseEvent.MOUSE_UP, resizeUpHandler);
			this.resizeHandler.addEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler);
			this.panelClickHandler(event);
			if ( this.useCustomCursor ) 
				this.resizeCur = CursorManager.setCursor(resizeCursor);
			this.oPoint.x = this.moveObject.mouseX;
			this.oPoint.y = this.moveObject.mouseY;
			this.oPoint = this.moveObject.localToGlobal(oPoint);		
			this.initPos()
		}
		
		
		
		public function resizeMoveHandler(event:MouseEvent):void {
			//this.stopDragging(); ///wtf does this do? something by componet 
			this.moveObject.stopDrag(); 
			
			var xPlus:Number = Application.application.parent.mouseX - this.oPoint.x;			
			var yPlus:Number = Application.application.parent.mouseY - this.oPoint.y;
			
			if (this.oW + xPlus > 140  && enableHorizontalResize ) 
			{
				//this.moveObject.width = this.oW + xPlus;
				/*
				this.moveObject.width = SnapToGrid.snapToGridHelper( this.oW + xPlus + this.moveObject.x, -3+6,
							360/2,  360 , false, 360-6, this.snapToGrid) - this.moveObject.x //set min
				*/
				 var newWidth : Number = SnapToGrid.snapToGridHelper( this.oW + xPlus + this.moveObject.x, -3+6,
					360/2,  360 , false, this.minWidth, this.maxWidth,  this.snapToGrid) - this.moveObject.x //set min		
				 newWidth = SnapToGrid.limitToRange( newWidth, this.minWidth, this.maxWidth )
				 this.moveObject.width = newWidth; 
			}
			
			if (this.oH + yPlus > 80 && enableVertcialResize ) 
			{
				//this.moveObject.height = this.oH + yPlus;
				
				var newHeight : Number = SnapToGrid.snapToGridHelper( this.oH + yPlus + this.moveObject.y,   3 , 
					160/2, 160, false, this.minHeight, this.maxHeight,  this.snapToGrid ) - this.moveObject.y //set min
				newHeight = SnapToGrid.limitToRange( newHeight, this.minHeight, this.maxHeight )
				this.moveObject.height = newHeight; 					
				//this.moveObject.height = SuperPanel.snapToValueHelper( this.moveObject.height  , 204+3, this.y+this.moveObject.height, 10 ) // false, 160 ) //set min
				//Shelpers.traceS('verticalResize', this.oH,  yPlus, 'to', this.moveObject.height ) 
			}
			this.positionChildren();
		}
		
		
		
		public function resizeUpHandler(event:MouseEvent):void {
			Application.application.parent.removeEventListener(MouseEvent.MOUSE_MOVE, resizeMoveHandler);
			Application.application.parent.removeEventListener(MouseEvent.MOUSE_UP, resizeUpHandler);
			CursorManager.removeCursor(CursorManager.currentCursorID);
			this.resizeHandler.addEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler);
			this.positionChildren();
			this.windowResized(null)
		}
		public var newSizeFx : Function
		public function windowResized(e : Event )  : void
		{
			this.positionChildren()
			//resize children, account for header height
			if ( newSizeFx != null ) newSizeFx( this.moveObject.width, this.moveObject.height-22 - 4 ) 
						
		}
		
		
		public function initPos():void {
			this.oW = this.moveObject.width;
			this.oH = this.moveObject.height;
			this.oX = this.moveObject.x;
			this.oY = this.moveObject.y;
		}
				
		
		public function positionChildren():void {
	/*		if (showControls) {
				this.normalMaxButton.buttonMode    = true;
				this.normalMaxButton.useHandCursor = true;
				this.normalMaxButton.x = this.unscaledWidth - this.normalMaxButton.width - 24;
				this.normalMaxButton.y = 8;
				this.closeButton.buttonMode	   = true;
				this.closeButton.useHandCursor = true;
				this.closeButton.x = this.unscaledWidth - this.closeButton.width - 8;
				this.closeButton.y = 8;
			}
			
			if (enableResize) {
				this.resizeHandler.y = this.unscaledHeight - resizeHandler.height - 1 - 1;
				this.resizeHandler.x = this.unscaledWidth - resizeHandler.width - 1;
				var cihld  :  Object = this.getChildAt(0 ) 
				if ( cihld != null && cihld.hasOwnProperty('scrollBarVisible') && cihld.scrollBarVisible )// != null && cihld.verticalScrollBar != null &&  cihld.verticalScrollBar.visible )
					this.resizeHandler.x = this.unscaledWidth - resizeHandler.width - 1 - 18 - 1;
				
			}*/
		}
		/**
		 * If esc pressed an currently moving, leave moving mode
		 * */
		public function onKeyUp( e:   KeyboardEvent) : void
		{
			if ( e.keyCode == Keyboard.ESCAPE   ) 
			{
				//this.cancelDrag()
			}  						
		}		
		
	/*	
		
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
 
		}		*/
/*		
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
		}*/
/*		
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
				//this.startDrag(false, new Rectangle(0, 0, screen.width - this.moveObject.width, screen.height - this.moveObject.height));
			}
		}*/
		
		public function bringToFront() : void
		{
			return;
			try {
				this.moveObject.parent.setChildIndex(this.moveObject, this.moveObject.parent.numChildren - 1);
			}
			catch ( e : Error ) 
			{
				//this.moveObject.parentDocument
				moveObject.depth = g.numElements -1
				//(this.moveObject.parent as Object).setElementIndex(this.moveObject, this.moveObject.parent.numChildren - 1 )
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
/*		public function titleBarDragDropHandler(event:MouseEvent, fake :  Boolean = false):void {
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
				
		}*/
		
		/**
		 * Removes all listeners from dragging component 
		 * 
		 */
	/*	public function dropMe()  : void
		{
			if ( this.moveObject.stage != null ) 
				this.moveObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, titleBarMoveHandler);
			Application.application.parent.removeEventListener(MouseEvent.MOUSE_UP, titleBarDragDropHandler);
			this.titleBar.removeEventListener(DragEvent.DRAG_DROP,titleBarDragDropHandler);				
		}
	 
		public function panelFocusCheckHandler():void {
			for (var i:int = 0; i < this.moveObject.parent.numChildren; i++) {
				var child:UIComponent = UIComponent(this.moveObject.parent.getChildAt(i));
				if (this.moveObject.parent.getChildIndex(child) < this.moveObject.parent.numChildren - 1) {
			 
				} 
				else if (this.moveObject.parent.getChildIndex(child) == this.moveObject.parent.numChildren - 1) {
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
		
		*/
		
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
		
	}
}