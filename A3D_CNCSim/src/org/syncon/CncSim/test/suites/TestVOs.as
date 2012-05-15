package org.syncon.CncSim.test.suites
{
	import org.syncon.Customizer.controller.CheckAlarmsCommand;
	import org.syncon.TalkingClock.controller.ConvertFiltersCommand;
	import org.syncon2.utils.ArrayListMoveableHelper;
	import org.syncon2.utils.SplitXML;
	
	/**
	 * Often times VO have basic static test to verify functionality and demonstrate intended usage, 
	 * call them from here
	 * */
	public class TestVOs
	{
		public function TestVOs() 
		{
			
		}
		
		public function run() : void
		{
			/*ConvertFiltersCommand.Test(); 
			ArrayListMoveableHelper.Test()
			SplitXML.Test()*/
			CheckAlarmsCommand.test();
		}
	}
}