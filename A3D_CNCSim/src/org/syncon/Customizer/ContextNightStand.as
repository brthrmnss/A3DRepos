package org.syncon.Customizer
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	import org.syncon.Customizer.controller.*;
	import org.syncon.Customizer.controller.IO.*;
	import org.syncon.Customizer.model.CustomEvent;
	import org.syncon.Customizer.model.NightStandConstants;
	import org.syncon.Customizer.model.NightStandModel;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageTriggerEvent;
	import org.syncon2.utils.SubContext;
	import org.syncon2.utils.mobile.AndroidExtensions;
	
	public class ContextNightStand extends Context
	{
		public function ContextNightStand()
		{
			super();
		}
		override public function startup():void
		{
			// Model
			injector.mapSingleton( NightStandModel )		
			
			//	GetInitDataCommandTriggerEvent.mapCommands( this.commandMap, GetInitDataCommand )
			InitMainContextCommandTriggerEvent.mapCommands( this.commandMap, InitMainContextCommand ); 
			
			this.commandMap.mapEvent( CreateDefaultDataTriggerEvent.CREATE, CreateDefaultDataCommand );
			
			this.commandMap.mapEvent( ExportJSONCommandTriggerEvent.EXPORT_JSON, ExportJSONCommand );
			this.commandMap.mapEvent( ExportJSONCommandTriggerEvent.EXPORT_NEW_IMAGE, ExportJSONCommand );
			this.commandMap.mapEvent( ImportJSONCommandTriggerEvent.IMPORT_JSON, ImportJSONCommand );
			
			this.commandMap.mapEvent( ImportViridJSONCommandTriggerEvent.IMPORT_JSON, ImportViridJSONCommand );
			
			
			this.commandMap.mapEvent(  TestImportViridJSONCommandTriggerEvent.TEST_IMPORT_VIRID_JSON, TestImportViridJSONCommand );
			
			
			EditProductCommandTriggerEvent.mapCommands( this.commandMap, EditProductCommand ) ; 
			EditProductCommandTriggerEvent.fxAnimate = this.dispatchEvent; 
			ConfigCommandTriggerEvent.mapCommands( this.commandMap, ConfigCommand); 
			
			this.loadSubContexts()			
			super.startup();
			this.initStage()
			
			if ( doInit == false ) {trace('this.context.loadConfig( ) ; ', 'skipped init'); return;} 
			var wait : Boolean = false;
			if ( wait ) 
			{
				import flash.utils.setTimeout;
				setTimeout( this.onInit, 1500 )
			}
			else
				this.onInit()	
			//this.dispatchEvent( new Event( CreateDefaultDataCommand.START ))
			//this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP, popup_modal_bg, 'popup_modal_bg', true ) );
			
			
		}
		override public function set contextView(value:DisplayObjectContainer):void
		{
			super.contextView = value;
			listenForMediation()
		}
		public function listenForMediation(): void
		{
			this.contextView.addEventListener( 'mediate', this.onMediate ) ; 
		}
		protected function onMediate(event:CustomEvent):void
		{
			this.mediatorMap.createMediator( event.data) 
		}
		
		public function addSubContext( _subContext : SubContext ) : void
		{
			this.subContexts.push(_subContext)
		}
		/**
		 * Prevents onInit from being called, 
		 * fill in models with fake information 
		 * */
		public var doInit : Boolean = true; 
		//private var subContext : EvernoteBasicPopupContext = new EvernoteBasicPopupContext()
		private function onInit() : void
		{
			//this.dispatchEvent( new Event( CreateDefaultDataCommand.START ))
			//this.dispatchEvent( new Event( CreateDefaultDataCommand.LIVE_DATA ))
			//this.subContext.onInit(); 
		}
		
		
		public function initStage() : void
		{
			this.dispatchEvent( new InitMainContextCommandTriggerEvent(
				InitMainContextCommandTriggerEvent.INIT, NightStandConstants.showAds, NightStandConstants.flex ) ) ; 
			
			this.dispatchEvent( new InitMainContextCommandTriggerEvent(
				InitMainContextCommandTriggerEvent.INIT2 ) ) ; 
			
			this.dispatchEvent( new InitMainContextCommandTriggerEvent(
				InitMainContextCommandTriggerEvent.CREATE_CLIP_ART_LIBRARY ) ) ; 
			this.importAnySpecifiedJSON(); 
			return;
			this.dispatchEvent( new InitMainContextCommandTriggerEvent(
				InitMainContextCommandTriggerEvent.INIT3_MAKEUP_FLEX_DATA ) ) ; 
			//return;
			
		}
		
		/**
		 * Attempts to import json....
		 * First checks if importJsonStrVirid is set, if so, import and exit 
		 * then check importJsonStr, if defined, import and exit
		 * if niether set, import from the TestViridImportCommand, which contains 
		 * json strings to be imported
		 * */
		public function importAnySpecifiedJSON() : void
		{
			
			if ( this.importJsonStrVirid != null ) 
			{
				this.dispatchEvent( new ImportViridJSONCommandTriggerEvent(
					ImportViridJSONCommandTriggerEvent.IMPORT_JSON,this.importJsonStrVirid)) ;
				return;
			}
			
			if ( this.importJsonStr != null ) 
			{
				this.dispatchEvent( new ImportJSONCommandTriggerEvent(
					ImportJSONCommandTriggerEvent.IMPORT_JSON,this.importJsonStr)) ;
				return; 
			}
			
			this.dispatchEvent( new TestImportViridJSONCommandTriggerEvent(
				TestImportViridJSONCommandTriggerEvent.TEST_IMPORT_VIRID_JSON)) ;
			/*
			this.dispatchEvent( new LoadSoundsTriggerEvent(
			LoadSoundsTriggerEvent.LOAD_SOUNDS ) ) ; 
			this.dispatchEvent( new LoadPortCommandTriggerEvent(
			LoadPortCommandTriggerEvent.LOAD_PORT ) ) ; 			
			
			*/
			/*this.dispatchEvent( new LoadLessonPlanTriggerEvent(
			LoadLessonPlanTriggerEvent.LOAD_LESSON_PLAN ) ) ;
			*/
			/*	this.dispatchEvent( new LoadUnitsCommandTriggerEvent(
			LoadUnitsCommandTriggerEvent.LOAD_UNITS, '', false  ) ) ;
			
			
			this.dispatchEvent( new ConfigCommandTriggerEvent(
			ConfigCommandTriggerEvent.LOAD_CONFIG, configName ) );
			*/
			AndroidExtensions.FxError = this.onAlert; 
		}
		
		public var configName : String = ''; 
		
		public function onAlert(msg : String ) : void
		{
			this.dispatchEvent( new ShowAlertMessageTriggerEvent( ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, msg  )  ) 
		}
		
		private function loadSubContexts() : void
		{
			for each ( var _subContext : SubContext in this.subContexts ) 
			{
				_subContext.subLoad( this, this.injector, this.commandMap, this.mediatorMap, this.contextView ) 		
			}
		}
		
		public var subContexts : Array = []; 
		private var importJsonStr:String ;//=  '{"name":"testname","sku":"1234","desc":"lorem isum description of testname","Faces":[{"name":"front","image":"assets/products/162-000003-Z_Configure.jpg","mask":"","layer_lock":true,"Layers":[{"name":"color","type":"color","Media":{"source":"0xffffff","type":"color"},"Fonts":null,"transform":{"width":"100%","height":"100%","x":null,"y":null,"rotation":null},"orientation":"horizontal","required":true,"default":null},{"name":"color","type":"image","Media":{"source":"","Fonts":null,"type":"image"},"transform":{"width":"100","height":"100","x":"10","y":"10","rotation":"0"},"orientation":"horizontal","required":false,"default":null},{"name":"Color Layer","type":"text","Media":{"source":"helloworld","type":"text"},"Fonts":[{"name":"arial","size":"10","weight":"normal"},{"name":"bebas","size":"15","weight":"bold"}],"transform":{"width":"100","height":"100","x":"10","y":"10","rotation":"0"},"orientation":"horizontal","required":false,"default":null},{"name":"Clipart Layer 1","type":"clipart","Media":{"source":"assets/images/pokemon.png","type":"clipart"},"Fonts":null,"transform":{"width":"100","height":"100","x":"50","y":"50","rotation":"0"},"orientation":"horizontal","required":false,"default":null},{"name":"Clipart Layer 2","type":"clipart","Media":{"source":null,"type":"clipart"},"Fonts":null,"transform":{"width":null,"height":null,"x":null,"y":null,"rotation":null},"orientation":"horizontal","required":false,"default":null},{"name":"Clipart Layer 3","type":"clipart","Media":{"source":null,"type":"clipart"},"Fonts":null,"transform":{"width":null,"height":null,"x":null,"y":null,"rotation":null},"orientation":"horizontal","required":false,"default":null}]}]}';
		private var importJsonStrVirid : String; 
		public function importJson(str:String):void
		{
			if ( str == null ) return; 
			this.importJsonStr=str;
		}
		
		public function importViridJson(str:String):void
		{
			if ( str == null ) return; 
			this.importJsonStrVirid=str;
		}
		
		public function mapMediator(view:Object=null) : void
		{
			mediatorMap.createMediator(view)
		}
		
		
		
		
		
		
	}
}