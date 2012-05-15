package org.syncon.CncSim
{

	import org.syncon.CncSim.view.subview.*;
	import org.syncon.CncSim.view.ui.*;
	import org.syncon.CncSim.view.ui.old.components.debug.*;
	import org.syncon2.utils.SubContext;
	
	public class ContextNightStand_ViewsSubContext extends SubContext 
	{
		override public function startup():void
		{
			// View
			//no auto removal, air dispatches remove child events, even when the view is nto to be destroyed
			var autoRemove : Boolean = false; 
			
			
			mediatorMap.mapView( UndoList, UndoListMediator ) 	
			/*
			
			mediatorMap.mapView( Packages, PackagesMediator ) 		
			mediatorMap.mapView( Groups, GroupsMediator ) 						
			mediatorMap.mapView( Lessons, LessonsMediator ) 			
			mediatorMap.mapView( Lesson, LessonMediator ) 		
			mediatorMap.mapView( Player, PlayerMediator ) 		
			mediatorMap.mapView( PreviewJSON, PreviewJSONMediator ) 	
			mediatorMap.mapView( SearchPics, SearchPicsMediator ) 		
			mediatorMap.mapView( SearchSounds, SearchSoundsMediator ) 	
			mediatorMap.mapView( SearchDictionary, SearchDictionaryMediator ) 					
			
			mediatorMap.mapView( PronunciationViewer, PronunciationViewerMediator ) 		
			mediatorMap.mapView( ItemSets, ItemSetsMediator ) 	
			mediatorMap.mapView( ItemViewer, ItemViewerMediator ) 		
				
			mediatorMap.mapView( ItemSetViewer, ItemSetViewerMediator ) 					
				
			mediatorMap.mapView( LessonViewer, LessonViewerMediator ) 	
			mediatorMap.mapView( QuickInput, QuickInputMediator ) 	
			mediatorMap.mapView( QuickInputLesson, QuickInputLessonMediator ) 	
				
			mediatorMap.mapView( PlayerItemViewer, PlayerItemViewerMediator)
			mediatorMap.mapView( PlayerAutomate, PlayerAutomateMediator )
				
				
			mediatorMap.mapView( GroupViewer, GroupViewerMediator )
			mediatorMap.mapView( UnitViewer, UnitViewerMediator )
				
				*/
			/*	
			mediatorMap.mapView( Toolbar,  ToolbarMediator ) 	
			mediatorMap.mapView( BottomToolbar, BottomToolbarMediator ) 	
			
			mediatorMap.mapView( PriceList,  PriceListMediator ) 	
			mediatorMap.mapView( LayerInspector, LayerInspectorMediator ) 	
			mediatorMap.mapView( LayersList,  LayersListMediator ) 	
			mediatorMap.mapView( DesignView, DesignViewMediator ) 	
				
			mediatorMap.mapView( layer_item_renderer, LayerItemRendererMediator ) 	
			mediatorMap.mapView( LayerInspectorSizeLocation, LayerInspectorSizeLocationMediator ) 	
			
			mediatorMap.mapView( LayerTextInspector, LayerTextInspectorMediator ) 	
			//mediatorMap.mapView( LayerImageInspector,LayerImageInspectorMediator ) 	
			mediatorMap.mapView( LayerColorInspector, LayerColorInspectorMediator ) 	
				*/
			mediatorMap.mapView( BehaviorList, BehaviorListMediator ) 	
			mediatorMap.mapView( LogList, LogListMediator ) 	
			mediatorMap.mapView( PlayheadNavigation, PlayheadNavigationMediator  ) 	
				
			/*
			mediatorMap.mapView( Clock, ClockMediator )//, null, true, false );	
			mediatorMap.mapView( FilterStack, FilterStackMediator )//, null, true, false );		
			mediatorMap.mapView(FilterEditor, FilterEditorMediator )//, null, true, false );				
			mediatorMap.mapView(FilterNewSelection, FilterNewMediator )//, null, true, false );						
			mediatorMap.mapView( ClockView, ClockViewMediator ) 
			mediatorMap.mapView( SettingsView, SettingsViewMediator ) 
			mediatorMap.mapView( EditFilters, EditFiltersMediator ) 		
			
			mediatorMap.mapView( SettingsViewMini, SettingsViewMiniMediator ) 					
			
			mediatorMap.mapView( SelectThemeView, SelectThemeViewMediator ) 			
			mediatorMap.mapView( InfoView, InfoViewMediator ) 			
			mediatorMap.mapView( BottomNavMenu, BottomNavMenuMediator ) 			
			
			mediatorMap.mapView( HomeView, HomeViewMediator ) 		
			mediatorMap.mapView( HelpView, HelpViewMediator ) 		
			
			mediatorMap.mapView( AnalogLCDView, AnalogLCDViewMediator ) 
			mediatorMap.mapView( AnalogLCDSettings, AnalogLCDSettingsMediator ) 		
			
			mediatorMap.mapView( FlipClockView, FlipClockViewMediator ) 
			mediatorMap.mapView( FlipClockSettings, FlipClockSettingsMediator ) 			
			
			mediatorMap.mapView( WallClockView, WallClockViewMediator ) 
			mediatorMap.mapView( WallClockSettings, WallClockSettingsMediator ) 						
			*/
			
			this.loadSubContexts()			
			super.startup();
			
			if ( doInit == false ) {trace('ContextNightStand_ViewsSubContext', 'skipped init'); return;} 
			var wait : Boolean = false;
			if ( wait ) { import flash.utils.setTimeout; setTimeout( this.onInit, 1500 ); }
			else{ this.onInit();}	
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
		private function onInit() : void
		{
			return; 
		}
		
		private function loadSubContexts() : void
		{
			for each ( var _subContext : SubContext in this.subContexts ) 
			{
				_subContext.subLoad( this, this.injector, this.commandMap, this.mediatorMap, this.contextView ) 		
			}
		}
		
		public var subContexts : Array = []; 
		
		/*
		public function mapMediator(view:Object=null) : void
		{
		mediatorMap.createMediator(view)
		}
		
		*/
	}
}