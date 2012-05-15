package org.syncon.CncSim.view.ui.old
{
	import com.roguedevelopment.objecthandles.Flex4ChildManager;
	import com.roguedevelopment.objecthandles.Flex4HandleFactory;
	import com.roguedevelopment.objecthandles.HandleDescription;
	import com.roguedevelopment.objecthandles.HandleRoles;
	import com.roguedevelopment.objecthandles.ObjectHandles;
	import com.roguedevelopment.objecthandles.constraints.MaintainProportionConstraint;
	import com.roguedevelopment.objecthandles.constraints.MovementConstraint;
	import com.roguedevelopment.objecthandles.constraints.SizeConstraint;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.events.PropertyChangeEvent;
	import mx.events.ResizeEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.CncSim.controller.EditProductCommandTriggerEvent;
	import org.syncon.CncSim.model.CustomEvent;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.model.ViridConstants;
	import org.syncon.CncSim.vo.ColorLayerVO;
	import org.syncon.CncSim.vo.ImageLayerVO;
	import org.syncon.CncSim.vo.LayerBaseVO;
	import org.syncon.CncSim.vo.TextLayerVO;
	import org.syncon.onenote.onenotehelpers.impl.layer_item_renderer;
	import org.syncon.onenote.onenotehelpers.impl.viewer2_store;
	
	import spark.core.MaskType;
	
	/**
	 * click it make it the model layer 
	 * 
	 * @author user3
	 * 
	 */
	public class LayerItemRendererMediator extends Mediator 
	{
		[Inject] public var ui : layer_item_renderer;
		[Inject] public var model : NightStandModel;
		private var layer : LayerBaseVO ; 
		protected var flexModel1:SimpleDataModel = new SimpleDataModel();
		private var registered:Boolean;
		/**
		 * do not log undo events ...
		 * */
		private var createUndos:Boolean=true;
		/**
		 * when repositing make suer to update handle width adn ehgiht 
		 * */
		private var repositioning:Boolean;
		/**
		 * if true, clicking a layer will not select it
		 * */
		private var disableClickSelection:Boolean=true;
		private var blockUpdatingModel:Boolean;
		override public function onRegister():void
		{
			this.ui.addEventListener( layer_item_renderer.ON_CLICK, 
				this.onClick);	
			this.ui.addEventListener( layer_item_renderer.DATA_CHANGED, 
				this.onDataChanged ) ; 
			this.ui.addEventListener( layer_item_renderer.MOVED, 
				this.onMoved ) ; 
			this.ui.addEventListener( layer_item_renderer.RESIZED_MANIALY, 
				this.onResizedManually ) ; 
			this.initHandles()
			
			this.ui.addEventListener( layer_item_renderer.REPOSITION, 
				this.onReposition ) ; 
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.PRESENTATION_MODE_CHANGED, 
				this.onPreviewModeChanged);	
			/*
			eventMap.mapListener(eventDispatcher, NightStandModelEvent.CURRENT_LAYER_CHANGED, 
			this.onLayerChanged);	
			this.onLayerChanged( null ) 
			*/	
		}
		
		private function onLayerSelected(param0:Object):void
		{
			if ( this.model.previewMode ) //do not auto select in preview mode 
				return; 
			
			if ( this.preventSelectionOfEmptyImage() ) 
				return; 
			
			this.model.objectHandles.selectionManager.setSelected( this.model.currentLayer.model ) ; 
		}
		
		/**
		 * when user does an action that cuases a resize 
		 * this is broken out so it is not confused with 
		 * event driving actions
		 * */
		protected function onResizedManually(event:Event):void
		{
			//resize implies size, not position
			/*this.flexModel1.x = this.layer.x ; 
			this.flexModel1.y = this.layer.y ; */
			this.layer.width; 
			this.flexModel1.width = this.layer.nonChromeWidth;//this.ui.width; 
			this.flexModel1.height = this.layer.nonChromeHeight;//this.ui.height; 
			//copyLayerToModel()
		}
		
		private function initHandles():void
		{
			if ( this.model.objectHandles == null ) 
			{
				this.model.objectHandles = new ObjectHandles( this.model.viewer as Sprite, null, new Flex4HandleFactory(), 
					new Flex4ChildManager() ) 
				//this.model.objectHandles.defaultHandles
				var m : MovementConstraint = new MovementConstraint()
				m.maxX = this.model.viewer.width; 
				m.maxY = this.model.viewer.height; 
				m.minX = 0; 
				m.minY = 0; 
				//this.model.objectHandles.addDefaultConstraint( m )
				var sZ : SizeConstraint = new SizeConstraint()
				sZ.maxHeight = this.model.viewer.height; 
				sZ.maxWidth = this.model.viewer.width; 
				sZ.minHeight = 20
				sZ.minWidth = 30
				
				this.model.objectHandles.enableMultiSelect = false; 
				this.model.objectHandles.disableHandleSelection = true; 
				//this.model.objectHandles.addDefaultConstraint( sZ )
			}
			//this.model.objectHandles.addDefaultConstraint(
			//this.model.objectHandles
			/*flexModel1.x = 50;
			flexModel1.y = 150;
			flexModel1.width = 50;
			flexModel1.height = 50;
			flexModel1.isLocked = true;*/
			var constraints : Array = new Array()
			//if baseLayer is Around 
			
			var handleDesc : Array = this.model.objectHandles.defaultHandles.concat(); 
			handleDesc.push(new HandleDescription(HandleRoles.MOVE, new Point(50, 50), new Point(0, 0)));
			handleDesc = null
			this.model.objectHandles.registerComponent( flexModel1, this.ui, handleDesc , true, constraints);
			this.registered = true ;
			this.flexModel1.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, this.onModelChange ) ; 
		}
		
		/**
		 * Set new sizes from simplemodel on layerVO
		 * */
		protected function onModelChange( event:PropertyChangeEvent):void
		{
			if ( blockUpdatingModel ) 
				return;
			if ( this.isText && ['width', 'height', ].indexOf(event.property ) != -1 ) 
			{
				return;
			}
			if ( this.layer.locked && ['x', 'y', ].indexOf(event.property ) != -1 ) 
			{
				return;
			}
			
			//unfortunately, NUmber( event.newValue ) always rounds it off after 2 digits, 
			//causing multie delays 
			var value : Number = event.newValue as Number; 
			var value2 : Number = Number(event.newValue ); 
			switch( event.property )
			{
				
				case "x":
					this.ui.x = value
					
					if ( createUndos == false )
					{
						this.layer.x = this.ui.x
					}
					else
					{
						//use flex model b/c we do not want to call ' setXY and change the model 
						this.dispatch( new EditProductCommandTriggerEvent ( 
							EditProductCommandTriggerEvent.MOVE_LAYER, value, this.flexModel1.y/* this.ui.y*/, this.ui.layer) ) 
					}
					break;
				case "y":
					this.ui.y = value
					
					if ( createUndos == false )
					{
						this.layer.y = this.ui.y
					}
					else
					{
						
						this.dispatch( new EditProductCommandTriggerEvent ( 
							EditProductCommandTriggerEvent.MOVE_LAYER,this.flexModel1.x  /*this.ui.x*/, value, this.ui.layer) ) 
					}
					break;
				case "rotation":
					this.ui.rotation = value
					
					if ( createUndos == false )
					{
						this.layer.rotation = this.ui.rotation
					}
					else
					{
						this.dispatch( new EditProductCommandTriggerEvent ( 
							EditProductCommandTriggerEvent.ROTATE_LAYER, value, this.ui.layer		) ) 
					}				
					break;
				case "width": 
					this.ui.width = value
					if ( this.isImage ) 
					{
						this.ui.image.img.width = this.ui.width; 
						trace('updateModel', 'y', this.ui.image.img.y, this.ui.image.y, this.ui.y, this.layer.y ) ; 
					}
					if ( createUndos == false )
					{
						this.layer.width = this.ui.width
						
					}
					else
					{
						this.dispatch( new EditProductCommandTriggerEvent ( 
							EditProductCommandTriggerEvent.RESIZE_LAYER, value, this.flexModel1.height , this.layer 	) ) 	
					}
					break;
				case "height": 
					this.ui.height = value
					if ( this.isImage ) 
					{
						this.ui.image.img.height = this.ui.height; 
					}
					if ( createUndos == false )
					{
						this.layer.height = this.ui.height
					}
					else
					{
						this.dispatch( new EditProductCommandTriggerEvent ( 
							EditProductCommandTriggerEvent.RESIZE_LAYER, this.flexModel1.width,value , this.layer ) ) 	
					}
					
					break;
				default: return;
			}
			
			this.layer.update(); 
			//redraw();
		}
		protected function onMoved(event:CustomEvent):void
		{
			this.dispatch( new EditProductCommandTriggerEvent(
				EditProductCommandTriggerEvent.MOVE_LAYER, this.layer, event.data[0], event.data[1] 
			) ) ; 
		}
		
		public function onResize(event:ResizeEvent):void
		{
			if ( this.layer == null ) //why is this necessary? 
				return;
			if ( this.layer != this.ui.layer ) 
			{
				//09/22/11
				//this happens when a image layer i sloaded ... we can safely ignore thise 
				//as data change will be called to resolve this 
				trace('layer is not same as ui layer ....', this.layer.name, this.ui.layer.name ) 
				return; 
			}
			if ( this.ui.resetting ) 
				return; 
			/**
			 * if this is not the base layer and one exists, ... 
			 * go wait for later
			 * */
			if ( this.model.baseLayer != null &&
				this.model.baseLayer.repositionedOnce == false && this.layer != this.model.baseLayer )
			{
				this.model.waitForBaseLayer.push( [this, event] )
				this.ui.removeEventListener(ResizeEvent.RESIZE, this.onResize ) 
				//this.silent = false //not sure about this one ...
				//silent means no undos ... this is on till reposition is finished ..
				return; 
			}
			if ( this.layer.repositionedOnce ) //why hardcode this?
				return; 
			if ( this.layer is ImageLayerVO ) 
			{
				/*if ( this.ui.image == null ) 
				return;
				if ( this.ui.image.resizedOnce == false ) 
				return; */
				/*
				//8-23-11: had to take this out b/c of cache ...
				//for some reason iange resize is distapched isntantly ... wait till it is proper first ... 
				if ( this.ui.image.img.bitmapData == null && this.ui.image.img.source != '' ) 
				return;
				*/
				//this.ui.image.img.sourceHeight
				//clone baselayer height if possible ...
				if ( this.layer != this.model.baseLayer && this.model.baseLayer != null )
				{
					/*
					}
					if ( this.layer.width > 0 &&  ! isNaN( this.layer.importX ) )
					{
					trace('this layer was set manually dont adjust size'); 
					this.copyLayerToModel(); 
					}
					else
					{*/
					if ( this.ui.width > this.model.baseLayer.width ) 
					{
						var shrinkLayerToFitWidth : Boolean = true; 
						//if a layer height is specified, use that, 
						//if not, and ui is wider than layer, deacrese it's size
						if (  ! isNaN(this.layer.importWidth ) || ! isNaN( this.layer.importHeight ) ) 
						{
							//be sure to clear this with the image source changes ... 
							if ( this.layer.importWidth == this.layer.width || this.layer.importHeight == this.layer.height ) 
							{
								shrinkLayerToFitWidth = false; 
								trace('did not resize large layer');
							}
							//Note: do not like this ... prefrably layerVO has setting of autoResize, and here we won't do that
						}
						
						if ( shrinkLayerToFitWidth ) 
						{
							this.blockUpdatingModel = true 
							var wH : Number = this.ui.image.img.height/this.ui.image.img.width
							this.flexModel1.width = this.model.baseLayer.width - 40-10; 
							
							this.ui.image.img.width = this.flexModel1.width; 
							this.flexModel1.height =this.ui.image.img.width *wH
							this.ui.image.img.height = this.flexModel1.height; 				
							
							//have to copy it back to ensure it is not change back to layer 
							this.layer.width = this.flexModel1.width; 
							this.layer.height = this.flexModel1.height;
							//ui is used to set the height ... setting it explclity, will this allow it to be rezies later? 
							this.ui.width = this.flexModel1.width; 
							this.ui.height = this.flexModel1.height; 	
							//but handles are not propelry placed? ...
							this.blockUpdatingModel = false
						}
					}
					/*	}*/
				}
			}	
			
			if ( this.layer.vertStartAlignment == LayerBaseVO.ALIGNMENT_CENTER) 
			{
				this.layer.vertStartAlignment = null
				this.ui.layer.y = this.ui.y = this.model.viewer.height/2 - this.ui.height/2
			}
			else if ( this.layer.vertStartAlignment == '' ) 
			{
				/*if ( this.layer.name == "Jack 'o Lantern" ) 
				{
				trace('caught layer name'); 
				}*/
				this.layer.vertStartAlignment = ''
				this.ui.y = this.model.baseLayer.y + this.ui.layer.y; 
				this.layer.y = this.model.baseLayer.y + this.ui.layer.y; 
				trace('reposition y', this.layer.name, this.layer.y,  this.model.baseLayer.y + this.ui.layer.y )
				//this.ui.layer.x = this.model.baseLayer.x + this.ui.layer.x; 
				
				//this.ui.layer.y = this.ui.y = this.model.viewer.height/2 - this.ui.height/2
			} 
			if ( this.layer.horizStartAlignment == LayerBaseVO.ALIGNMENT_CENTER) 
			{
				this.ui.layer.x = this.ui.x = this.model.viewer.width/2 - this.ui.width/2
				this.layer.horizStartAlignment = null 
			}
			else if ( this.layer.horizStartAlignment == '' ) 
			{
				//the problem is here, we are setting things relative to the base layer ... 
				//this is liekly permanent ... so store it on the ui ... not here ...
				/*	if ( this.layer.locked ) 
				{
				this.ui.x = this.model.baseLayer.x + this.ui.layer.x; 
				this.layer.x = this.model.baseLayer.x + this.ui.layer.x; 
				}
				else
				{*/
				//if ( !  isNaN( this.layer.x
				this.layer.horizStartAlignment = ''
				//this.ui.layer.y = this.model.baseLayer.y + this.ui.layer.y; 
				this.ui.x = this.model.baseLayer.x + this.ui.layer.x; 
				trace('reposition x', this.layer.name, this.layer.x,  this.model.baseLayer.x + this.ui.layer.x )
				this.layer.x = this.model.baseLayer.x + this.ui.layer.x; 
				//this.ui.layer.y = this.ui.y = this.model.viewer.height/2 - this.ui.height/2
				/*}*/
			}
			if ( this.isText ) 
			{
				trace('asd'); 
			}
			//if image maintain aspect ration
			if ( this.isImage ) 
			{
				if ( this.layer == this.model.currentLayer ) 
				{
					if ( this.preventSelectionOfEmptyImage() == false ) 
						if ( this.model.objectHandles.selectionManager.isSelected( this.flexModel1 ) == false )
							this.model.objectHandles.selectionManager.setSelected( this.flexModel1 )  
				}
				/*var itemMovementCons : MaintainProportionConstraint = new MaintainProportionConstraint()
				this.unregister()
				this.register([ itemMovementCons] )*/
			}
			if ( this.isImage )
			{
				//make this a new type ....
				//we are copying the url and sizing to the mask layer that is already laid down 
				if ( this.ui.image.layer.mask )
				{
					this.adjustMaskToMatchLayer()
					
				}
			}
			this.createUndos = false
			this.copyLayerToModel();
			this.createUndos = true; // what about when uploading an image? no, sam ething do not resize
			if ( this.repositioning ) 
			{
				repositioning = false; 
			}
			this.ui.removeEventListener(ResizeEvent.RESIZE, this.onResize ) 
			//this.createUndos = false 
			this.layer.repositionedOnce = true
			if ( this.layer == this.model.baseLayer && this.model.waitForBaseLayer.length > 0 )
			{
				for each ( var params : Array in this.model.waitForBaseLayer ) 
				{
					params[0].onResize(params[1]);//.push( [this, event] )
				}
				this.model.waitForBaseLayer = []; 
				
				//return; 
			}
			if ( this.layer == this.model.baseLayer ) 
			{
				repositionBaseLayerBg()
			}
		}
		
		/**
		 * Hide the ui compoent, and moves mask on top of it ...
		 * */
		private function adjustMaskToMatchLayer(wait:Boolean=true):void
		{
			
			this.ui.visible = false;
			//so visible does not work, but alpha does...
			this.ui.alpha = 0.1
			//show mask 
			/*
			//show the mask image ...
			this.ui.visible = true;
			//so visible does not work, but alpha does...
			this.ui.alpha = 0.8
			*/
			var v : viewer2_store = this.model.viewer as viewer2_store
			v.img_.source = this.ui.image.layer.url; 
			/*
			//it would be ui.image.img.width ..
			v.img_.x = this.ui.x; 
			v.img_.y = this.ui.y; 
			v.img_.width = this.ui.image.width; 
			v.img_.height = this.ui.image.height; 		
			*/
			/*var g : Group = v.maskLayer_.parent as Group
			try {
			if ( g != null )
			g.removeElement( v.maskLayer_ ) ;
			}
			catch(e:Error) {}*/
			v.img_.x = this.layer.x; 
			v.img_.y = this.layer.y; 
			v.img_.width = this.layer.width; 
			v.img_.height = this.layer.height 	
			//v.img_.height  -= Math.random()*10
			/*
			this.ui.image.removeElement( this.ui.image.img ) ; 
			this.model.viewer.mask = this.ui.image.img
			*/	
			//v.mask = v.maskLayer;
			//v.maskLayer_.visible = false
			/*v.workspace.mask = v.maskLayer_
			v.maskLayer_.blendMode = BlendMode.NORMAL; */
			//v.maskLayer_.blendMode = BlendMode.NORMAL;
			//to see the mask uncommend the lower lin ..
			//v.workspace.mask = null
			/*
			v.workspace.mask = null
			if ( v.workspace.mask == v.maskLayer_  )
			v.mask = v.maskLayer_
			else
			v.workspace.mask = v.maskLayer_
			//v.workspace.mask = v.maskLayer_
			*/
			
			v.workspace.mask = v.maskLayer_
			//v.workspace.maskType = MaskType.CLIP
			v.workspace.maskType = MaskType.ALPHA
			//v.maskLayer_.blendMode = BlendMode.NORMAL; 
			v.maskLayer_.blendMode = BlendMode.ERASE; 
			v.maskBg.alpha
			//can't believe this fixed it 
			if ( wait ) 
			{
				//this.ui.callLater( this.adjustMaskToMatchLayer, [false] );
			}
			trace('mask widths and height',  v.maskLayer_.width, v.maskLayer_.height , v.maskLayer_.parent); 
			trace('mask widths and height',   this.ui.width, this.ui.height , this.ui.layer.width, this.ui.layer.height) ; 
			//http://franto.com/inverse-masking-disclosed/
			//searched for inverse mask ...
		}
		
		private function unregister():void
		{
			this.model.objectHandles.unregisterComponent( this.ui ) ; 
		}
		private function register(constraints:Array):void
		{
			this.model.objectHandles.registerComponent( flexModel1, this.ui ,null, true, constraints);
			this.model.objectHandles.selectionManager.setSelected( this.flexModel1 ) ; 
		}
		
		private function copyLayerToModel(blockUndos:Boolean=false):void
		{
			var initialValue : Boolean = this.blockUpdatingModel
			if ( blockUndos) this.blockUpdatingModel = true; 
			this.flexModel1.x = this.layer.x ; 
			this.flexModel1.y = this.layer.y ; 
			this.flexModel1.width = this.layer.width; 
			/*	if ( this.layer.height == 16 ) 
			trace('setting to 16');*/ 
			this.flexModel1.height = this.layer.height; 
			this.flexModel1.rotation = this.layer.rotation; 
			trace('copyLayerToModel', this.layer.aaa ) 
			if ( blockUndos) this.blockUpdatingModel = initialValue; 
		}
		
		/**
		 * Dispatched when itemRender's data is changed. 
		 * will regenerate all handles depending on layer properties 
		 * first step is to clear any old event listeners to refresh component 
		 * */
		protected function onDataChanged(event:Event):void
		{
			if ( ui.layer == null ) 
			{
				this.ui.removeEventListener(ResizeEvent.RESIZE, this.onResize ) 
				if ( this.layer != null ) 
				{
					if ( this.layer.model == this.flexModel1 ) 
						this.layer.model = null; 
					else if ( this.layer.model != null )
					{
						//strange the ui's' layer iared, , we have a dirty one 
						//but the layer has been loaded elss being cleewhere and is still active 
						//before we hav ehad a chance to remove it here ... 
						//8-31-11, iwas curious what could cause this ...
						trace('LayerItemRendererMediator', 'onDataChanged', 'data model is set but not to this' )
					}
				}
				this.layer = null 
				return; 
			}
			if ( this.layer != null ) 
			{
				this.layer.model = null; //? good idea 
				this.removeLayerListeners()
			}
			
			this.returnUIToDefaultState()
			this.disableClickSelection = true; 
			this.layer = this.ui.layer; 
			this.layer.addEventListener(LayerBaseVO.LAYER_REDD, this.onLayerReAdd ) 
			this.layer.addEventListener(LayerBaseVO.LAYER_REMOVED, this.onLayerRemoved ) 
			this.layer.addEventListener(LayerBaseVO.LAYER_SELEECTED, this.onLayerSelected ) ; 
			
			this.layer.addEventListener(LayerBaseVO.UPDATED, this.onLayerUpdated ) 
			this.layer.model = this.flexModel1; 
			this.model.objectHandles.unregisterComponent( this.ui ) ; 
			this.ui.visible = this.layer.visible; //masking turns this off ... ... or just turn of mask layer here too
			this.ui.alpha = 1; 
			//this.model.objectHandles.unregisterModel( this.model ) ; 
			//this.registered = false
			//unlock any layre automatically

			if ( this.layer.locked ) 
			{
				this.ui.buttonMode=false 
				this.ui.useHandCursor=false
			}
			else //recreate the layers 
			{
				var constraints : Array = []; 
				constraints 
				/*if ( this.registered == false )
				{
				this.registered = true; */
				
				//contrain new layers to inside main layer ....
				if ( this.model.baseLayer != null ) 
				{
					var itemMovementCons : MovementConstraint = new MovementConstraint()
					itemMovementCons.maxX = this.model.baseLayer.x + this.model.baseLayer.width; 
					itemMovementCons.maxY = this.model.baseLayer.y + this.model.baseLayer.height; 
					itemMovementCons.minX = this.model.baseLayer.x; ; 
					itemMovementCons.minY = this.model.baseLayer.y; ; 
					// constraints.push( itemMovementCons )
				}
				
				
				//need all images to lock aspect ration 
				if ( this.isImage ) 
				{
					var mpCon : MaintainProportionConstraint = new MaintainProportionConstraint()
					constraints.push( mpCon ) 
				}
				
				var itemSizeConstraint : SizeConstraint = new SizeConstraint()
				itemSizeConstraint.minWidth = 16
				itemSizeConstraint.minHeight = 10
				constraints.push( itemSizeConstraint ) 
				
				if ( this.isText ) 
				{
					this.ui.text.layer.setFontSize(); 
					var handleDesc : Array = [];///this.model.objectHandles.defaultHandles.concat(); 
					handleDesc.push(new HandleDescription(HandleRoles.MOVE, new Point(50, 50), new Point(0, 0)));
					
					handleDesc.push(new HandleDescription(HandleRoles.MOVE, new Point(0, 0), new Point(0, 0)));
					handleDesc.push(new HandleDescription(HandleRoles.MOVE, new Point(100, 0), new Point(0, 0)));
					
					handleDesc.push(new HandleDescription(HandleRoles.MOVE, new Point(0, 100), new Point(0, 0)));
					
					handleDesc.push(new HandleDescription(HandleRoles.MOVE, new Point(100, 100), new Point(0, 0)));
					
					// We need a zero point a lot, so lets not re-create it all the time.
					var zero:Point = new Point(0,0);
					
					handleDesc.push( new HandleDescription( HandleRoles.ROTATE,
						new Point(100,50) , 
						new Point(20,0) ) ); 
					
					
					var defaultHandles : Array = handleDesc
					
					defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_LEFT, 
						zero ,
						zero ) ); 
					
					defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_UP ,
						new Point(50,0) , 
						zero ) ); 
					
					defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_RIGHT,
						new Point(100,0) ,
						zero ) ); 
					
					defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_RIGHT,
						new Point(100,50) , 
						zero ) ); 
					
					defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_RIGHT,
						new Point(100,100) , 
						zero ) ); 
					
					defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_DOWN ,
						new Point(50,100) ,
						zero ) ); 
					
					defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_LEFT,
						new Point(0,100) ,
						zero ) ); 
					
					defaultHandles.push( new HandleDescription( HandleRoles.RESIZE_LEFT,
						new Point(0,50) ,
						zero ) ); 
					
					
					defaultHandles.push( new HandleDescription( HandleRoles.ROTATE,
						new Point(100,50) , 
						new Point(20,0) ) ); 
					
					
					
					
					//handleDesc.push(new HandleDescription(HandleRoles.MOVE, new Point(50, 50), new Point(0, 0)));
					handleDesc = null
					
					handleDesc = this.model.objectHandles.defaultHandles.concat(); 
					handleDesc.pop(); 
					handleDesc.pop(); 
					handleDesc.pop(); 
					handleDesc = []
					
					handleDesc.push( new HandleDescription( HandleRoles.ROTATE,
						new Point(100,50) , 
						new Point(20,0) ) ); 
					//why must one add with no role? 
					//handleDesc.push(new HandleDescription(HandleRoles.NO_ROLE, new Point(50, 50), new Point(0, 0)));
					
					/* handleDesc.push(new HandleDescription(HandleRoles.NO_ROLE, new Point(0, 0), new Point(0, 0)));
					handleDesc.push(new HandleDescription(HandleRoles.NO_ROLE, new Point(100, 0), new Point(0, 0)));
					
					handleDesc.push(new HandleDescription(HandleRoles.NO_ROLE, new Point(0, 100), new Point(0, 0)));
					
					handleDesc.push(new HandleDescription(HandleRoles.NO_ROLE, new Point(100, 100), new Point(0, 0)));*/
					
					handleDesc.push( new HandleDescription( HandleRoles.NO_ROLE,
						new Point(0,50) , 
						new Point(-10,0) ) ); 
					
				}
				/*this.layer.url; 
				if ( this.layer.visible && this.isImage ) 
				{
					trace('debug', 'have i mage layer'); 
				}
				if ( this.layer.subType == ViridConstants.IMAGE_SOURCE_UPLOAD  ) 
				{
					trace('debug', 'have upload layer'); 
				}*/
				this.model.objectHandles.registerComponent( flexModel1, this.ui ,handleDesc, true, constraints);
				if ( this.layer.visible && this.model.previewMode == false ) //dont' select invisible layers
					this.model.objectHandles.selectionManager.setSelected( this.flexModel1 ) ; 
				/*		}*/
				
				this.onPreviewModeChanged(null);
			}
			
			this.preventSelectionOfEmptyImage()
			
			//if ingrave layer turn on the background
			if ( this.isText ) 
			{
				this.ui.text.bg.visible = false; 
				this.ui.text.bg.height = 0; this.layer.height; 
				this.ui.text.bg.width =0;// this.layer.width; 
				/*this.ui.text.height = NaN; //this.layer.height; 
				this.ui.text.width =NaN;// this.layer.width; 
				*/
				this.ui.text.height = NaN; //this.layer.height; 
				this.ui.text.width =NaN;
				this.ui.text.txt.filters = []
				if ( this.model.fxIsEngraveLayer( this.layer ) ) 
				{
					this.ui.text.txt.filters = this.ui.text.dropFilters; 
					this.ui.text.bg.visible = true; 
					if ( this.layer.locked ) 
					{
						//this.ui.text.txt.height = this.layer.height; ; //this.layer.height; 
						//this.ui.text.txt.width =this.layer.width;
						this.ui.text.bg.height = this.layer.height; 
						this.ui.text.bg.width = this.layer.width; 
						/*
						this.ui.text.maxHeight = this.layer.height; 
						this.ui.text.maxWidth = this.layer.width; 
						*/
					}
					///09/12+1/11: click engrave layers to type on them 
					this.ui.buttonMode=true 
					this.ui.useHandCursor=true
					this.disableClickSelection = false 
				}
			}
			
			
			
			
			this.flexModel1.isLocked = this.layer.locked; 
			//this.copyLayerToModel();
			
			
			
			//try to copy back the x's and y's ...
			if ( layer.repositionedOnce ) 
			{
				this.onReturnToPreviousSize();
			}
			else
			{
				if ( this.layer.locked ) //if layer locked no need to remeasure or resize, place it down 
				{
					//this.layer.repositionedOnce = true; 
					//this is for text layers, they not dispatch a resize ? this should be handled in itemrenderer
					this.onResize(null); 
					//this.onReturnToPreviousSize(); 
				}
				if ( this.layer.vertStartAlignment != null || this.layer.horizStartAlignment != null ) 
				{
					this.ui.addEventListener(ResizeEvent.RESIZE, this.onResize )
					//if this is a new layer ... bring it to the front .... 
					//also when clicked in layerlist 
					if  ( this.layer.vertStartAlignment == '' && this.layer.horizStartAlignment == '' )  {
						trace('skip');
					}
					else {
						this.ui.depth = this.ui.parent.numChildren-1
					}
						
				}
				//always resize the mask layers so they switch between faces
				if ( this.isImage && this.ui.image.layer.mask ) 
				{
					this.ui.addEventListener(ResizeEvent.RESIZE, this.onResize )
				}
			}
			
			this.ui.callLater( this.setAsSelectedLayerIfSelected ) ; 
			
			
		}
		
		private function setAsSelectedLayerIfSelected():void
		{
			// TODO Auto Generated method stub
			if ( this.layer ==null ) 
				return; 
			//first time layer is loaded in and is Face's importLayerTOSelect, must be selected manually 
			if ( this.layer.locked == false && this.model.currentLayer == this.layer ) 
			{
				//if (  this.preventSelectionOfEmptyImage() == false ) 
				this.model.objectHandles.selectionManager.setSelected( this.model.currentLayer.model ) ; 
			}
		}		
		
		/**
		 * Why was this function needed? 
		 * */
		private function preventSelectionOfEmptyImage(): Boolean
		{
			if ( this.layer == null ) 
				return false; 
			if ( this.isImage)
			{
				if (   this.layer.subType == ViridConstants.IMAGE_SOURCE_CLIPART &&
					(this.ui.image.layer.url == '' || this.ui.image.layer.url == null )  )
				{
					this.model.objectHandles.selectionManager.clearSelection()
					return true 
				}
				//for uploads the source or image must both be null ...
				if (   this.layer.subType == ViridConstants.IMAGE_SOURCE_UPLOAD &&
					(this.ui.image.layer.source  == null )  &&
					(this.ui.image.layer.url == '' || this.ui.image.layer.url == null )  )
				{
					this.model.objectHandles.selectionManager.clearSelection()
					return true 
				}
				
			}
			return false; 
		}
		
		private function onReturnToPreviousSize():void
		{
			this.createUndos = false
			this.copyLayerToModel(); 
			if ( this.isImage ) 
			{
				this.ui.image.img.width = this.layer.width; 
				this.ui.image.img.height = this.layer.height; 
			}
			if ( this.isColor ) 
			{
				this.ui.colorR.img.width = this.layer.width; 
				this.ui.colorR.img.height = this.layer.height; 
				//update the layer as well ... not sure why it doesn't stretch to 100% ...
				this.ui.colorR.colorLayer.width = this.layer.width; 
				this.ui.colorR.colorLayer.height = this.layer.height; 
			}
			//have to do this afterward or position will be off ...
			if ( this.isImage )
			{
				//make this a new type ....
				//we are copying the url and sizing to the mask layer that is already laid down 
				if ( this.ui.image.layer.mask )
				{
					this.adjustMaskToMatchLayer()
				}
			}
			
			if ( this.layer == this.model.baseLayer ) 
			{
				this.repositionBaseLayerBg(); 
			}
			
			/*trace('return to place', this.layer.x ) ; 
			trace('return to place', this.layer.y ) ; */
			this.layer.update()
			this.layer.updateVisibility(); 
			this.createUndos = true
			return;
		}
		
		/**
		 * stores image on bottom mask
		 * */
		private function repositionBaseLayerBg():void
		{
			if ( this.layer != this.model.baseLayer ) 
			{
				trace('Warning', 'repositionBaseLayerBg', 'not base layer')
				return; 
			}
			//hide top part?
			//this.ui.visible = false;
			
			var v : viewer2_store = this.model.viewer as viewer2_store
			v.imgBg.source = this.layer.url; 
			
			v.imgBg.x = this.layer.x; 
			v.imgBg.y = this.layer.y; 
			v.imgBg.width = this.layer.width; 
			v.imgBg.height = this.layer.height; 
			
		}
		
		/**
		 * will setup the repositioing listener again again ...
		 * */
		private function onReposition(e:Event):void
		{
			this.repositioning = true; 
			this.ui.addEventListener(ResizeEvent.RESIZE, this.onResize )
		}
		
		private function returnUIToDefaultState():void
		{
			this.ui.buttonMode=true 
			this.ui.useHandCursor=true
		}
		
		protected function onLayerUpdated(event:Event):void
		{
			//remove sleection if not supposed to be selected
			if (this.layer != null && this.layer.visible == false && this.model.currentLayer == this.layer) 
			{
				this.model.objectHandles.selectionManager.clearSelection()
			}
		}
		
		protected function onLayerRemoved(event:Event):void
		{
			this.model.objectHandles.unregisterComponent( this.ui ) ; 
			this.ui.removeEventListener(ResizeEvent.RESIZE, this.onResize ) 
			if ( this.layer != null ) 
			{
				this.removeLayerListeners()
			}
			this.ui.layer.loadedIntoLister = null;//key it will recreate from scratch
			this.ui.layer = null; 
			this.ui.data = null; 
		}
		
		private function removeLayerListeners() : void
		{
			this.layer.removeEventListener(LayerBaseVO.LAYER_REMOVED, this.onLayerRemoved ) 
			this.layer.removeEventListener(LayerBaseVO.LAYER_REDD, this.onLayerReAdd )
			this.layer.removeEventListener(LayerBaseVO.UPDATED, this.onLayerUpdated ) 
			this.layer.removeEventListener(LayerBaseVO.LAYER_SELEECTED, this.onLayerSelected ) 
		}
		
		/**
		 * dispathec when layer is added back to the screen ...
		 * */
		protected function onLayerReAdd(event:Event):void
		{
			this.model.objectHandles.selectionManager.setSelected( this.model ) ; 
			this.onDataChanged(null); 
		}
		
		private function onClick(e: CustomEvent): void
		{
			//stop pover selecting ....
			/*if ( this.model.currentLayer == this.ui.listData ) 
			return;*/ 
			if ( this.ui.layer != this.layer ) 
			{
				this.ui.text.layer
				trace('LayerItemRendererMediator', 'onClick', 'warning, my layers are invalid'); 
			}
			if ( this.model.fxIsEngraveLayer( this.layer ) == false ) 
			{
				if ( this.layer.locked ) 
					return;
			}
			if ( this.disableClickSelection ) 
				return; 
			
			this.model.currentLayer = this.ui.listData as LayerBaseVO; 
		}		
		
		/**
		 * When IN preview mode ...
		 * */
		private function onPreviewModeChanged(e:Event):void
		{
			if ( this.layer == null ) 
				return; 
			// TODO Auto Generated method stub
			//unselect all 
			//remove background on engraves
			//mask opacity 100%
			if ( this.model.previewMode ) 
			{
				if ( this.model.fxIsEngraveLayer( this.layer ) ) 
				{
					this.ui.text.bg.visible = false; 
				}
			}
			else
			{
				if ( this.model.fxIsEngraveLayer( this.layer ) ) 
				{
					this.ui.text.bg.visible = true; 
				}
			}
		}
		
		private function get isText() : Boolean
		{
			return this.layer.type == TextLayerVO.Type; 
		}
		
		private function get isImage() : Boolean
		{
			return this.layer.type == ImageLayerVO.Type; 
		}
		
		private function get isColor() : Boolean
		{
			return this.layer.type == ColorLayerVO.Type; 
		}
		
		
	}
}