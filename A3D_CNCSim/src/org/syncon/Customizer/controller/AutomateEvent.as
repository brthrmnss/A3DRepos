package   org.syncon.Customizer.controller
{
	
	import flash.events.Event;
	
	import org.syncon.TalkingClock.vo.LessonVO;
	
	public class AutomateEvent extends Event
	{
		public static const START_LESSON:String = 'startLesson';
		public static const NEXT_LESSON:String = 'NEXT_LESSON';
		
		public var lesson : LessonVO;
		public var confirmed : Boolean = false;
		
		public function AutomateEvent(type:String   , lesson :  LessonVO, confirmed : Boolean = false ) 
		{	
			this.lesson = lesson
				this.confirmed = confirmed
			super(type, true);
		}
		
		
	}
}