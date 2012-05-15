/********************************************
 title   : MultipleSelection
 version : 1.5
 author  : M24 Veenstra
 website : http://www.wietseveenstra.nl
 date    : 2009-03-30
 * 
 * There are just 2 ins/and outs for this function
 * 
 ********************************************/
package org.syncon.onenote.onenotehelpers.base      
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flashx.textLayout.compose.IFlowComposer;
	import flashx.textLayout.compose.TextFlowLine;
	
	import mx.collections.ArrayCollection;
	import mx.controls.RichTextEditor;
	import mx.core.IUITextField;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.events.DragEvent;
	
	import spark.components.Group;
	import spark.components.HScrollBar;
	import spark.components.Label;
	import spark.components.RichEditableText;
	import spark.components.TextInput;
	import spark.components.VScrollBar;
	
	
	//import sss2.Onenote.views.OnenotePage.controller.events.MultipleSelectionEvent;
	
	use namespace mx_internal;
	
	/**
	 * Allow the selection of multiple textfields 
	 * 
	 * 
	 * registers all tfs 
	 * adds it's own event listeners for mouse over and dragging 
	 * 
	 * */
	public class QMultipleSelection extends EventDispatcher
	{
		/**
		 * Flag enables  the ability to select fields
		 * */
		private var _enableSelecting : Boolean = true;
		public function set  enableSelecting ( b : Boolean )  : void
		{
			this._enableSelecting = b;
			if ( b == false ) 
			{
				this.multipleClickMode = false
				//this.selectNoFields()
			}
		}
		/*public function get  enableSelecting () : Boolean 
		{
			return this._enableSelecting
		}		*/
		public function QMultipleSelection() {}
		
		/**
		 * ??? Flag is set to true while the user is selected values
		 * */
		public var multipleClickMode : Boolean = false; 	 	 	
		
		/**
		 * Returns true if textfield has any items selected
		 * */
		public function get itemsSelected()  : Boolean
		{
			return (this.selectedFields.length>0)
		} 	 	
		
		/**
		 *   Selects all the contents of a textfield 
		 * */
		public function selectAll( jj :  RichEditableText)  : void
		{
			if ( this._enableSelecting  == false ) 
				return; 
			//this.callLater( jj.selectRange, [ 0, jj.text.length] )			
			jj.selectRange(  0,  jj.text.length   )		
			//jj.verticalScrollPosition =0	
			this.addToSelectedFields( jj  ) 
		}			
		/**
		 * Select a portion of the text field
		 * */
		public function selectPortion( jj : RichEditableText, startIndex : int, endIndex : int )  : void
		{
			//trace('select potion', startIndex, endIndex ) ; 
			if ( this._enableSelecting  == false ) 
				return; 				
			jj.selectRange(  startIndex, endIndex   )		
			//this.callLater( jj.selectRange, [ startIndex, endIndex  ] )		
			/*		if ( endIndex != -1 && startIndex != endIndex ) 
			this.addToSelectedFields( jj  ) 	
			else
			{
			trace('skipped ' + jj + ' ' + jj.name + ' ' + startIndex + ' ' +  endIndex + ' ' + jj.parent.parent.visible )
			trace('skipped ' + jj.text  )
			if ( this.fxSelectEmptyItem != null ) 
			{
			if  (  fxSelectEmptyItem( jj ) )
			{
			this.addToSelectedFields( jj  ) 	
			}
			}
			}*/
			//jj.verticalScrollPosition =0	
		}					
		public function selectNone( jj : RichEditableText )  : void
		{
			//trace( 'select none' ); 
			//this.callLater( jj.selectRange, [ 0, 0] )	
			jj.selectRange( 0, 0) 
		}
		
		public function onTextAreaClickedBeforeDeselectText ( evt : MouseEvent )  : void
		{
			//trace('clicked ' + evt.currentTarget.selectionBeginIndex + ' ' + evt.currentTarget.selectionEndIndex ) 
		}			 
		
		/**
		 * Leaves 
		 * */
		public function onMouseUp( evt :  Event )  : void
		{
			this.multipleClickMode = false 	
		}
		public function onMouseAreaDrag( evt :  Event )  : void
		{
			//trace('dragger')
		}
		/***
		 * Stops further selecting
		 * */
		public function stopSelecting()  : void
		{
			this.multipleClickMode = false 
		}
		
		
		
		private function getCharAtPoint(textArea:Object, x:Number, y:Number,covertFromGlobalFisrt:Boolean=false) : int {
			if ( covertFromGlobalFisrt ) 
			{
				var localPoint : Point = textArea.globalToLocal( new Point(x, y) )
				x = localPoint.x
				y = localPoint.y 
			}
			
			//if coordinates are negative return 0 ; 
			if ( x < 0 || y < 0 ) 
				return 0; 
			
			var fc:IFlowComposer = textArea.textFlow.flowComposer;
			// a global point required to determine the atom index.
			var sPoint:Point = textArea.localToGlobal(new Point(x, y));
			
			for (var i:int = 0; i<fc.numLines; i++){ 
				// for each text flow line
				var l:TextFlowLine = fc.getLineAt(i);
				
				// check to see if the point is inside the line vertically
				if (y >= l.y && y < l.height+l.y){
					// get the position of the char in the line
					var lineAtomPosition:Number = l.getTextLine().getAtomIndexAtPoint(sPoint.x, sPoint.y);
					if (lineAtomPosition>= 0){
						// return if the position is valid
						return l.absoluteStart+lineAtomPosition+1;
					}
					if (x > l.unjustifiedTextWidth){
						// check to see if the point is greater than the width of the text
						return l.absoluteStart+l.textLength-1;
					}
					// otherwise return the start of the line
					return l.absoluteStart;
				}
			}
			//odd, returns whole line sometimes between lines ,f you aren't with 
			//10 px of bottom, do not reaturn whole thing ... 
			if ( y < textArea.height - 10 )
			{} //shouldn't return this, recalculate
			
			// if all else fails return the last position
			return textArea.text.length;
			
		}
		
		
		
		
		/**
		 * listen to  holder for click events to being approximating a drag , ususally an init fx
		 */
		public var stage : Stage; 
		/**
		 * Container, click events must happen within it 
		 * */
		public var addBoxTo : Group; 
		public var scroller : UIComponent
		public function listenTo( this_ :  Stage, addBoxTo_ : Group, bounds : UIComponent ) : void	
		{
			this.stage = this_
			this_.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDownHolder , false, 0, true) 
			
			this.addBoxTo = addBoxTo_
			this.scroller = bounds
			//add blue box, only to be used when user clicks on something that is not a textbox , and is on target
			this.blueBox = new  BlueMultipleSelectionBox
			addBoxTo.addElement( this.blueBox ) 
			
		}
		
		public function onMouseDownHolder( event :  MouseEvent )  : void
		{
			var dbg1 : Array  = [  ] 
				
			//clear all previously selected fields , be sure not to unselect the current one
			if ( isTextfieldBasedUI( event.target ) )
				this.unselectAll( this.selectedFields,event.target ) ; 
			
			var dbg : Array = [  isTargetAllowed( event.target )  ] 
			if ( isTargetAllowed( event.target ) == false  ){
				return; 	}
			if ( event.target.parent.parent is VScrollBar || event.target.parent.parent is  HScrollBar ) 
				return; 
			var ptCurrent : Point = new Point( event.stageX, event.stageY ) 
			if ( Utils.DoesPtOccurWithinComponent( ptCurrent, this.scroller ) == false ) 
				return; 
			//target must be a child of the gorup (selecting colors would trigger listening); 
			if (event.target != this.addBoxTo &&  this.isTargetAChildOfGroup( event.target ) == false ) 
				return; 
			this.ptStartDrag = ptCurrent
			//used to unselect entries, but wait until mouse moved 
			//was unselecting entries on mouseDown, when i was only trying to click 
				//the tf and clear the selection
			this.unselectEntriesOnNextMove = true; 
			this.unselectOldEntriesOnNextMove = this.selectedFields
			this.selectedFields = []; 
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove  , false, 0, true) 
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUpHolder  , false, 0, true) 
			//move blue selection, itis on add to group
			var ptTip : Point = this.addBoxTo.globalToLocal( ptCurrent ); 
			this.blueBox.x = ptTip.x
			this.blueBox.y = ptTip.y
			this.blueBox.visible = false; 
			//bring to front 
			this.addBoxTo.setElementIndex( this.blueBox, this.addBoxTo.numChildren-1 )
			//if started on intial tf, remember that 
			this.initialTf  = null; 
			if ( isAcceptableTf( event.target ) )
				this.initialTf = event.target as RichEditableText
			
			this.dispatchEvent(new QMultipleSelectionEvent(QMultipleSelectionEvent.SELECTING ) )
		}
		/**
		 * Look for property on Spark Like object, must be a better way ...
		 * */
		private function isTargetAllowed(target:Object, dupe : Boolean = false ):Boolean
		{
			if ( dupe && target == null ) return true; //incase there is no parent 
			if ( target.hasOwnProperty('blockMultipleSelection') && target.blockMultipleSelection == true ) 
				return false;

			if ( dupe ) return true;
			//becuase the stage has no parents
			if ( target == this.stage ) 
				return true; 			
			if ( isTargetAllowed(target.parent, true ) == false )
				return false;			
			if ( isTargetAllowed(target.parent.parent, true ) == false )
				return false;		
			if ( isTargetAllowed(target.parent.parent.parent, true ) == false )
				return false;						
			return true
		}
		
		private function isTargetAChildOfGroup(target:Object):Boolean
		{
			return this.isDescendent( target, this.addBoxTo ); 
		}		
		public function isDescendent( e :   Object , againsts :  Object )  :   Boolean 
		{
			var par :  Object = e; 
			do 
			{
				if ( par == null ) 
					return false; 
				par = par.parent //as UIComponent
				if ( par == againsts ) 
					return true
				
			}	while ( par.parent != null  )
			
			return false 
		}
		
		/**
		 * Make sure it existed on a class of partial? or has certain proprety 
		 * can send in base class for itemRenderer ...
		 * */
		private function isAcceptableTf(potentialUI:Object):Boolean
		{
			if ( potentialUI is RichEditableText ) //need some valid method
				return true 
			return false;
		}
		
		/**
		 * Anything capable of stealing focus should invalided all textfields .... 
		 * no quite ... only text things ... 
		 * */
		private function isTextfieldBasedUI(potentialUI:Object):Boolean
		{
			if ( potentialUI is RichEditableText || potentialUI is TextInput ) //need some valid method
				return true 
			return false;
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			if ( this.unselectEntriesOnNextMove )
			{
				this.unselectEntriesOnNextMove = false
				this.unselectAll( this.unselectOldEntriesOnNextMove ) ;
				this.draggingMode = true; 
			}
			var ptHighlightEnd : Point = new Point( event.stageX, event.stageY ) 
			var ptHighlightStart : Point = this.ptStartDrag.clone(); 
			var swapped : Boolean = false
			//var ptEnd : Point = this.addBoxTo.globalToLocal( ptCurrent ); 
			if ( ptHighlightStart.x >   ptHighlightEnd.x ) 
			{
				var swappedEnd : Number = ptHighlightEnd.x
				ptHighlightEnd.x = ptHighlightStart.x
				ptHighlightStart.x = swappedEnd 
				swapped= true					
			}
			if ( ptHighlightStart.y >   ptHighlightEnd.y ) 
			{
				swappedEnd = ptHighlightEnd.y
				ptHighlightEnd.y = ptHighlightStart.y
				ptHighlightStart.y = swappedEnd 
				swapped= true
			}		
			
			//only show blueBox if initial field not selected
			if ( this.initialTf == null ) 
			{
				var ptBBTL : Point = this.addBoxTo.globalToLocal( ptHighlightStart ); 
				var ptBBBR : Point = this.addBoxTo.globalToLocal( ptHighlightEnd  ); 
				var width : Number =  ptBBBR.x - ptBBTL.x
				//drag backwards 
				this.blueBox.x =  ptBBTL.x
				
				var height : Number = ptBBBR.y - ptBBTL.y
				this.blueBox.y = ptBBTL.y
				
				//var width : Number =  Math.max( ptEnd.x, this.ptStartDrag.x )  - Math.min( ptEnd.x, this.ptStartDrag.x ) 
				this.blueBox.width = width; //ptEnd.x - this.blueBox.x
				//var height : Number =  Math.max( ptEnd.x, this.ptStartDrag.x )  - Math.min( ptEnd.x, this.ptStartDrag.x ) 
				this.blueBox.height = height//ptEnd.y - this.blueBox.y
				
				this.blueBox.visible = true;
			}
			var foundTfs : Array = [];
			//var foundTfs : Array = this.getTfUnderPoint( new Point(currentX,ptCurrent.y) )
			//trace('onMouseMove', 'found', foundTfs.length, 'fields' )
			//make squar echedck every 10 pixels to end point ooooooooooo
			for ( var currentX : int = ptHighlightStart.x ; currentX < ptHighlightEnd.x; currentX=currentX+10 )
			{
				var ptSearch : Point = new  Point(currentX, ptHighlightEnd.y)
				//if swapped search above the top horizontal line, not the bottom
				if ( swapped ) ptSearch = new   Point(currentX,ptHighlightStart.y)
				//trace('searchingX',ptSearch.x, ptSearch.y )
				var found :Array  = this.getTfUnderPoint( ptSearch  )
				mergeArrays( found, foundTfs )
			}
			for ( var currentY : int = ptHighlightStart.y ; currentY < ptHighlightEnd.y; currentY=currentY+10 )
			{
				ptSearch = new  Point(ptHighlightEnd.x, currentY)
				if ( swapped ) ptSearch = new   Point(ptHighlightStart.x, currentY)
				//trace('searchingY',ptSearch.x, ptSearch.y )
				found = this.getTfUnderPoint( ptSearch )
				mergeArrays( found, foundTfs )				
			}			
			
			//before you merge, remove any selectedFields that are nolonger valid 
			var removedCount : int = 0; 
			for each ( var tf : Object in selectedFields ) 
			{
				var index : int = this.selectedFields.indexOf( tf ) 
				var tfTL : Point = tf.localToGlobal( new Point(0,0)) 
				var tfBR : Point = tf.localToGlobal( new Point(tf.width,tf.height)) 
				if (  ptHighlightEnd.x < tfTL.x )
				{
					this.selectNone( tf as RichEditableText ); 
					this.selectedFields.splice( index, 1);
					removedCount++
					continue // do not try same index twice
				}
				if (  ptHighlightEnd.y < tfTL.y )
				{
					this.selectNone( tf as RichEditableText ); 
					this.selectedFields.splice( index, 1);		
					removedCount++
				}
				if (  ptHighlightStart.x > tfBR.x )
				{
					this.selectNone( tf as RichEditableText ); 
					this.selectedFields.splice( index, 1);
					removedCount++
					continue // do not try same index twice
				}
				if (  ptHighlightStart.y > tfBR.y )
				{
					this.selectNone( tf as RichEditableText ); 
					this.selectedFields.splice( index, 1);		
					removedCount++
				}				
			}
			
			mergeArrays( foundTfs, selectedFields  )		
			//trace('onMouseMove', 'found', foundTfs.length, 'fields', 'removed', removedCount,  'total', selectedFields.length )
			//add them if not in track 
			
			//when new one added, grab list references
			//draw blue box 
			this.selectFieldsBasedOnBounds( selectedFields, ptHighlightStart, ptHighlightEnd,  this.initialTf )
		}
		
		private function mergeArrays(fromArray:Array, intoArray:Array):void
		{
			if ( fromArray.length == 0 ) 
				return; 
			
			for each ( var obj : Object in fromArray ) 
			{
				if ( intoArray.indexOf( obj ) == -1 ) 
					intoArray.push(obj)
			}
		}
		/**
		 * Terminates dragging early, there was an issue 
		 * when onenote lister was dragged and it created an 
		 * erroneous blue box
		 * */
		public function cancelDragging() : void
		{
			//remove esc .... onenote doesn't stop that 
			//
			this.endDrag()
		}
		private function getTfUnderPoint(pt:Point):Array
		{
			var found : Array = this.stage.getObjectsUnderPoint( pt )
			var filtered : Array = [];
			for each ( var potentialUI : Object in found ) 
			{
				if ( this.isAcceptableTf( potentialUI ) ) //need some valid method
					filtered.push(potentialUI)
			}
			return filtered;
		}
		
		/**
		 * Cleans up references
		 * */
		private function endDrag() : void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove );//  , false, 0, true) 
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUpHolder );
			
			this.blueBox.visible = false; 
		}
		public function onMouseUpHolder( evt :  MouseEvent )  : void
		{
			this.endDrag(); 
			this.draggingMode = false; 
			//if point is on same place...//it is annoying to lose places we 
			if ( this.ptStartDrag.x == evt.stageX && this.ptStartDrag.y == evt.stageY ) 
			{
				//trace('QMultipleSelection','onMouseUpHolder', 'canceled b/c on same place');
				return; 
			}
			//give focus sto the selected field with highest x and y values ... if initialfeild was not clicked
			if ( this.initialTf == null )
			{
				var firstTfOnXY	: Object			
				for each ( var tf : Object in selectedFields ) 
				{
					if ( firstTfOnXY == null ) firstTfOnXY = tf
					if ( firstTfOnXY.y > tf.y || firstTfOnXY.x > tf.x )
					{
						if ( (firstTfOnXY.x+ firstTfOnXY.y) > (tf.x+ tf.y) ) 
							firstTfOnXY = tf;
					}
				}
				if (firstTfOnXY != null ) 
					firstTfOnXY.setFocus(); 
			}
			
			
			//this.multipleClickMode = false
			this.addBoxTo.callLater( this.dispatchEvent, [new QMultipleSelectionEvent(QMultipleSelectionEvent.SELECTED,this.selectedFields ) ]) 
		}
		
		public function setEnable( enabled : Boolean, evt : MouseEvent )  : void
		{
			/*if ( enabled ) 
			{
			this.onMouseDown( evt ) 
			}
			else
			{
			this.onMouseUp( evt ) 
			}*/
		}
		/**
		 * unselect based on arrInput 
		 * */
		public function unselectAll( arr :   Array, skipField:Object=null )  : void
		{
			//this.resetFields()
			for each ( var textField : RichEditableText in arr ) 
			{
				if ( skipField == textField ) 
					continue; 
				this.selectNone( textField ) 
			}
			this.selectedFields = []
			//this.postSelectedFields()
		} 	 	 		
		
		/**
		 * Select based on bounds ...
		 * */
		public function selectFieldsBasedOnBounds( arr :   Array, pt1: Point, pt2 : Point,  skipField:Object=null )  : void
		{
			for each ( var tf : RichEditableText in arr ) 
			{
				if ( skipField == tf ) 
					continue; 
				//skip if are all covered 
				var draggingUp :Boolean
				//if up , 
				//this.selectNone( textField ) 
				var indexStart : int = getCharAtPoint(tf, pt1.x, pt1.y, true ) 
				var indexEnd : int = getCharAtPoint(tf, pt2.x, pt2.y, true ) 
				if ( debug ) 
				{
				trace( 'pt1', pt1, indexStart ) ; 
				trace( 'pt2', pt2, indexEnd ) ; 			
				}
				this.selectPortion(tf, indexStart, indexEnd ); 
			}
		} 	 	 				
		
		
		/**
		 * Opt. fx closure to be called when font is selected
		 * */
		public var fxPostFields : Function = null; 
		public function postSelectedFields()  : void
		{
			//if (  this.reselectInitial   ) ; 
			this.fxPostFields( this.selectedFields ) 
			//this.dispatchEvent( new MultipleSelectionEvent(MultipleSelectionEvent.SELECTED, this.selectedFields) ) 
		}
		/**
		 * Array contains list of selected items. 
		 * Uses the fxGetItemForTf to convert the textfield into something more relevant
		 * like the data object the textfield is displaying
		 * */
		public var selectedFields : Array = []; 
		public function addToSelectedFields(  field :  Object )  : void
		{
			if ( this.fxGetItemForTf != null ) 
				field = this.fxGetItemForTf( field )
			this.selectedFields.push( field  ) 
		}
		public function resetFields() : void
		{
			this.selectedFields = []
		}
		/**
		 * Converts a n item into a textfield,  
		 * so ...
		 * */
		public var fxGetItemForTf : Function ;  	 	
		/**
		 * When selecting an item that might be empty ... 
		 * will send it here 
		 * */
		public var fxSelectEmptyItem : Function;
		private var blueBox: BlueMultipleSelectionBox;
		public function doesBoxIntersectBlueBox(ui : UIComponent):Boolean
		{
			var selection : Rectangle  = this.uiToRect(this.blueBox )  ;
			var box : Rectangle = this.uiToRect(ui); 
			return selection.intersects( box ) 
		}
		
		private function uiToRect(blueBox:UIComponent):Rectangle
		{
			return 	new Rectangle(blueBox.x, blueBox.y, blueBox.width, blueBox.height );
		}
		private var ptStartDrag:Point;
		private var initialTf: RichEditableText;
		private var debug:Boolean=false;
		/**
		 * Fix for erroneous unselecting
		 * wait untiluser moves mouse to unselect the old selected entries
		 * */
		private var unselectEntriesOnNextMove:Boolean;
		private var unselectOldEntriesOnNextMove:Array;
		private var _draggingMode:Boolean=false;

		/**
		 * TRue when user is draggin g
		 * */
		public function get draggingMode():Boolean
		{
			return _draggingMode;
		}

		/**
		 * @private
		 */
		public function set draggingMode(value:Boolean):void
		{
			_draggingMode = value;
			if ( value ) 
				this.dispatchEvent( new QMultipleSelectionEvent(QMultipleSelectionEvent.DRAG_START,this.selectedFields )  )
			else
				this.dispatchEvent( new QMultipleSelectionEvent(QMultipleSelectionEvent.DRAG_END,this.selectedFields )  )					
		}
		
		
	}
}