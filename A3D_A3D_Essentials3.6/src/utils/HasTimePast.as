package utils
{
	
	
	public class   HasTimePast 
	{
		//[Transient] public var model : IssueTrackerModelLocator = IssueTrackerModelLocator.getInstance();
		
		//will return true if a certain amount of time has past since begining 
		
		public var doneFirstTime : Boolean = false
		public var waitTime :  Number = 1000 // milliseconds
		public var lastTime : Date
	
		public function HasTimePast( timeMilliseconds :  int)
		{
			this.waitTime = timeMilliseconds
			 this.doneFirstTime
		}
		
		/*
		sets the timer back to 0 
		*/
		public function resetTimer()  : void
		{
			this.lastTime = new Date(); 
		}
		
		public function hasTimePast( milliseconds : int = -1 )  : Boolean
		{
			//allow restrating 
			if ( this.doneFirstTime == false ) 
			{
				this.lastTime = new Date()
				this.doneFirstTime = true
				return true	
			}
			
			var currentTime : Date = new Date()
		
					//is the current tiem greater than the last tiem pluss 1 second? 
			var timeSinceLastSearch : Number = currentTime.getTime() -   lastTime.getTime()  
 
 			var waitTime_ : Number = waitTime
 			if ( milliseconds != -1 ) 
 				waitTime_ = milliseconds
 
 			
			if ( timeSinceLastSearch  >=  waitTime_    )
			{
				lastTime = new Date();
				return true
			}
   		return false			
			
		}
		
		static public function hasTimePast_Minutes( currentTime : Date, oldTime : Date, minutes : Number )  : Boolean
		{
			return HasTimePast.hasTimePast( currentTime, oldTime , minutes * 60  );
		}
		static public function hasTimePast_Seconds( currentTime : Date, oldTime : Date, seconds  : Number,  offsetSeconds : Number = 0)  : Boolean
		{
			return HasTimePast.hasTimePast( currentTime, oldTime , seconds, offsetSeconds  );
		}
				
		
		//send in seconds ... not milliseconds ... 
		static private function hasTimePast( currentTime : Date, oldTime : Date, secondsDifference : Number, offsetSeconds : Number = 0 )  : Boolean
		{
			if ( currentTime == null || oldTime == null ) 
			{
				Shelpers.traceS('a time in the comparison was null' )
				return true; 
			}
			var timeSinceLastSearch : Number = currentTime.getTime() -   oldTime.getTime()  
			timeSinceLastSearch = timeSinceLastSearch /1000 
 			timeSinceLastSearch +=   offsetSeconds // *1000) 
 			var waitTime : Number = secondsDifference
 
 			
			if ( timeSinceLastSearch  >=  waitTime    )
			{
			//	Shelpers.traceS( ' time was ', currentTime.getHours(), currentTime.getMinutes(), 
			//			currentTime.getSeconds() ) 
				return true
			}
   		return false						
		}
		
		
		static public function howManySecondsHavePast( currentTime : Date, oldTime : Date  )  : Number
		{
			var timeSinceLastSearch : Number = currentTime.getTime() -   oldTime.getTime()  
			timeSinceLastSearch = timeSinceLastSearch /1000 
			return timeSinceLastSearch; 			
		}
					
		
		public function restart()  : void
		{
			this.doneFirstTime = false
		}
	 
		
	}
}