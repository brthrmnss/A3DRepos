package  org.syncon2.utils.mobile.ui
{
	
	import mx.containers.ViewStack;
	import mx.effects.Fade;
	import mx.effects.Move;
	import mx.effects.Parallel;
	import mx.events.FlexEvent;
	
	public class ScreenStackHelpers 
	{
		static public function removeScrollbars( holder :   ViewStack    ) : void
		{
			
			var duration : Number = 350
			for   ( var i : int = 0; i <  holder.numChildren; i++ ) 
			{
				var o : Object = holder.getChildAt( i ) 
				o.setStyle('horizontalScrollPolicy', 'off' ) ; 
				o.setStyle('verticalScrollPolicy', 'off' ) ; 		
				o.clipContent = false; 
			}
		}
		
		static public function setFxOnViewStack( holder :   ViewStack, width : Number   ) : void
		{
			
			var duration : Number = 350
			for   ( var i : int = 0; i <  holder.numChildren; i++ ) 
			{
				var o : Object = holder.getChildAt( i ) 
				var m : Move = new Move(o); 
				m.xFrom =  width; 
				m.xTo = 0 ; 
				m.yFrom = 0; 
				m.yTo = 0 ; 
				//o.setStyle('showEffect',   m ) ;  
				m.duration = duration 
				
				var f1 : Fade = new Fade()
				f1.alphaFrom =0; 
				f1.alphaTo = 1; 
				f1.duration = duration 
				var p1 : Parallel		= new Parallel()
				p1.duration = duration 
				p1.children = [ m, f1 ] 
				o.setStyle('showEffect',   p1 ) ;  
				
				
				
				//this.view.showEffect = m
				var m2 : Move = new Move(o); 
				m2.xFrom = 0;//this.width; 
				m2.xTo = -width ; 
				m2.duration = duration 
				m2.yFrom = 0; 
				m2.yTo = 0 ; 
				//o.setStyle('hideEffect',   m2 ) ;  
				
				var f2 : Fade = new Fade()
				f2.alphaFrom = 1; 
				f2.alphaTo = 0; 
				f2.duration = duration 
				var p2 : Parallel		= new Parallel()
				p2.duration = duration 
				p2.children = [ m2, f2 ] 
				o.setStyle('hideEffect',   p2 ) ;  
				
			}
		}
		
		static public function   blank(duration:Number = 350) : Object
		{
			var f2 : Fade = new Fade()
			f2.alphaFrom = 1; 
			f2.alphaTo = 0; 
			f2.duration = duration 
			return f2
		}
		
		public static function setFxOnViewStackWipe(items:Array, height:Number):void
		{
			var duration : Number = 350
			for   ( var i : int = 0; i <  items.length; i++ ) 
			{
				var o : Object =items[i]
				var m : Move = new Move(o); 
				m.xFrom =  0; 
				m.xTo = 0 ; 
				m.yFrom = height; 
				m.yTo = 0 ; 
				//o.setStyle('showEffect',   m ) ;  
				m.duration = duration 
				
				var f1 : Fade = new Fade()
				f1.alphaFrom =0; 
				f1.alphaTo = 1; 
				f1.duration = duration 
				var p1 : Parallel		= new Parallel()
				p1.duration = duration 
				p1.children = [ m]//, f1 ] 
				o.setStyle('showEffect',   p1 ) ;  
				
				
				
				//this.view.showEffect = m
				var m2 : Move = new Move(o); 
				m2.xFrom = 0;//this.width; 
				m2.xTo = -0 ; 
				m2.duration = duration 
				m2.yFrom = 0; 
				m2.yTo = height ; 
				//o.setStyle('hideEffect',   m2 ) ;  
				
				var f2 : Fade = new Fade()
				f2.alphaFrom = 1; 
				f2.alphaTo = 0; 
				f2.duration = duration 
				var p2 : Parallel		= new Parallel()
				p2.duration = duration 
				p2.children = [ m2]//, f2 ] 
				o.setStyle('hideEffect',   p2 ) ;  
				
			}
		}
	}
}