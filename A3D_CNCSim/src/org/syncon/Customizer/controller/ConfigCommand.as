package org.syncon.Customizer.controller
{
	
	import com.adobe.serialization.json.JSON;
	
	import flash.utils.Timer;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.Customizer.model.NightStandModel;
	
	public class ConfigCommand extends Command
	{
		[Inject] public var model:NightStandModel;
		[Inject] public var event:ConfigCommandTriggerEvent;
		private var debug : Boolean = true
		private var alert : Boolean = false; 
		private var notAuthenticatedRetryTimer : Timer;
		private var retryWaitForAuthenticationCount : int = 0 ;
		/**
		 * Max retry count for events
		 * */
		private var retryCount : int = 2 ;		
		/**
		 * Remove all references to Alert for mobile test.
		 * */
		static public var FxAlert : Function = null; 
		static private var filename:String='config.txt';
		
		override public function execute():void
		{
			if ( event.type == ConfigCommandTriggerEvent.LOAD_CONFIG ) 
			{
				this.loadConfig()
			}
			if ( event.type == ConfigCommandTriggerEvent.SAVE_CONFIG ) 
			{
				this.saveConfig()
			}				
		}
		
		private function loadConfig():void
		{
			//NightStandConstants.FileLoader.readFile("", "user_config.json", this.importConfig )
		}
		
		
		private function saveConfig(): void
		{
			/*if ( this.model.config == null ) 
				return; 
			this.model.config.currentUnit = this.model.currentUnit; 
			this.model.config.currentLessonGroup = this.model.currentLessonPlan; 
			this.model.config.currentLesson = this.model.currentLesson; 
			var contents : String = JSON.encode(  this.model.config )  */
			//NightStandConstants.FileLoader.writeFile(contents, '', 'user_config.json',    configSaved ) ; 
			//this.model.config.alarms = this.model.alarmList.toArray();
			//this.model.config.currentVoice = this.model.currentVoice;
			//it is important that this always calls the post save fx ....
			//return NightStandConstants.FileLoader.writeObjectToFile( this.model.config, filename, configSaved ) ; 
		}
		
		private function configSaved(o:Object=null):void
		{
			//if ( this.loadConfigWhenFinishedSaving  ) 
				this.loadConfig()
		}
		
	}
}