package org.syncon.CncSim
{
	import org.syncon.CncSim.view.apps.Deliverable;
	import org.syncon.CncSim.view.ui.old.components.*;
	import org.syncon.CncSim.view.ui.old.components.debug.*;
	import org.syncon.onenote.onenotehelpers.impl.layer_item_renderer;
	import org.syncon2.utils.SubContext;
	
	public class Virid_ViewsSubContext extends SubContext 
	{
		override public function startup():void
		{
			mediatorMap.mapView( MainMenuBar,  MainMenuBarMediator ) 	
			//mediatorMap.mapView( BottomToolbar, BottomToolbarMediator ) 	
			
			//mediatorMap.mapView( PriceList,  PriceListMediator ) 	
			//mediatorMap.mapView( LayerInspector, LayerInspectorMediator ) 	
			mediatorMap.mapView( layer_cart_panel,  LayerCartPanelMediator ) 	
			mediatorMap.mapView( DesignView, DesignViewMediator ) 	
				
			//mediatorMap.mapView( layer_item_renderer, LayerItemRendererMediator ) 	
			//mediatorMap.mapView( LayerInspectorSizeLocation, LayerInspectorSizeLocationMediator ) 	
			
			//mediatorMap.mapView( text_panel, TextPanelMediator ) 	
			mediatorMap.mapView( PanelDesign, PanelDesignMediator ) 	
			mediatorMap.mapView( PanelEngrave, PanelEngraveMediator ) 
				
			mediatorMap.mapView( Deliverable, DeliverablesMediator ) 	
			mediatorMap.mapView( PanelText, PanelTextMediator ) 	
				
			mediatorMap.mapView( transformation_stage, TransformationStageMediator ) 	
			mediatorMap.mapView( LayerList, LayerListMediator ) 	
				
			mediatorMap.mapView( UndoList, UndoListMediator ) 	
				
				
			//mediatorMap.mapView( LayerImageInspector,LayerImageInspectorMediator ) 	
			//mediatorMap.mapView( LayerColorInspector, LayerColorInspectorMediator ) 	
				
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