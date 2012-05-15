package  org.syncon.CncSim.controller
{
	import com.adobe.serialization.json.JSON;
	
	import mx.controls.Alert;
	import mx.controls.Text;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.ViridConstants;
	import org.syncon.CncSim.vo.ColorLayerVO;
	import org.syncon.CncSim.vo.FaceVO;
	import org.syncon.CncSim.vo.FontVO;
	import org.syncon.CncSim.vo.ImageLayerVO;
	import org.syncon.CncSim.vo.LayerBaseVO;
	import org.syncon.CncSim.vo.StoreItemVO;
	import org.syncon.CncSim.vo.TextLayerVO;
	
	
	
	public class ImportViridJSONCommand extends Command
	{
		[Inject] public var model:NightStandModel;
		[Inject] public var event:ImportViridJSONCommandTriggerEvent;
		
		
		
		override public function execute():void
		{
			if ( event.type == ImportViridJSONCommandTriggerEvent.IMPORT_JSON ) 
			{
				this.importProduct()
				
			}	
			
			
		}
		
		
		private function importProduct():void
		{
			event.str;
			var json:Object = JSON.decode(event.str);
			trace();	
			var product:StoreItemVO = new StoreItemVO;
			product.name = json.name ;
			
			product.sku = json.sku; 
			if(json.hasOwnProperty( 'price' )) 
				product.price = json.price;
			else
				product.price = 0;
			
			//json.Faces.push( json.Faces[0] ) //remove after debugging 
			
			for each( var faceImport:Object in json.Faces  )
			{
				var face : FaceVO = new FaceVO()
				face.name = faceImport.name;
				/*if ( faceImport.image.indexOf( '/customize/' ) == 0 ) 
				faceImport.image = faceImport.image.replace('/customize/', ''  ) ;*/
				face.base_image_url = faceImport.image;
				
				face.image_mask_alpha = .9;
				///face.base_image_url = 'assets/images/imgbase.png'
				if(faceImport.mask == null || faceImport.mask == "null")
					face.image_mask ="";
				else
					face.image_mask = faceImport.mask;
				
				product.faces.addItem( face );
				face.layersToImport = []; 
				for each(var layerImport:Object in faceImport.Layers)
				{
					
					if(layerImport.type == "color")
					{
						
						
						var colorLayer  : ColorLayerVO = new ColorLayerVO;
						colorLayer.name = layerImport.name;
						colorLayer.name = 'Color Layer';
						colorLayer.cost = layerImport.price;
						colorLayer.url = faceImport.mask;
						colorLayer.showInList = true;
						colorLayer.prompt_layer = true;
						//set incoming color for color layer
						if(layerImport.Media.hasOwnProperty("source") && layerImport.Media.source != ""){
							face.color_overlay_layer = '0x' +layerImport.Media.source;///TODO: wth are we doing here?
							colorLayer.color = '0x'+layerImport.Media.source;
						}
						else{
							colorLayer.color = "0xffffff";
						}
						/*else if(layerImport.hasOwnProperty("color")){
						face.color_overlay_layer = '0x' +layerImport.color;///TODO: wth are we doing here?
						colorLayer.color = '0x'+layerImport.color;
						}*/
						
						colorLayer.locked = true; //all masks should be locked by default 
						if ( layerImport.hasOwnProperty( 'required' ) ) 
							colorLayer.required = layerImport.required;
						
						if( layerImport.hasOwnProperty( 'default' ) && layerImport.default == true  )
							face.importFirstLayerSelection = colorLayer; 
						face.layersToImport.push(colorLayer);
						
					}
					else if(layerImport.type == "image")
					{
						var imageLayer: ImageLayerVO = new ImageLayerVO;
						
						imageLayer.prompt_layer = true; 
						//imageLayer.locked = true;
						
						imageLayer.image_source = ViridConstants.IMAGE_SOURCE_UPLOAD
						imageLayer.url = layerImport.Media.source;
						this.copyBasics(imageLayer, layerImport );
						
						if( layerImport.hasOwnProperty( 'default' ) && layerImport.default == true  )
							face.importFirstLayerSelection = imageLayer; 
						face.layersToImport.push(imageLayer);
						
						
					}
					else if(layerImport.type == "monogram" || layerImport.type == "engrave")
					{
						var textLayer: TextLayerVO = new TextLayerVO;
						
						textLayer.prompt_layer = true; 
						textLayer.locked = true;
						
						textLayer.subType = ViridConstants.SUBTYPE_ENGRAVE;
						
						this.copyBasics(textLayer, layerImport );
						if(textLayer.name.indexOf("Top") >= 0){
							face.importFirstLayerSelection = textLayer;
						}
						textLayer.text = layerImport.Media.source;
						textLayer.maxChars = layerImport.Media.max
						//TODO: orientation has been removed
						textLayer.verticalText = layerImport.orientation=='vertical';
						textLayer.fontSize = layerImport.Fonts[0].size;//for engraving
						
						
						if(layerImport.type == "engrave"){						
							textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
							textLayer.maxFontSize = 35
							textLayer.minFontSize = 8
						}
						
						//go through each font
						var fonts:Array = [];
						for each(var fontIncoming:Object in layerImport.Fonts)
						{
							var font:FontVO = new FontVO();
							font.name = fontIncoming.name;
							font.swf_name = fontIncoming.swfname;
							font.defaultSize = fontIncoming.size;
							font.weight = fontIncoming.weight;
							
							if(fontIncoming.hasOwnProperty('maxSize') && fontIncoming.maxSize != "" && fontIncoming.maxSize != null)
							{
								textLayer.maxFontSize = fontIncoming.maxSize;
							}
							if(fontIncoming.hasOwnProperty('minSize') && fontIncoming != "" && fontIncoming != null)
							{
								textLayer.maxFontSize = fontIncoming.minSize;
							}
							
							fonts.push(font);
							
						}
						textLayer.fonts = fonts;
						if(fonts.length > 0 )
							textLayer.fontFamily = ( fonts[0].swf_name != null )?fonts[0].swf_name : fonts[0].name;
						
						
						if(layerImport.Media.hasOwnProperty( 'font' ) && layerImport.Media.font != '')
						{
							var validFont:Boolean = false;
							//if the layer already has a font set, use that.
							for each(var fontToCheck:Object in textLayer.fonts)//but check it first to make sure its an eligible font
							{
								if(fontToCheck.hasOwnProperty('name') && layerImport.Media.font == fontToCheck.name)
								{
									
									//Alert.show('valid font');
									validFont = true;
								}
							}
							if(validFont)
							{
								textLayer.fontFamily = layerImport.Media.font;
								//Alert.show('We recieved a request for an invalid font - font reset to first available valid font','DEBUG');
							}
							
						}
						textLayer.text = layerImport.Media.source;
						
						textLayer.vertStartAlignment="";
						textLayer.horizStartAlignment="";
						
						
						
						if( layerImport.hasOwnProperty( 'default' ) && layerImport.default == true  )
							face.importFirstLayerSelection = textLayer; 
						face.layersToImport.push(textLayer);
						
					}
					else if(layerImport.type == "text")
					{
						textLayer  = new TextLayerVO;
						
						this.copyBasics(textLayer, layerImport );
						
						textLayer.prompt_layer = true; 
						//this.copyBasics(textLayer, layerImport );
						//TODO: orientation has been removed
						textLayer.verticalText = layerImport.orientation=='vertical';
						textLayer.maxChars = layerImport.Media.max
						if( layerImport.Media.hasOwnProperty( 'fontsize' ) && layerImport.Media.fontsize != null && layerImport.Media.fontsize != '' )
							textLayer.fontSize = layerImport.Media.fontsize;
						else
							textLayer.fontSize = 20;
						if( layerImport.Media.hasOwnProperty( 'color' ) && layerImport.Media.color != null && layerImport.Media.color != '' )
							textLayer.color = '0x'+layerImport.Media.color
						fonts = [];
						for each(  fontIncoming  in layerImport.Fonts)
						{
							 font = new FontVO();
							font.name = fontIncoming.name;
							font.swf_name = fontIncoming.swfname;
							font.defaultSize = fontIncoming.size;
							font.weight = fontIncoming.weight;
							
							fonts.push(font);
							
						}
						textLayer.fonts = fonts;
						if(fonts.length > 0 )
							textLayer.fontFamily = ( fonts[0].swf_name != null )?fonts[0].swf_name : fonts[0].name;
						if(layerImport.Media.hasOwnProperty( 'font' ))
							textLayer.fontFamily = layerImport.Media.font;
						textLayer.text = layerImport.Media.source;
						
						if(textLayer.text == "" && textLayer.x == 0 && textLayer.y == 0)
						{
							textLayer.vertStartAlignment = LayerBaseVO.ALIGNMENT_CENTER;
							textLayer.horizStartAlignment = LayerBaseVO.ALIGNMENT_CENTER;
							//if you don' tset to NaN EditProductCommand importLayer will remove the vert alignment
							//need to work out which intention is prefered ...
							textLayer.x = 0+30; //give some padding .. 
							textLayer.y = NaN; 
						}
						
						if( layerImport.hasOwnProperty( 'default' ) && layerImport.default == true  )
							face.importFirstLayerSelection = textLayer; 
						face.layersToImport.push(textLayer);
						
					}
					else if(layerImport.type == "clipart")
					{
						imageLayer  = new ImageLayerVO;
						imageLayer.prompt_layer = true;
						
						this.copyBasics(imageLayer, layerImport );
						imageLayer.url = layerImport.Media.source;
						imageLayer.image_source = ViridConstants.IMAGE_SOURCE_CLIPART	
						if(imageLayer.url == null || imageLayer.url == "" )
							imageLayer.visible = false;
						
						if( layerImport.hasOwnProperty( 'default' ) && layerImport.default == true  )
							face.importFirstLayerSelection = imageLayer; 
						
						if ( imageLayer.url != '' && imageLayer.url != null ) 
							imageLayer.name = this.model.convertClipArtToName(imageLayer.url); 
						
						face.layersToImport.push(imageLayer);
						
						
						
					}
					else if(layerImport.type == "hidden"){
						var hiddenLayer : TextLayerVO = new TextLayerVO;
						this.copyBasics(hiddenLayer, layerImport );
						hiddenLayer.showInList = false;
						hiddenLayer.locked = true; 
						hiddenLayer.visible = false;
						hiddenLayer.hidden = true;
						hiddenLayer.subType = ViridConstants.SUBTYPE_ENGRAVE;
						face.layersToImport.push(hiddenLayer);
						//hiddenLayer.
					}
					
					
				}
				
				if(face.importFirstLayerSelection == null){
					
				}
			}
			//face.layersToImport = [];
			this.model.baseItem = product;
			this.printObject( json ) ; 
		}
		
		
		private function printObject(product:Object):void
		{
			// TODO Auto Generated method stub
			var result : String =  traceObject( product ) 
			trace( result ) ;  
		}		
		static public  function traceObject(obj:*,level:int=0,output:String=""):*{
			var tabs:String = "";
			for(var i:int=0; i<=level; i++)//, tabs+="\t")
			{
				
				tabs += "\t";
				
				tabs = ''; 
				for ( var j : int = 0 ; j < level; j++ ) 
				{
					tabs += "\t";
				}
				
				for(var child:* in obj)
				{
					output += tabs +"["+ child +"] => "+obj[child];
					var childOutput:String=traceObject(obj[child], level+1);
					if(childOutput!='')
					{
						output+=' {\n'+childOutput+tabs +'}';
					}
					output += "\n";
				}
				return output;
			}
		}
		
		private function copyBasics(layer:LayerBaseVO, layerImport:Object):void
		{
			// TODO Auto Generated method stub
			if( layerImport.hasOwnProperty( 'name' )  ){
				layer.name = layerImport.name;
				layer.nameHidden = layerImport.name;
			}
			if( layerImport.hasOwnProperty( 'price' )  )
				layer.cost = layerImport.price; 
			if ( layerImport.hasOwnProperty( 'required' ) ) 
				layer.required = layerImport.required
			if( layerImport.transform.hasOwnProperty( 'width' ) && layerImport.transform.width != null ){		
				layer.width = layerImport.transform.width;
				layer.horizStartAlignment = "";
				layer.vertStartAlignment = "";
			}
			if( layerImport.transform.hasOwnProperty( 'height' )  ){
				layer.height = layerImport.transform.height;
				layer.horizStartAlignment = "";
				layer.vertStartAlignment = "";
			}
			if( layerImport.transform.hasOwnProperty( 'x' )  ){
				layer.x = layerImport.transform.x;	
				layer.horizStartAlignment = "";
				layer.vertStartAlignment = "";
				
			}			
			if( layerImport.transform.hasOwnProperty( 'y' )  ){
				layer.y = layerImport.transform.y;
				layer.horizStartAlignment = "";
				layer.vertStartAlignment = "";
			}
			if( layerImport.transform.hasOwnProperty( 'rotation' )  )
				layer.rotation = layerImport.transform.rotation;
		}
		
	}
}