package com.roguedevelopment.objecthandles
{
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	
	import spark.core.SpriteVisualElement;
	
	/**
	 * A handle class based on SpriteVisualElement which is suitable for adding to
	 * a Flex 4 Group based container.
	 **/
	public class VisualElementHandleRotate extends SpriteVisualElement implements IHandle
	{
		
		private var _descriptor:HandleDescription;		
		private var _targetModel:Object;
		protected var isOver:Boolean = false;
		
		//private var img : Image ; 
		private var img : Image = new Image();
		public function get handleDescriptor():HandleDescription
		{
			return _descriptor;
		}
		public function set handleDescriptor(value:HandleDescription):void
		{
			_descriptor = value;
		}
		public function get targetModel():Object
		{
			return _targetModel;
		}
		public function set targetModel(value:Object):void
		{
			_targetModel = value;
		}
		
		public function VisualElementHandleRotate()
		{
			super();
			addEventListener( MouseEvent.ROLL_OUT, onRollOut );
			addEventListener( MouseEvent.ROLL_OVER, onRollOver );
			img.addEventListener( MouseEvent.ROLL_OUT, onRollOut );
			img.addEventListener( MouseEvent.ROLL_OVER, onRollOver );
			img.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			//img.addEventListener( MouseEvent.MOUSE_UP, onRollOver );
			// img  = new Image()
			img.source = 'assets/images/14_rotate.png'
			this.addChild( img ) 
			this.useHandCursor = true
			this.buttonMode = true;
			img.smoothBitmapContent = true; 
			img.width = 22
			img.height = 22; 
			img.x = -img.width/2
			img.y = -img.height/2
			//redraw();
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			this.dispatchEvent( new MouseEvent(MouseEvent.MOUSE_DOWN,true,  false, event.localX, event.localY  ) ) ; 
			// TODO Auto-generated method stub
			
		}
		
		protected function onRollOut( event : MouseEvent ) : void
		{
			isOver = false;
			redraw();
		}
		protected function onRollOver( event:MouseEvent):void
		{
			isOver = true;
			redraw();
		}
		
		public function redraw() : void
		{
			if( isOver )
			{
				this.img.alpha = 0.6; 		
			}
			else
			{
				this.img.alpha = 1; 		
			}
			return
			
			graphics.clear();
			if( isOver )
			{
				graphics.lineStyle(1,0x3dff40);
				graphics.beginFill(0xc5ffc0	,1);				
			}
			else
			{
				graphics.lineStyle(1,0)//0xa4a4a4)// 0xc7c7c7 );
				graphics.beginFill(0xdfdfdf,1);
			}
			
			graphics.drawRect(-3,-3,6,6);
			graphics.endFill();
			
			graphics.drawRect(-3,-3,6,6);
			graphics.endFill();
			
			
		}
	}
}