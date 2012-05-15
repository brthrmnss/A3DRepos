package utils
{
	import away3d.cameras.Camera3D;
	
	public class SlerpCam extends Camera3D
	{
		public var slerp:Number=0;
		public function SlerpCam(init:Object=null)
		{
			super(init);
		}
	}
}