package org.syncon2.utils.itemRenderer
{
	
	
	public class ItemRendererHelpers
	{
		public var _this:Object; 
		public function ItemRendererHelpers(this_ : Object ) 
		{
			this._this = this_
		}
		public function clearSelectedState()  : void
		{
			
		}
		public var oldValue : Object ; 
		public function listenForObj( value :   Object, evType : String, fx : Function)  : void
		{
			
			if (oldValue != null)  
			{
				oldValue.removeEventListener( evType,fx ) 
			}			
			oldValue = value
			if (value== null)  
			{
				//this.filter.removeEventListener( LessonVO.UPDATED,fx,false, 0, true ) 
			}
			if ( value != null ) 
			{
				value.addEventListener( evType,fx,false, 0, true ) 
			}
		}		
		
		
		public function disableIfNull( value :   Object, newVal : Object, str:  String)  : void
		{
			if ( value == null ) 
			{
				_this[str]= newVal
				this._this.enabled = false; 
				//	this.s.listenForObj_Break() 
			}
			else
			{
				this._this.enabled = true
			}
		}		
		
		/**
		 * Can refer to atrbitrary UI element, not _this
		 * */
		public function disableIfNull_DifferentUi( value :   Object, ui : Object)  : void
		{
			if ( value == null ) 
			{
				ui.enabled = false; 
				//	this.s.listenForObj_Break() 
			}
			else
			{
				ui.enabled = true
			}
		}	
		
		//this suld be seprate 
		/*	
		
		public function setupParent( p : Object ) : void
		{
			this.arr.arr1 = p.dataProvider; 
		}
	
		public var arr : ArrayListMoveableHelper = new ArrayListMoveableHelper(); 
		private var oldUp:Button;
		private var oldDown:Button;
		private var oldRemove:Button;		
		public function fxSetup( up : Button, down  : Button, remove : Button ) : void
		{
			if ( up != oldUp && oldUp != null ) 
			{
				oldUp.removeEventListener( MouseEvent.CLICK, this.onUp ) ;
			}
			up.addEventListener( MouseEvent.CLICK, this.onUp, false, 0, true ) ;
			this.oldUp = up
				
			if ( down != oldDown && oldDown != null ) 
			{
				oldDown.removeEventListener( MouseEvent.CLICK, this.onUp ) ;
			}
			down.addEventListener( MouseEvent.CLICK, this.onDown, false, 0, true ) ; 
			this.oldUp = down
				
			if ( remove != oldRemove && oldRemove != null )  
			{
				oldRemove.removeEventListener( MouseEvent.CLICK, this.onUp ) ;
			}
			remove.addEventListener( MouseEvent.CLICK, this.onRemove, false, 0, true ) ; 
			this.oldRemove = remove
		}	
		
		protected function onUp(event:MouseEvent):void
		{
			this.arr.trypToMoveUp( this._this.data ) ; 
		}
		protected function onDown(event:MouseEvent):void
		{
			this.arr.trypToMoveDown( this._this.data ) ; 
		}
		
		protected function onRemove(event:MouseEvent):void
		{
			this.arr.trypToRemove( this._this.data ) ; 
		}
		
		 
		*/

		
	}
}