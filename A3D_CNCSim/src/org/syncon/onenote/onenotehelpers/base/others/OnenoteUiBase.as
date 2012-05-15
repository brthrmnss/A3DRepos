package  org.syncon.onenote.onenotehelpers.base.others
{
	import mx.collections.ArrayCollection;
	
	import sss.Shelpers.Shelpers.ShelpersUI_Part2;
 
	/**
	 * Displays lists in their various forms
	 * */
	public class  OnenoteUiBase extends    SuperPanel3 
	{
		//public var onenoteModel :  OnenoteViewerModelV2 ; // = OnenoteModel.getInstance()		
		/**
		 * Contains list that ui is displaying
		 * **/
	//	private var _list : ListVO = new  ListVO()
		/**
		 * Flag indicates weather default data shoudl be made fo rtesting
		 * */
		public var initDummyData : Boolean = false;
		
		[Bindable] public var dp  :   ArrayCollection = new ArrayCollection()//.getInstance(); 
		
		//[Bindable] public var dp  :     ArrayList = new ArrayList()//.getInstance(); 
		
		
		public function OnenoteUiBase() {}
		
 
/*		
		public function set list ( l : ListVO )  : void
		{
			this._list = l
			
		}
		public function get list()  : ListVO
		{
			return this._list
		}	*/ 
		
		public function get blank ()  : Boolean
		{
			return true; 
		} 
 
		
		/**
		 * Overridden by subclass
		 * Will update the display as if new information has been  pushed in
		 * */
		public function updateDisplay() : void {}
		
 
		
		
		public function get isMouseOverMe() : Boolean
		{
			return ShelpersUI_Part2.isUserOverMe( this )
		}  	
		
		public function get currentLayout ()  : OnenoteUiBase {
			 return null; //catch this error further up the tree 
		//	return this.onenoteModel.uiModel.currentLayout 
		} ; //onenoteModel.uiModel.currentLayout }		  
		
		public function hideBorder() : void {}
		public function showBorder()  : void {}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}