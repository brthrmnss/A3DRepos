package org.syncon.CncSim.controller
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.NightStandModelEvent;
	import org.syncon.CncSim.vo.BehaviorVO;
	import org.syncon.CncSim.vo.ColorLayerVO;
	import org.syncon.CncSim.vo.FaceVO;
	import org.syncon.CncSim.vo.ImageLayerVO;
	import org.syncon.CncSim.vo.LayerBaseVO;
	import org.syncon.CncSim.vo.PlanVO;
	import org.syncon.CncSim.vo.StoreItemVO;
	import org.syncon.CncSim.vo.TextLayerVO;
	import org.syncon.onenote.onenotehelpers.impl.viewer2_store;
	
	public class EditProductCommand extends Command 
	{
		[Inject] public var model:NightStandModel;
		[Inject] public var event:EditProductCommandTriggerEvent
		
		private var debugUndos : Boolean = true; 
		
		override public function execute():void
		{
			/**
			 * Can block adding if it is a repeat
			 * */
			var addUndo : Boolean = true; 
			//allows us to reset non merginc timer 
			var resetTimer : Boolean = true; 
			lastUndo = this.model.lastUndo; 
			/**
			 * if true will select the layer when done 
			 * */
			var selectLayerWhenFinished : Boolean = true
			/**
			 * can select this lsyer instead
			 * */
			var selectThisLayer : LayerBaseVO; 
			
			if ( this.model.blockUndoAdding == false ) //implies neitiher list changes 
			{
				//clone event to undoList (Debugging)
				if ( event.undo ) 
				{
					if ( this.model.undoList.length != 0 ) 
						this.model.undoList.removeItemAt( this.model.undoList.toArray().length-1 ); 
				}
				if ( event.redo ) 
				{
					this.model.undoList.addItem( event ) //( this.model.undoList.toArray().length-1 ); 
				}
			}
			//usuallly when doing bulk operations, 
			if ( this.model.blockUndoExecution )
			{
				trace('block undo'); 
				return;
			}
			/*if ( event.undo == false && event.redo == false )
			{
			event.oldFocus = onenote_lister_partialF4.SelectedObject
			}
			*/
			
			if ( event.type == EditProductCommandTriggerEvent.PROCESS_BEHAVIOR ) 
			{
				 var behavior : BehaviorVO = event.data as BehaviorVO
				var eventConverted : EditProductCommandTriggerEvent = behavior.convertToEvent(); 
				this.dispatch( eventConverted ) ; //restrat event ....
				
			}
			
			var undoable: Boolean = true
			if ( event.type == EditProductCommandTriggerEvent.ADD_IMAGE_LAYER ) 
			{
				//var oldName : String = this.model.currentPage.name
				//var newName : String = event.data.toString(); 
				if ( event.undo == false )
				{
					if ( event.firstTime ) 
					{
						//if first param is a string 
						if ( event.data is String ) 
						{
							var imgLayer : ImageLayerVO = new ImageLayerVO(); 
							imgLayer.name = 'Image ' +( this.model.getLayersByType(ImageLayerVO).length+1) 
							imgLayer.url = event.data.toString(); 
						}
						//if first paramt imagelayerVO, clone it 
						if ( event.data is ImageLayerVO ) 
						{
							imgLayer = event.data as ImageLayerVO
							imgLayer = imgLayer.clone() as ImageLayerVO
							/*	if ( imgLayer.prompt_layer )
							imgLayer.visible = false; */
						}
						event.oldData = imgLayer; 
						
						this.model.addLayer( imgLayer ); 
						/*
						imgLayer.x = 0; 
						imgLayer.y = 100; 
						*/
						/*imgLayer.x = 0; 
						imgLayer.y = 0; */
						//imgLayer.y = 100; 
						
						if ( imgLayer.visible ) //prompts are not by default visible ...
							this.model.currentLayer = imgLayer; 
						
						
						//event.oldData = oldName; 
						//this.model.currentPage.name = newName 
						
						
					}	
					else
					{
						//if it exists just add it back to the stage ....
						imgLayer = event.oldData as ImageLayerVO; 
						this.model.addLayer( imgLayer ); 
						imgLayer.layerReAdded(); 
					}
					
				}
				else
				{
					imgLayer = event.oldData as ImageLayerVO; 
					this.model.removeLayer( imgLayer ) ; 
					imgLayer.layerRemoved()
					//oldName = event.oldData.toString(); 
					//this.model.currentPage.name = oldName
				}		
				//this.model.currentPage.updated();
				this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.IMAGE_LAYER_ADDED, event, null ) ) 
			}
			
			if ( event.type == EditProductCommandTriggerEvent.ADD_TEXT_LAYER ) 
			{
				//var oldName : String = this.model.currentPage.name
				//var newName : String = event.data.toString(); 
				if ( event.undo == false )
				{
					//why the first time, ADD_IMAGE_LAYER image layer does not have it ? 
					if ( event.firstTime ) 
					{
						//if first param is a string 
						if ( event.data is String ) 
						{
							var txtLayer : TextLayerVO = new TextLayerVO(); 
							txtLayer.name = 'Text ' + (this.model.getLayersByType(TextLayerVO).length+1); ; 
							txtLayer.text = event.data.toString() ; //'Enter Text Here';
							/*
							txtLayer.y = 100; 
							txtLayer.x = 0; 
							txtLayer.y = 100; 
							*/
						}
						//if first param TextLayerVO, clone it 
						if ( event.data is TextLayerVO ) 
						{
							txtLayer = event.data as TextLayerVO
							txtLayer = txtLayer.clone() as TextLayerVO
						}
						/*
						txtLayer.x = 0; 
						txtLayer.y = 100; 
						*/
						//txtLayer.fontFamily = event.data2.toString() ; //font ... what should default be? ...
						this.model.addLayer( txtLayer ); 
						event.oldData = txtLayer; 
						//this.model.currentPage.name = newName 
						
					}	
					else
					{
						//if it exists just add it back to the stage ....
						txtLayer = event.oldData as TextLayerVO; 
						this.model.addLayer( txtLayer ); 
						txtLayer.layerReAdded(); 
					}
					this.model.currentLayer = txtLayer; 
				}
				else
				{
					txtLayer = event.oldData as TextLayerVO; 
					this.model.removeLayer( txtLayer ) ; 
					txtLayer.layerRemoved()
				}		
				//this.model.currentPage.updated();
				this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.TEXT_LAYER_ADDED, event, null ) ) 
			}
			
			
			if ( event.type == EditProductCommandTriggerEvent.DO_NOTHING ) 
			{
				//var oldName : String = this.model.currentPage.name
				//var newName : String = event.data.toString(); 
				if ( event.undo == false )
				{
					//why the first time, ADD_IMAGE_LAYER image layer does not have it ? 
					/*if ( event.firstTime ) 
					{
						//if first param is a string 
						if ( event.data is String ) 
						{
							var txtLayer : TextLayerVO = new TextLayerVO(); 
							txtLayer.name = 'Text ' + (this.model.getLayersByType(TextLayerVO).length+1); ; 
							txtLayer.text = event.data.toString() ; //'Enter Text Here';
						 
						}
						//if first param TextLayerVO, clone it 
						if ( event.data is TextLayerVO ) 
						{
							txtLayer = event.data as TextLayerVO
							txtLayer = txtLayer.clone() as TextLayerVO
						}
			 
						//txtLayer.fontFamily = event.data2.toString() ; //font ... what should default be? ...
						this.model.addLayer( txtLayer ); 
						event.oldData = txtLayer; 
						//this.model.currentPage.name = newName 
						
					}	
					else
					{
						//if it exists just add it back to the stage ....
						txtLayer = event.oldData as TextLayerVO; 
						this.model.addLayer( txtLayer ); 
						txtLayer.layerReAdded(); 
					}
					this.model.currentLayer = txtLayer; */
				}
				else
				{
					/*txtLayer = event.oldData as TextLayerVO; 
					this.model.removeLayer( txtLayer ) ; 
					txtLayer.layerRemoved()*/
				}		
				//this.model.currentPage.updated();
				this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.DID_NOTHING, event, null ) ) 
			}
			
			if ( event.type == EditProductCommandTriggerEvent.CHANGE_LAYER_VISIBLIITY ) 
			{
				if ( event.undo == false )
				{
					layer = this.model.currentLayer as LayerBaseVO; 
					if ( event.data2 != null ) 
						layer = event.data2 as LayerBaseVO; 
					event.oldData = layer.visible;
					var layerVisibility : Boolean = event.data as Boolean 
					if ( layer.visible == layerVisibility ) 
						return; //leaving early 
					//if same ... 
					layer.visible = layerVisibility; 
					layer.updateVisibility();//this is not enough 
					layer.update(); 
					event.data2 = layer ; //don't like this feel like storing old layer should be automatic ...
					
					if ( this.lastUndoSameType() && lastUndo.data2 == layer ) 
					{
						if ( debugUndos ) trace('merging', event, event.type); 
						this.model.lastUndo.data = event.data;
						lastUndo = popUndo(); 
						var lastUndo2nd : EditProductCommandTriggerEvent = this.model.undo.peekUndo() as EditProductCommandTriggerEvent
						if ( lastUndo2nd.type != this.event.type ) 
						{
							return //leaving early: b/c user change visibility 2x, and we have no need to store that 
						}
						else
						{
							pushUndo(lastUndo) ; 
							addUndo = false; 
						}
						
					}
				}
				else
				{
					layer = event.data2 as LayerBaseVO; 
					layer.visible = event.oldData as Boolean
					layer.update()
					//this.model.currentLayer = layer ... this should be auto 
				}		
				//this.model.currentPage.updated();
				//this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.LAYER_VISIBLIITY_CHANGED, event, null ) ) 
			}	
			
			
			if ( event.type == EditProductCommandTriggerEvent.CHANGE_IMAGE_URL ) 
			{
				if ( event.undo == false )
				{
					imgLayer = this.model.currentLayer as ImageLayerVO; 
					if ( event.data3 != null ) 
						imgLayer = event.data3 as ImageLayerVO; 
					event.oldData = imgLayer.url;
					//upload sends bitmapdata bytes, otherwise we have string url (event.data)
					/*
					event.oldData2 = imgLayer.width; 
					event.oldData3 = imgLayer.height; 
					*/
					if ( event.data != null ) 
					{
						imgLayer.url = event.data.toString()
					}
					//data2 is a bitmapdata bytes
					if ( event.data2 != null ) 
					{
						//we have uploaded an image
						imgLayer.url = ''
						imgLayer.source = event.data2; 
						//09/03/11 wtf ...? why?  //oh ok u are calling to export image ... this 
						//might be fine .... no upload image first, andwhen done call this function
						var trgevent : ExportJSONCommandTriggerEvent = new ExportJSONCommandTriggerEvent(
							ExportJSONCommandTriggerEvent.EXPORT_NEW_IMAGE, '');
						this.dispatch(trgevent);
					}
					if ( event.firstTime ) 
					{
						imgLayer.update(ImageLayerVO.SOURCE_CHANGED)//'fontSize'); 
						imgLayer.horizStartAlignment = LayerBaseVO.ALIGNMENT_CENTER
						imgLayer.vertStartAlignment = LayerBaseVO.ALIGNMENT_CENTER//need better way to refresh this
						
						imgLayer.importWidth = NaN
						imgLayer.importHeight = NaN; 
					}
					this.model.currentLayer = imgLayer; 
					event.data3 = imgLayer ; //don't like this feel like storing old layer should be automatic ...
				}
				else
				{
					imgLayer = event.data3 as ImageLayerVO; 
					if ( event.oldData == null || event.oldData == ''  ) //if there is no old data, they started with an empty string, 
					{
						imgLayer.url = ''
						imgLayer.visible = false 
					}
					else
					{
						imgLayer.url = event.oldData.toString() 
					}
					
					imgLayer.update()
				}		
				//this.model.currentPage.updated();
				//this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.IMAGE_URL_CHANGED, event, imgLayer ) ) 
			}	
			
			
			
			if ( event.type == EditProductCommandTriggerEvent.CHANGE_FONT_SIZE ) 
			{
				if ( event.undo == false )
				{
					txtLayer = this.model.currentLayer as TextLayerVO; 
					if ( event.firstTime ) 
					{
						/*txtLayer.x = 0; 
						txtLayer.y = 100; */
					}		
					event.oldData = txtLayer.fontSize; 
					txtLayer.fontSize = int( event.data ); 
					txtLayer.update('fontSize'); 
					this.model.currentLayer = txtLayer; 
					event.data2 = txtLayer ; //don't like this feel like storing old layer should be automatic ...
				}
				else
				{
					txtLayer = event.data2 as TextLayerVO; 
					txtLayer.fontSize = int( event.oldData ); 
					txtLayer.update('fontSize'); 
				}		
				//this.model.currentPage.updated();
				//this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.FONT_SIZE_CHANGED, event, null ) ) 
			}
			if ( event.type == EditProductCommandTriggerEvent.CHANGE_FONT_FAMILY ) 
			{
				if ( event.undo == false )
				{
					txtLayer = this.model.currentLayer as TextLayerVO; 
					layer = txtLayer; //select it
					if ( event.data2 != null ) //the layer to target
						txtLayer = event.data2 as TextLayerVO; 
					if ( event.firstTime ) 
					{
						/*txtLayer.x = 0; 
						txtLayer.y = 100; */
					}		
					event.oldData = txtLayer.fontFamily; 
					txtLayer.fontFamily = event.data.toString() 
					txtLayer.update('fontFamily'); 
					if ( event.data2 == null ) 
						this.model.currentLayer = txtLayer; 
					event.data2 = txtLayer ; //don't like this feel like storing old layer should be automatic ...
				}
				else
				{
					txtLayer = event.data2 as TextLayerVO; 
					txtLayer.fontFamily = event.oldData.toString() 
					txtLayer.update('fontFamily'); 
				}		
				//this.model.currentPage.updated();
				//this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.FONT_FAMILY_CHANGED, event, null ) ) 
			}
			
			if ( event.type == EditProductCommandTriggerEvent.CHANGE_FONT_FAMILY_PRODUCT ) 
			{
				selectLayerWhenFinished = false 
				this.model.blockUndoAdding = true
				if ( event.undo == false )
				{
					
					var fontName : String = event.data.toString() 
					//go through everything on the stage ... 
					//if text / engrave change font family 
					//save as bulk 
					for each ( var face : FaceVO in this.model.baseItem.faces.toArray() ) 
					{
						if ( face.imported )
						{
							for each ( layer in face.layers.toArray() ) 
							{
								//see if this layer is empty
								if(layer.type == TextLayerVO.Type )
								{
									var bulkEvent :EditProductCommandTriggerEvent = new EditProductCommandTriggerEvent ( 
										EditProductCommandTriggerEvent.CHANGE_FONT_FAMILY, fontName , layer 	) 
									this.dispatch( bulkEvent )
								}
								if ( event.firstTime )
								{
									//some how need to collect the events 
									event.subEvents.push(bulkEvent )
								}
							}
						}
						else
						{
							//non importaed layers are not visible so we must target theri template form 
							for each ( layer in face.layersToImport) 
							{
								//see if this layer is empty
								if(layer.type == TextLayerVO.Type )
								{
									txtLayer = layer as TextLayerVO; 
									txtLayer.fontFamily = fontName 
								}
								/*if ( event.firstTime )
								{
								//some how need to collect the events 
								event.subEvents.push(bulkEvent )
								}*/
							}
						}
					}
				}
				else
				{
					for each ( bulkEvent in event.subEvents ) 
					{
						bulkEvent.performUndo() //how ot perforom redo?/ or the original undo or something ... 
					}
				}		
				this.model.blockUndoAdding = false
				//this.model.currentPage.updated();
				//this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.FONT_FAMILY_PRODUCT_CHANGED, event, null ) ) 
			}
			
			if ( event.type == EditProductCommandTriggerEvent.CHANGE_COLOR 
				&& this.model.currentLayer is ColorLayerVO ) 
			{
				if ( event.undo == false )
				{
					colorLayer = this.model.currentLayer as ColorLayerVO; 
					if ( event.firstTime ) 
					{
						/*txtLayer.x = 0; 
						txtLayer.y = 100; */
					}		
					event.oldData = colorLayer.color; 
					colorLayer.color = ( event.data ); 
					colorLayer.update('color'); 
					this.model.currentLayer = colorLayer; 
					event.data2 = colorLayer ; //don't like this feel like storing old layer should be automatic ...
				}
				else
				{
					colorLayer = event.data2 as ColorLayerVO; 
					colorLayer.color = ( event.oldData ); 
					colorLayer.update('color'); 
				}		
				//this.model.currentPage.updated();
				//this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.COLOR_CHANGED, event, null ) ) 
			}
			
			if ( event.type == EditProductCommandTriggerEvent.CHANGE_COLOR 
				&& this.model.currentLayer is TextLayerVO ) 
			{
				if ( event.undo == false )
				{
					txtLayer = this.model.currentLayer as TextLayerVO; 
					if ( event.firstTime ) 
					{
						/*txtLayer.x = 0; 
						txtLayer.y = 100; */
					}		
					event.oldData = txtLayer.color; 
					txtLayer.color = ( event.data ); 
					txtLayer.update('color'); 
					this.model.currentLayer = txtLayer; 
					event.data2 = txtLayer ; //don't like this feel like storing old layer should be automatic ...
					
				}
				else
				{
					txtLayer = event.data2 as TextLayerVO; 
					txtLayer.color = ( event.oldData ); 
					txtLayer.update('color'); 
				}		
				//this.model.currentPage.updated();
				//this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.COLOR_CHANGED, event, null ) ) 
			}
			
			
			//how to map this? ... use a string for layer association
			if ( event.type == EditProductCommandTriggerEvent.CHANGE_LAYER_COLOR 	) 
			{
				if ( event.undo == false )
				{
					//if ( event.data2 != null ) 
					//this.model.getColorLayer(event.data2 )
					
					colorLayer = this.model.layerColor; //this.model.currentLayer as ColorLayerVO; 
					//can specify layer name as well
					if ( event.data2 != null && event.data2 != '' ) 
					{
						var layerName : String = event.data2.toString()
						colorLayer = this.model.getLayerByName( layerName ) as ColorLayerVO; 
					}
					if ( colorLayer == null ) 
					{
						trace('EditProductCommand','warning:', 
							EditProductCommandTriggerEvent.CHANGE_LAYER_COLOR, 
							'cannot set color, color layer not defined'); 
						return; 
					}
					
					layer = colorLayer
					
					event.oldData = colorLayer.color; 
					colorLayer.color = ( event.data ); 
					colorLayer.update('color'); 
					event.data3 = colorLayer ;
					
					if ( this.lastUndoSameType() && lastUndo.data3 == layer ) 
					{
						if ( debugUndos ) trace('merging', event, event.type); 
						this.model.lastUndo.data = event.data; 
						this.model.lastUndo.data2 = event.data2
						addUndo = false; 
					}
				}
				else
				{
					colorLayer = event.data3 as ColorLayerVO; 
					colorLayer.color = ( event.oldData ); 
					colorLayer.update('color'); 
				}		
				//this.model.currentPage.updated();
				//this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.LAYER_COLOR_CHANGED, event, null ) ) 
			}
			
			//try to grab first face and load it 
			if ( event.type == EditProductCommandTriggerEvent.LOAD_PLAN ) 
			{
				if ( event.undo == false )
				{
					//event.oldData = this.model.cur
					var plan : PlanVO = event.data as PlanVO; 
					//load in face
				}
				else
				{
					undoable = false 
					//oldName = event.oldData.toString(); 
					//this.model.currentPage.name = oldName
				}		
				addUndo = false; 
				//this.model.currentPage.updated();
				this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.PLAN_LOADED, event, null ) ) 
			}
			
			//try to grab first face and load it 
			if ( event.type == EditProductCommandTriggerEvent.LOAD_PRODUCT ) 
			{
				if ( event.undo == false )
				{
					//event.oldData = this.model.cur
					var product : StoreItemVO = event.data as StoreItemVO; 
					face = event.data2 as FaceVO //use data2 to load a specific face
					if ( face == null ) 
						face = product.faces.getItemAt( 0 ) as FaceVO
					if ( face == null ) 
						throw 'EditProductCommand', 'LOAD_PRODUCT', 'create face first' 
					
					//load in product stuff 
					
					//load in face
					this.dispatch( new EditProductCommandTriggerEvent(
						EditProductCommandTriggerEvent.LOAD_FACE, face, null ) ) 
					/*	
					this.model.layers.removeAll();
					this.model.baseLayer = null; 
					if ( product.base_image_url != null ) 
					{
					imgLayer = new ImageLayerVO(); 
					imgLayer.name = 'Base Image';
					imgLayer.url = product.base_image_url; 
					imgLayer.locked = true; 
					imgLayer.showInList = false; 
					this.model.addLayer( imgLayer ) ;
					if ( event.firstTime ) 
					{
					imgLayer.x = 0; 
					imgLayer.y = 100; 
					}
					//this.model.currentLayer = imgLayer; 
					this.model.baseLayer = imgLayer; 
					
					//if layers are not predefied, add default, for testing purposes 
					if ( product.layers == null )
					{
					var colorLayer : ColorLayerVO = new ColorLayerVO(); 
					colorLayer.name = 'Color Base Image';
					colorLayer.url = product.base_image_url; 
					colorLayer.locked = true; 
					colorLayer.showInList = false; 
					this.model.addLayer( colorLayer ) ;
					if ( event.firstTime ) 
					{
					colorLayer.x = 0; 
					colorLayer.y = 100; 
					}
					this.model.layerColor = colorLayer; 
					
					//order doesn't matter as it doesn't appear ...
					imgLayer = new ImageLayerVO(); 
					imgLayer.name = 'Mask Image';
					imgLayer.url = product.base_image_url; 
					//imgLayer.url = 'assets/images/img.jpg'
					imgLayer.locked = true; 
					imgLayer.showInList = false; 
					imgLayer.mask = true; 
					this.model.addLayer( imgLayer ) ;
					if ( event.firstTime ) 
					{
					imgLayer.x = 0; 
					imgLayer.y = 100; 
					}
					//	this.model.currentLayer = imgLayer; 
					this.model.layerMask = imgLayer; 
					
					//this.model.currentLayer = colorLayer; 
					}
					else //add from layers 
					{
					//disable adding undos 
					this.model.blockUndoAdding = true; 
					
					if ( product.image_color_overlay != null && product.image_color_overlay != '' ) 
					{
					colorLayer = new ColorLayerVO(); 
					colorLayer.name = 'Color Base Image';
					colorLayer.url = product.image_color_overlay; 
					colorLayer.locked = true; 
					colorLayer.showInList = false; 
					this.model.addLayer( colorLayer ) ;
					if ( event.firstTime ) 
					{
					colorLayer.x = 0; 
					colorLayer.y = 100; 
					}
					this.model.layerColor = colorLayer; 
					}		
					
					
					for each ( layer in product.layers ) 
					{
					if ( layer is ImageLayerVO ) 
					{
					imgLayer = layer as ImageLayerVO
					this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.ADD_IMAGE_LAYER, imgLayer.url ) ) ; 
					}
					if ( layer is TextLayerVO ) 
					{
					txtLayer = layer as TextLayerVO
					this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.ADD_TEXT_LAYER, txtLayer.text ) ) ; 
					}								
					}	
					
					if ( product.image_mask !=null && product.image_mask != '' ) 
					{
					//use mask layer as well ..
					imgLayer = new ImageLayerVO(); 
					imgLayer.name = 'Mask Image';
					imgLayer.url = product.image_mask; 
					//imgLayer.url = 'assets/images/img.jpg'
					imgLayer.locked = true; 
					imgLayer.showInList = false; 
					imgLayer.mask = true; 
					this.model.addLayer( imgLayer ) ;
					//	this.model.currentLayer = imgLayer; 
					this.model.layerMask = imgLayer; 
					}	
					
					this.model.blockUndoAdding = false; 
					
					}
					}
					this.model.undo.clearAll(); 
					this.model.layersChanged(); */
				}
				else
				{
					undoable = false 
					//oldName = event.oldData.toString(); 
					//this.model.currentPage.name = oldName
				}		
				addUndo = false; 
				//this.model.currentPage.updated();
				this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.PRODUCT_LOADED, event, null ) ) 
			}
			
			
			//try to grab first face and load it 
			if ( event.type == EditProductCommandTriggerEvent.LOAD_FACE ) 
			{
				selectLayerWhenFinished = false; 
				undoable = false 
				if ( event.undo == false )
				{
					if ( this.model.currentFace != null ) 
						this.model.currentFace.currentLayer = this.model.currentLayer
					//event.oldData = this.model.cur
					face = event.data as FaceVO
					if ( face == null ) 
						throw 'EditProductCommand', 'LOAD_FACE', 'face is null'// face first' 
					this.model.currentFace = face; 
					//load in product stuff 
					//maybe save layers on the face?...
					//this.model.layers.removeAll();
					/*this.model.layers.source = face.layers.source; 
					this.model.layers.refresh(); */
					this.model.baseLayer = null; 
					this.model.layerMask = null; 
					this.model.layerColor = null; 
					this.model.waitForBaseLayer = [] 
					this.model.layers = face.layers; 
					var dbg : Array = [this.model.layers.length, this.model.layers.toArray() ] 
					//no need to remove? ... no b/c no is allowed to bind to thise, they bind to layersVisible...
					//reset masking ...					
					var v : viewer2_store = this.model.viewer as viewer2_store
					if ( v != null ) //the first time it might not have been set yet
					{	
						v.workspace.mask = null;//v.maskLayer_
						//v.maskBg.alpha
						v.maskBg.alpha = this.model.currentFace.image_mask_alpha; 
					}
					if ( face.imported ) 
					{
						//no need to import again
						
						
						for each ( layer in face.layers.toArray() ) 
						{
							if ( layer is ImageLayerVO ) 
							{
								imgLayer = layer as ImageLayerVO
								if ( imgLayer.mask == true ) 
									this.model.layerMask = layer; 
							}
							if ( layer is ColorLayerVO ) 
							{
								colorLayer = layer as ColorLayerVO
								this.model.layerColor = layer as ColorLayerVO; 
							}
							if ( layer is ImageLayerVO ) 
							{
								imgLayer = layer as ImageLayerVO
								if ( imgLayer.name == 'Base Image' ) //this is not safe ..
									this.model.baseLayer = imgLayer; 
							}
						}	
						
						
					}
					else //fisrt time 
					{
						
						this.model.baseLayer = null; 
						if ( face.base_image_url != null ) 
						{
							imgLayer = new ImageLayerVO(); 
							imgLayer.name = 'Base Image';
							imgLayer.base_layer = true; 
							imgLayer.url = face.base_image_url; 
							imgLayer.locked = true; 
							imgLayer.showInList = false; 
							this.model.addLayer( imgLayer ) ;
							/*if ( event.firstTime ) 
							{
							imgLayer.x = 0; 
							imgLayer.y = 100; 
							}*/
							//this.model.currentLayer = imgLayer; 
							this.model.baseLayer = imgLayer; 
						}	
						//if layers are not predefied, add default, for testing purposes 
						if ( face.layersToImport == null )// || face.layersToImport.length == 0 )
						{
							var colorLayer : ColorLayerVO = new ColorLayerVO(); 
							colorLayer.name = 'Color Base Image';
							colorLayer.url = face.base_image_url; 
							colorLayer.locked = true; 
							colorLayer.showInList = false; 
							this.model.addLayer( colorLayer ) ;
							/*if ( event.firstTime ) 
							{
							colorLayer.x = 0; 
							colorLayer.y = 100; 
							}*/
							this.model.layerColor = colorLayer; 
							
							//order doesn't matter as it doesn't appear ...
							imgLayer = new ImageLayerVO(); 
							imgLayer.name = 'Mask Image';
							imgLayer.url = face.base_image_url; 
							//imgLayer.url = 'assets/images/img.jpg'
							imgLayer.locked = true; 
							imgLayer.showInList = false; 
							imgLayer.mask = true; 
							this.model.addLayer( imgLayer ) ;
							/*if ( event.firstTime ) 
							{
							imgLayer.x = 0; 
							imgLayer.y = 100; 
							}*/
							//	this.model.currentLayer = imgLayer; 
							this.model.layerMask = imgLayer; 
							
							//this.model.currentLayer = colorLayer; 
						}
						else //add from layers 
						{
							//disable adding undos 
							this.model.blockUndoAdding = true; 
							//transfer fonts from product to face, if the face does not have any specified
							if ( face.fonts == null  ||   face.fonts.length == 0  ) 
							{
								if ( this.model.baseItem.fonts != null &&  this.model.baseItem.fonts.length > 0 ) 
								{
									face.fonts  =  this.model.baseItem.fonts
								}
							}
							if ( face.image_color_overlay != null && face.image_color_overlay != '' ) 
							{
								colorLayer = new ColorLayerVO(); 
								colorLayer.name = 'Color Base Image';
								colorLayer.url = face.image_color_overlay; 
								colorLayer.locked = true; 
								colorLayer.showInList = false; 
								this.model.addLayer( colorLayer ) ;
								/*if ( event.firstTime ) 
								{
								colorLayer.x = 0; 
								colorLayer.y = 100; 
								}*/
								this.model.layerColor = colorLayer; 
							}		
							
							
							if ( face.image_mask !=null && face.image_mask != '' ) 
							{
								//use mask layer as well ..
								imgLayer = new ImageLayerVO(); 
								imgLayer.name = 'Mask Image';
								imgLayer.url = face.image_mask; 
								//imgLayer.url = 'assets/images/img.jpg'
								imgLayer.locked = true; 
								imgLayer.showInList = false; 
								imgLayer.mask = true; 
								this.model.addLayer( imgLayer ) ;
								//	this.model.currentLayer = imgLayer; 
								this.model.layerMask = imgLayer; 
							}	
							
							
							for each ( layer in face.layersToImport ) 
							{
								this.importLayer(layer); 
								if ( layer is ImageLayerVO ) 
								{
									imgLayer = layer as ImageLayerVO
									this.dispatch( new EditProductCommandTriggerEvent(
										EditProductCommandTriggerEvent.ADD_IMAGE_LAYER, imgLayer ) ) ; 
								}
								if ( layer is TextLayerVO ) 
								{
									txtLayer = layer as TextLayerVO
									//transfer fonts from face to layer if not alreayd sepcified
									if ( txtLayer.fonts.length == 0 &&  face.fonts != null && face.fonts.length > 0 ) 
									{
										txtLayer.fonts = face.fonts; 
									}
									this.dispatch( new EditProductCommandTriggerEvent(
										EditProductCommandTriggerEvent.ADD_TEXT_LAYER, txtLayer ) ) ; 
								}	
								if ( layer is ColorLayerVO ) 
								{
									colorLayer = layer as ColorLayerVO
									colorLayer = colorLayer.clone() as ColorLayerVO ; 
									this.model.addLayer( colorLayer )
								}	
								if ( face.importFirstLayerSelection == layer ) 
								{
									for each ( var sl : LayerBaseVO in face.layers )
									{
										if ( sl.name == layer.name && sl.type == layer.type ) 
											var selectLayerFirst : LayerBaseVO  = sl;
									}
								}
							}	
							
							this.model.blockUndoAdding = false; 
							
						}
						face.imported = true
					}
					dbg = [this.model.layers.length, this.model.layers.toArray() ] 
					this.model.undo.clearAll(); 
					this.model.undoList.removeAll(); 
					this.model.recreateDisplayableLayers();
					//select user specified first layer 
					
					if ( event.firstTime && face.importFirstLayerSelection != null && selectLayerFirst != null ) 
					{
						/*if ( selectLayerFirst.visible == false ) 
						throw 'Error ' + ' Face ' +  face.name +  ' selectLayerFirst is not visible' */
						this.model.currentLayer = selectLayerFirst
					}
					else if ( face.currentLayer != null ) 
					{
						this.model.currentLayer = face.currentLayer
					}
					else
					{ //select any layer 
						this.model.currentLayer = this.model.getNextLayer();
					}
					this.model.calculateProductPrice();
					//this.model.layersChanged(); 
				}
				else
				{
					undoable = false 
					//oldName = event.oldData.toString(); 
					//this.model.currentPage.name = oldName
				}		
				//this.model.currentPage.updated();
				this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.FACE_LOADED, event, null ) ) 
			}
			
			
			
			
			
			/*	if ( event.type == EditProductCommandTriggerEvent.MOVE_LAYER ) 
			{
			
			//var oldName : String = this.model.currentPage.name
			//var newName : String = event.data.toString(); 
			if ( event.undo == false )
			{
			layer = this.model.currentLayer
			event.oldData = layer.x; 
			event.oldData2 = layer.y 
			var x : Number = event.data as Number
			var y : Number =event.data2 as Number
			layer.x = x
			layer.y = y 
			event.data3 = layer
			}
			else
			{
			layer = event.data3 as LayerBaseVO ;
			layer.x =event.oldData as Number 
			layer.y = event.oldData2 as Number 
			}		
			//this.model.currentPage.updated();
			this.model.layersChanged(); 
			this.dispatch( new EditProductCommandTriggerEvent(
			EditProductCommandTriggerEvent.LAYER_MOVED, event, null ) ) 
			}*/
			if ( event.type == EditProductCommandTriggerEvent.MOVE_LAYER ) 
			{
				if ( event.undo == false )
				{
					var layer : LayerBaseVO = this.model.currentLayer as LayerBaseVO; 
					
					/*	if ( layer.x == event.data && layer.y == event.data2 ) 
					return; */
					//inhibit redundancy
					if ( layer.x == event.data && layer.y == event.data2 ) 
						return;
					//lastUndo
					
					
					//override curnet layer 
					if ( event.data3 != null ) 
						layer = event.data3 as LayerBaseVO
					event.oldData = layer.x; 
					event.oldData2 = layer.y; 
					this.model.blockUndoExecution=true
					layer.setXY( event.data, event.data2 ) ; 
					layer.update(); 
					event.data3 = layer ; 
					this.model.blockUndoExecution=false
					//this has the added benefit of surpressing x's and y only updates ... it merges them
					if ( this.lastUndoSameType() && lastUndo.data3 == layer ) 
					{
						if ( debugUndos ) trace('merging', event, event.type); 
						this.model.lastUndo.data = event.data; 
						this.model.lastUndo.data2 = event.data2
						addUndo = false; 
					}
					
					//if ( debugUndos ) trace('go', event.data, event.data2 )
				}
				else
				{
					this.model.blockUndoExecution=true
					layer = event.data3 as LayerBaseVO; 
					layer.setXY( event.oldData, event.oldData2 ) ; 
					layer.update(); 
					if ( debugUndos ) trace('redo', event.data, event.data2 )
					this.model.blockUndoExecution=false
				}		
				//this.model.currentPage.updated();
				//this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.LAYER_MOVED, event, null ) ) 
			}	
			
			if ( event.type == EditProductCommandTriggerEvent.CHANGE_TEXT ) 
			{
				if ( event.undo == false )
				{
					
					txtLayer = this.model.currentLayer as TextLayerVO 
					if ( event.firstTime ) 
						selectLayerWhenFinished  = false 
					//override curnet layer 
					if ( event.data2 != null ) 
						txtLayer = event.data2 as TextLayerVO
					
					//inhibit redundancy
					if ( txtLayer.text == event.data ) 
						return; //leave early							
					layer =  txtLayer
					event.oldData = txtLayer.text; 
					this.model.blockUndoExecution=true
					txtLayer.text= event.data.toString()
					txtLayer.adjustDisplayText();
					layer.update( TextLayerVO.PROP_UPDATED_TEXT); 
					event.data2 = txtLayer ; 
					this.model.blockUndoExecution=false
					
					if ( this.lastUndoSameType() && lastUndo.data2 == layer ) 
					{
						if ( debugUndos ) trace('merging', event, event.type); 
						this.model.lastUndo.data = event.data; 
						this.model.lastUndo.data2 = event.data2
						addUndo = false; 
					}
					
					//if ( debugUndos ) trace('go', event.data, event.data2 )
				}
				else
				{
					this.model.blockUndoExecution=true
					txtLayer = event.data2 as TextLayerVO; 
					txtLayer.text = event.oldData.toString()
					txtLayer.update(); 
					if ( debugUndos ) trace('redo', event.data, event.data2 )
					this.model.blockUndoExecution=false
				}		
				//this.model.currentPage.updated();
				//this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.TEXT_CHANGED, event, null ) ) 
			}	
			
			
			if ( event.type == EditProductCommandTriggerEvent.RESIZE_LAYER ) 
			{
				if ( event.undo == false )
				{
					layer = this.model.currentLayer as LayerBaseVO; 
					
					//specific target laery is store on 3
					if ( event.data3 != null ) 
						layer = event.data3 as LayerBaseVO
					event.oldData = layer.width; 
					event.oldData2 = layer.height; 
					this.model.blockUndoExecution=true
					layer.setWH( event.data, event.data2 ) ; 
					layer.update(); 
					event.data3 = layer ; 
					this.model.blockUndoExecution=false
					
					/*
					* two issues:
					if the last Undo was a move on same layer, and the x,y has obv no
					* */
					//trace('go', event.data, event.data2 )
					
					if ( event.firstTime ) //this automerging is only relevant the first time //??
					{
						//to keep resizing consistent, objecthandles moves xy then sets rotation 
						//we must remove that event ... there is no time for a user to act inbetween, so 
						//we can safetly remove it 
						if (lastUndo != null &&  lastUndo.type == EditProductCommandTriggerEvent.MOVE_LAYER &&
							lastUndo.data3 == layer ) 
						{
							popuppedEvent = this.popUndo()
							event.autoSubEvents.push( popuppedEvent ) ; 
							//step 2: try to test if the event on top of stack is a similiar type
							lastUndo = this.popUndo()//pop so we can examine it 
							this.model.lastUndo = lastUndo; //we have to do this b/c lastUndoSameType looks at the model
							if ( lastUndo != null ) //watch out b/c first time .. it is null
								this.pushUndo( lastUndo ) ; //put it back 
							
							if ( this.lastUndoSameType() && lastUndo.data3 == layer ) 
							{
								if ( debugUndos ) trace('merging', event, event.type); 
								this.model.lastUndo.data = event.data; 
								//this.model.lastUndo.data2 = event.data2
								addUndo = false; 
								/**
								 * remove subevent and update first one ... sothere is only 1 
								 * */
								//lastUndo.autoSubEvents.pop()//( popuppedEvent ) ; 
								firstSubEvent = 	lastUndo.autoSubEvents[0] as EditProductCommandTriggerEvent
								firstSubEvent.data = popuppedEvent.data; 
								firstSubEvent.data2 = popuppedEvent.data2
								
								//update old rotation? no? 
								addUndo = false; 
							}
							
						}
					}
					
					
				}
				else
				{
					this.model.blockUndoExecution=true
					layer = event.data3 as LayerBaseVO; 
					layer.setWH( event.oldData, event.oldData2 ) ; 
					layer.update(); 
					//trace('redo', event.data, event.data2 )
					this.model.blockUndoExecution=false
				}		
				//this.model.currentPage.updated();
				//this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.LAYER_RESIZED, event, null ) ) 
			}	
			
			if ( event.type == EditProductCommandTriggerEvent.ROTATE_LAYER ) 
			{
				if ( event.undo == false )
				{
					layer = this.model.currentLayer as LayerBaseVO; 
					
					if ( event.data3 != null ) 
						layer = event.data3 as LayerBaseVO
					event.oldData = layer.rotation; 
					this.model.blockUndoExecution=true
					layer.rotation = Number( event.data )
					if ( layer.model != null ) 
						layer.model.rotation = layer.rotation 
					layer.update(); 
					event.data3 = layer ; 
					this.model.blockUndoExecution=false
					//trace('go', event.data, event.data2 )
					//this.popLstUndo()
					if ( event.firstTime ) //this automerging is only relevant the first time //??
					{
						//to keep ceterpoint consistent, objecthandles moves xy then sets rotation 
						//we must remove that event ... there is no time for a user to act inbetween, so 
						//we can safetly remove it 
						if ( lastUndo != null && lastUndo.type == EditProductCommandTriggerEvent.MOVE_LAYER && lastUndo.data3 == layer ) 
						{
							var popuppedEvent : EditProductCommandTriggerEvent = this.popUndo()
							event.autoSubEvents.push( popuppedEvent ) ; 
							//step 2: try to test if the event on top of stack is a similiar type
							lastUndo = this.popUndo()//pop so we can examine it 
							this.model.lastUndo = lastUndo; //we have to do this b/c lastUndoSameType looks at the model
							if ( lastUndo != null ) //watch out b/c first time .. it is null
								this.pushUndo( lastUndo ) ; //put it back 
						}
						if ( this.lastUndoSameType() && lastUndo.data3 == layer ) 
						{
							if ( debugUndos ) trace('merging', event, event.type); 
							this.model.lastUndo.data = event.data; 
							//this.model.lastUndo.data2 = event.data2
							addUndo = false; 
							/**
							 * remove subevent and update first one ... sothere is only 1 
							 * */
							//lastUndo.autoSubEvents.pop()//( popuppedEvent ) ; 
							var firstSubEvent : EditProductCommandTriggerEvent = 
								lastUndo.autoSubEvents[0] as EditProductCommandTriggerEvent
							firstSubEvent.data = popuppedEvent.data; 
							firstSubEvent.data2 = popuppedEvent.data2
							
							//update old rotation? no? 
							addUndo = false; 
						}
					}
				}
				else
				{
					this.model.blockUndoExecution=true
					layer = event.data3 as LayerBaseVO; 
					layer.rotation = Number( event.oldData )
					//layer should do this auto but i will here for quick test , 
					//move this later
					if ( layer.model != null ) 
						layer.model.rotation = layer.rotation 
					layer.update(); 
					//trace('redo', event.data, event.data2 )
					this.model.blockUndoExecution=false
				}		
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.LAYER_ROTATED, event, null ) ) 
			}	
			
			
			if ( event.type == EditProductCommandTriggerEvent.REMOVE_LAYER ) 
			{
				if ( event.undo == false )
				{
					selectLayerWhenFinished = false 
					layer = event.data as LayerBaseVO; 
					var layerIndex : int = this.model.layers.getItemIndex( layer ) ; 
					
					//var nextLayerIndex : int = layerIndex+1
					
					if ( layer.prompt_layer == true && 
						this.model.currentFace.can_remove_prompt_layers == false ) 
					{
						///could forward this to chanve visiblity ...
						layer.visible = false; 
						layer.update(); 
						//return;
					}		
					else
					{
						this.model.removeLayer( layer ) ; 
						layer.layerRemoved()
					}
					//if ( nextLayerIndex >= this.model.layers.length ) 
					//	nextLayerIndex = 0
					//var nextLayer : LayerBaseVO = this.model.layers.getItemAt( nextLayerIndex) as LayerBaseVO;
					var nextLayer : LayerBaseVO = this.model.getNextLayer() ;
					this.model.currentLayer =nextLayer
				}
				else
				{
					layer = event.data as LayerBaseVO; 
					if ( layer.prompt_layer == true && 
						this.model.currentFace.can_remove_prompt_layers == false ) 
					{
						layer.visible = true; 
						layer.update(); 
						this.model.currentLayer = layer; 
						return;
					}		
					else
					{
						this.model.addLayer( layer ) ; 
						this.model.currentLayer = layer; 
					}
					//layer.update(); 
				}		
				//this.model.currentPage.updated();
				this.model.layersChanged(); 
				this.dispatch( new EditProductCommandTriggerEvent(
					EditProductCommandTriggerEvent.LAYER_REMOVED, event, null ) ) 
			}	
			
			if ( event.firstTime && undoable && this.model.blockUndoAdding == false) 
			{
				var lastUndo : EditProductCommandTriggerEvent = this.model.lastUndo
				if ( lastUndo != null && lastUndo.type == event.type ) 
				{
					/*if ( event.type == EditProductCommandTriggerEvent.MOVE_LAYER
					&& event.data3 == lastUndo.data3) //check for time
					{
					if ( debugUndos ) trace('merging', event, event.type); 
					this.model.lastUndo.data = event.data; 
					this.model.lastUndo.data2 = event.data2
					//this.model.lastUndo.time = new Date()
					return; 
					}*/
					if ( event.type == EditProductCommandTriggerEvent.RESIZE_LAYER
						&& event.data3 == lastUndo.data3) //check for time
					{
						if ( debugUndos ) trace('merging', event, event.type); 
						this.model.lastUndo.data = event.data; 
						this.model.lastUndo.data2 = event.data2
						//this.model.lastUndo.time = new Date()
						return; 
					}
				}
				
				if ( addUndo ) 
				{
					if ( debugUndos ) trace('addeded one', event.type)
					this.model.lastUndo = event; 
					this.model.undo.pushUndo( event ) ;
					this.model.undoList.addItem(event);
					this.dispatch( new NightStandModelEvent(NightStandModelEvent.UNDOS_CHANGED) )
				}
				if ( resetTimer ) 
				{
					this.model.lastUndoAddDate = new Date(); 
				}
			}
			
			//trace('undo', this.model.undo
			
			//handle auto events
			if ( event.undo || event.redo ) 
			{
				var oldBlockSetting : Boolean = this.model.blockUndoAdding
				this.model.blockUndoAdding = true; 
				for each ( var autoEvent : EditProductCommandTriggerEvent in this.event.autoSubEvents ) 
				{
					if ( event.undo ) 
						autoEvent.performUndo()
					else
						autoEvent.performRedo(); 
				}
				
				this.model.blockUndoAdding = oldBlockSetting
			}
			
			
			//reset timer in wrong place?
			
			
			if ( layer != null && selectLayerWhenFinished ) 
			{
				if ( selectThisLayer == null ) 
				{
					if ( layer != null ) 
						this.model.currentLayer = layer;
				}
				else
				{
					this.model.currentLayer = selectThisLayer;
				}
			}
			
			if ( event.fxPost != null ) 
				event.fxPost(); 
		}
		
		/***
		 * Store import x's for later
		 * */
		private function importLayer(layer:LayerBaseVO):void
		{
			if ( ! isNaN( layer.x ) )
			{
				layer.importX = layer.x;
				layer.horizStartAlignment  = ''; 
			}
			if ( ! isNaN( layer.y ) )
			{
				layer.importY = layer.y;
				layer.vertStartAlignment = ''; 
			}
			if ( ! isNaN( layer.height ) )
			{
				layer.importHeight = layer.height;
			}
			if ( ! isNaN( layer.width ) )
			{
				layer.importWidth = layer.width;
			}			
			
		}		
		
		/**
		 * shorten some of code above ..
		 * */
		private function lastUndoSameType(timePast:Number=2) : Boolean
		{
			if ( this.model.lastUndo != null && this.model.lastUndo.type == event.type )
			{
				if ( timePast <= 0 ) 
				{
					return true 	
				}
				else
				{
					var currentTime : Date = new Date(); 
					var diff : Number =currentTime.getTime() - this.model.lastUndoAddDate.getTime()
					diff = diff / 1000
					//if last time has past, return same 
					if ( diff < timePast ) 
						return true
					else
						return false; 
				}
			}
			
			
			return false; 
		}
		
		private function popUndo( ) : EditProductCommandTriggerEvent
		{
			var popedEvent : EditProductCommandTriggerEvent = 
				this.model.undo.popUndo()	as EditProductCommandTriggerEvent
			if ( popedEvent != null ) 
				this.model.undoList.removeItemAt( this.model.undoList.toArray().length-1 ); 
			return popedEvent
		}
		private function pushUndo( u: EditProductCommandTriggerEvent ) : void
		{
			this.model.undo.pushUndo( u ) ; 
			this.model.undoList.addItem( event ) 
		}
		
	}
}