package org.syncon.CncSim.controller
{
	
	import flash.events.Event;
	
	import flashx.undo.IOperation;
	
	public class EditProductCommandTriggerEvent extends Event implements IOperation
	{
		
		public static const DO_NOTHING:String = 'DO_NOTHING.w';
		public static const DID_NOTHING:String = 'DID_NOTHING.w';		
		
		
		public static const ADD_TEXT_LAYER:String = 'ADD_TEXT_LAYER.w';
		public static const TEXT_LAYER_ADDED:String = 'TEXT_LAYER_ADDED.w';		
		
		public static const ADD_IMAGE_LAYER:String = 'ADD_IMAGE_LAYER.w';
		public static const IMAGE_LAYER_ADDED:String = 'IMAGE_LAYER_ADDED.w';				
		
		public static const REMOVE_LAYER:String = 'REMOVE_LAYER.w';
		public static const LAYER_REMOVED:String = 'LAYER_REMOVED.w';					
		
		public static const CHANGE_FONT_SIZE:String = 'CHANGE_FONT_SIZE.w';
		public static const FONT_SIZE_CHANGED:String = 'FONT_SIZE_CHANGED.w';	

		public static const CHANGE_TEXT_ALIGN:String = 'CHANGE_TEXT_ALIGN.w';
		public static const TEX_ALIGN_CHANGED:String = 'TEX_ALIGN_CHANGED.w';		

		public static const CHANGE_IMAGE_URL:String = 'CHANGE_IMAGE_URL.w';
		public static const IMAGE_URL_CHANGED:String = 'IMAGE_URL_CHANGED.w';		
		
		public static const CHANGE_FONT_FAMILY:String = 'CHANGE_FONT_FAMILY.w';
		public static const FONT_FAMILY_CHANGED:String = 'FONT_FAMILY_CHANGED.w';			
		
		public static const CHANGE_FONT_FAMILY_PRODUCT:String = 'CHANGE_FONT_FAMILY_PRODUCT.w';
		public static const FONT_FAMILY_PRODUCT_CHANGED:String = 'FONT_FAMILY_PRODUCT_CHANGED.w';	
		
		public static const CHANGE_COLOR:String = 'CHANGE_COLOR.w';
		public static const COLOR_CHANGED:String = 'COLOR_CHANGED.w';			
		
		public static const CHANGE_LAYER_COLOR:String = 'CHANGE_LAYER_COLOR.w';
		public static const LAYER_COLOR_CHANGED:String = 'LAYER_COLOR_CHANGED.w';		
		
		public static const LOAD_PRODUCT:String = 'LOAD_PRODUCT.w';	
		public static const PRODUCT_LOADED:String = 'PRODUCT_LOADED.w';			
		
		public static const LOAD_PLAN:String = 'LOAD_PLAN.w';	
		public static const PLAN_LOADED:String = 'PLAN_LOADED.w';			
		
		/**
		 * PROCESS_BEHAVIOR will rip out type 
		 * */
		public static const PROCESS_BEHAVIOR:String = 'PROCESS_BEHAVIOR.w';	
		
		public static const LOAD_FACE:String = 'LOAD_FACE.w';	
		public static const FACE_LOADED:String = 'FACE_LOADED.w';			
		
		public static const MOVE_LAYER:String = 'MOVE_LAYER.w';
		public static const LAYER_MOVED:String = 'LAYER_MOVED.w';				
		
		public static const RESIZE_LAYER:String = 'RESIZE_LAYER.w';
		public static const LAYER_RESIZED:String = 'LAYER_RESIZED.w';			
		
		public static const ROTATE_LAYER:String = 'ROTATE_LAYER.w';
		public static const LAYER_ROTATED:String = 'LAYER_ROTATED.w';		
		
		public static const CHANGE_TEXT:String = 'CHANGE_TEXT.w';
		public static const TEXT_CHANGED:String = 'TEXT_CHANGED.w';		
		
		public static const CHANGE_LAYER_VISIBLIITY:String = 'CHANGE_LAYER_VISIBLIITY.w';
		public static const LAYER_VISIBLIITY_CHANGED:String = 'LAYER_VISIBLIITY_CHANGED.w';		
		
		static public var fxAnimate : Function;  
		/*
		public var data : Object; 		
		public var data2 : Object;
		public var data3 : Object;
		*/
		[Bindable] public var data : Object='';	
		[Bindable] public var data2 : Object='';
		[Bindable] public var data3 : Object='';
		
		public var undo:Boolean;
		public var redo : Boolean;
		/*
		public var oldData:Object;
		public var oldData2:Object;
		public var oldData3:Object;
		*/
		[Bindable] public var oldData:Object='';
		[Bindable] public var oldData2:Object='';
		[Bindable] public var oldData3:Object='';	
			/**
			 * first time so we don' destroy something on redo ... ? 
			 * */
		public var firstTime:Boolean=true;
		/**
		 * if is bulk evetnt ... save these thins ..
		 * */
		public var subEvents: Array=[];
		/**
		 * Like subevents but when undoing adn redoing they are auto undo and redone
		 * */
		public var autoSubEvents: Array=[];
		public var fxPost:Function;
		
		public function EditProductCommandTriggerEvent(type:String , data :  Object = null , data2 : Object = null , 
													   data3 : Object = null ) 
		{	
			this.data = data
			this.data2 = data2
			this.data3 = data3
			super(type, true);
		}
		
		override public function clone() : Event
		{
			var e : EditProductCommandTriggerEvent = new EditProductCommandTriggerEvent(type, data, data2, data3);
			e.oldData = this.oldData; 
			e.oldData2 = this.oldData2; 
			e.oldData3 = this.oldData3; 		
			e.firstTime = this.firstTime; 
			e.undo = this.undo 
			e.redo = this.redo; 
			
			e.autoSubEvents = this.autoSubEvents; 
			e.subEvents = this.subEvents; 
			
			e.fxPost = this.fxPost; 
			return e
		}
		public function performUndo() : void
		{
			this.firstTime = false; 
			this.undo = true
			this.redo = false; 
			fxAnimate( this )  
		}
		public function performRedo() : void
		{
			this.firstTime = false; 
			this.undo = false
			this.redo = true; 
			fxAnimate( this )  
		}			
		
		/**
		 * Maps command b/c names are so long 
		 * @param commandMap
		 * 
		 */
		static public function mapCommands( commandMap : Object, commandClass : Class ) : void
		{
			
			var types : Array = [
				/*
				ModifyCommandTriggerEvent.CHANGE_NAME,
				ModifyCommandTriggerEvent.CHANGED_NAME,
				
				ModifyCommandTriggerEvent.ADD_LIST,
				ModifyCommandTriggerEvent.ADDED_LIST,
				*/
				ADD_TEXT_LAYER,
				//TEXT_LAYER_ADDED,		
				ADD_IMAGE_LAYER,
				//IMAGE_LAYER_ADDED,		
				CHANGE_FONT_FAMILY,
				CHANGE_FONT_SIZE,
				CHANGE_TEXT_ALIGN,
				CHANGE_COLOR,
				CHANGE_LAYER_COLOR,
				
				CHANGE_FONT_FAMILY_PRODUCT,
				
				CHANGE_IMAGE_URL,
				
				CHANGE_TEXT,
				
				CHANGE_LAYER_VISIBLIITY, 
				
				MOVE_LAYER,
				RESIZE_LAYER,
				ROTATE_LAYER,
				REMOVE_LAYER,
				
				PROCESS_BEHAVIOR,
				
				//LAYER_MOVED,
				LOAD_PRODUCT,
				LOAD_PLAN,
				LOAD_FACE,
				
				DO_NOTHING
				
			]
			for each ( var command : String in types ) 
			{
				commandMap.mapEvent(command, commandClass, EditProductCommandTriggerEvent, false );			
			}
			
		}
		
	}
}