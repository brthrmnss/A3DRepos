package  org.syncon2.utils.services.utils
{
	
	
	
	
	
	/**
	 *
	 * */
	public class GetDivParser  
	{
		public function get(html : String, starter : String ):String
		{
			var find : String =starter
			var  dbg : Array =[html.indexOf(starter)]//, data.indexOf(end) ] ; 
			
			var cut : String = html.slice( dbg[0], html.length ) ; 
			//remove any <div/> or <div />
			/*var pattern:RegExp = new RegExp("<div />", 'gi' ) 
			cut = cut.replace( pattern, '' ) ; 
			pattern = new RegExp("<div/>", 'gi' ) 
			cut = cut.replace( pattern, '' ) ; */
			var split :  Array = cut.split ('</div>'); 
			var endDiv : String = '</div>';
			var opened : int = 1 
			var openDiv : String = '<div'; 
			for ( var i : int = 0 ; i < split.length ; i++ ) 
			{
				var slice : String = split[i]; 
				if ( i == 0 ) 
				{
					var firstIndex : int = slice.indexOf( openDiv ); 
					var secIndex : int = slice.indexOf( openDiv, 1 )  ;
					//if  opened here only once ... 
					if ( firstIndex != -1 && secIndex == -1 )
					{
						return split.slice( 0, i+1 ).join( endDiv  )+endDiv
					}
					//continue; 
				}
				opened--
				
				if ( slice.indexOf('<div' ) != -1  ) 
				{
					opened++	
				}
				
				if ( opened == 0 ) 
				{
					var finished : String = split.slice( 0, i+1 ).join( endDiv  )
					return finished+endDiv; 
				}
				
			}
			
			return '' 
		}
		/**
		 * More straight forward,
		 * get contents between two markers 
		 * */
		public function getContentBetween(html : String, starter : String, end : String ):String
		{
			var find : String =starter
			var  dbg : Array =[html.indexOf(starter)]//, data.indexOf(end) ] ; 
			var firstIndex : int = html.indexOf(starter)
			var cut : String = html.slice( dbg[0]+starter.length, html.length ) ; 
			
			var secIndex : int = cut.indexOf( end, 1 )  ;
			//var secIndexB : int = cut.indexOf( end, firstIndex ) //makes no sense, we have cut already 
			var output : String = cut.slice( 0, secIndex ); 
			
			return output
		}
		
		
		
	}
}