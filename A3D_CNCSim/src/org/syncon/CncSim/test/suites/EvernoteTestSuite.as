package org.syncon.CncSim.test.suites
{
	import org.syncon.CncSim.test.cases.TestEvernoteService;
	import org.syncon.evernote.test.cases.TestEvernoteServiceNotesV2;	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class EvernoteTestSuite
	{
		/*		public var testFlickrService:TestFlickrService;
		public var testGalleryModel:TestGalleryModel;
		public var testGalleryLabel:TestGalleryLabelMediation;
		public var testGalleryViewMediation:TestGalleryViewMediation;*/
		//public var testGalleryModel:TestEvernoteService;
		public var testEvernoteBasics:TestEvernoteServiceNotesV2;		
	}
}