
package  org.syncon.onenote.onenotehelpers.base.others {
	import mx.controls.Button;
	
	import spark.components.Group;
	import spark.components.Panel;
	import spark.primitives.Rect;
	
	/********************************************
	 moveable panel 
	 ********************************************/
	public class SuperPanel3 extends   spark.components.Panel 
	{
		
		//declare button var
		private var newFormButton:Button;
		[SkinPart(required="true")]
		public var titleBar:Group;
		[SkinPart(required="false")]
		public var closeBtn:Rect;		
		[SkinPart(required="false")]
		public var resizablePanelArea:Group;
		
		public var moveablePanel : MoveablePanel = new  MoveablePanel()
		public var resizablePanel :  ResizablePanel = new  ResizablePanel()
		
		// add event listeners by overriding partAdded method
		override protected function partAdded(partName:String,instance:Object):void
		{
			// call super method
			super.partAdded(partName,instance);
			
			
			
			// now add listeners
			if ( instance == titleBar )
			{
				moveablePanel.registerTitleBar( this.titleBar );
			}
			if ( instance == resizablePanelArea )
			{
				resizablePanel.registerTitleBar( this.resizablePanelArea );
			}			
			
		}		
		
		
		/*
		
		private function doCreateForm(event:Event):void{
		//create an event - just an Alert for testing here
		mx.controls.Alert.show("Button Clicked");
		}
		//override the createChildren method with the properties I need
		protected override function createChildren():void{
		super.createChildren();
		//instantiate new button and assign properties
		newFormButton = new Button();
		newFormButton.label = "New";
		//add event listener for click event and call method
		newFormButton.addEventListener("click", doCreateForm);
		newFormButton.visible = true;
		//add the button to rawChildren
		this.addElement(newFormButton);
		}
		//update the display and get panel size - dynamic since the form can be resized
		protected override function updateDisplayList(unscaledWidth:Number,
		unscaledHeight:Number):void{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		//gap between label and edges of button
		var margin:int = 4;
		//set the button size + margin
		newFormButton.setActualSize(50 + margin, 16 + margin);
		//define vars which determine distance from right and top of Panel
		var pixelsRight:int = 25;
		var pixelsTop:int = -25;
		//define var to width of button
		var buttonWidth:int = newFormButton.width;
		//set x and y properties to be used for positioning of button
		var x:Number = unscaledWidth - buttonWidth - pixelsRight;
		var y:Number = pixelsTop;
		//position the button in the panel
		newFormButton.move(x, y);
		}
		*/
		public function SuperPanel3()
		{
			super();
			
			this.moveablePanel.registerMoveObject( this ) ; 
			this.resizablePanel.registerMoveObject(this ) 
		}
	}
}