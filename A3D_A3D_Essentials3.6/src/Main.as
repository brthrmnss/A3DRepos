package
{
	import Chapter06.Hinge;
	import Chapter06.Square;
	import Chapter06.Triangle;
	import Chapter06.VerletPointTest;
	import Chapter06.VerletStickTest;
	
	import Chapter2Source.CompareSprite3DTriMesh;
	import Chapter2Source.PrimitivesDemo;
	
	import Chapter3Source.GroupingExample;
	import Chapter3Source.TweeningExample;
	
	import Chapter6Source.MD2EmbeddedDemo;
	import Chapter6Source.MD2ExternalDemo;
	
	import Chapter7Source.CameraDemo;
	import Chapter7Source.CameraPropertiesDemo;
	
	import chp1.SphereDemo;
	
	import flash.display.Sprite;
	import Chapter06.Square2;
	
	public class Main extends Sprite
	{
		public function Main()
		{
			//this.addChild( new SphereDemo() ); 
			
			//this.addChild( new PrimitivesDemo() ); 
			var s : Sprite = new CompareSprite3DTriMesh(); 
			s = new PrimitivesDemo()
			s = new GroupingExample(); 
			s = new TweeningExample(); 
			s = new MD2EmbeddedDemo(); 
			s = new MD2ExternalDemo(); 
			s = new CameraPropertiesDemo()
			s = new CameraDemo()
			/*
			s = new VerletPointTest()
			s = new VerletStickTest()
			s  = new Triangle(); 
			s  = new Square(); 
			s = new Hinge()
				s = new Square2()
					*/
			this.addChild( s  ); 
		}
	}
}