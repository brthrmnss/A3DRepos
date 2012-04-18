package
{
	import chp13.CollisionDemo;
	
	import flash.display.Sprite;
	
	public class Main extends Sprite
	{
		public function Main()
		{
			this.addChild( new CollisionDemo()  ) ; 
		}
	}
}