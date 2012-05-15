package org.syncon.CncSim.controller
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.CncSim.model.NightStandModel;
	import org.syncon.CncSim.model.ViridConstants;
	import org.syncon.CncSim.vo.BehaviorVO;
	import org.syncon.CncSim.vo.CollectiveLayerPriceVO;
	import org.syncon.CncSim.vo.ColorLayerVO;
	import org.syncon.CncSim.vo.FaceVO;
	import org.syncon.CncSim.vo.FontVO;
	import org.syncon.CncSim.vo.ImageLayerVO;
	import org.syncon.CncSim.vo.ImageVO;
	import org.syncon.CncSim.vo.PlanVO;
	import org.syncon.CncSim.vo.StoreItemVO;
	import org.syncon.CncSim.vo.TextLayerVO;
	import org.syncon2.utils.MakeVOs;
	
	/**
	 *
	 * */
	public class InitMainContextCommand extends Command
	{
		[Inject] public var model:NightStandModel;
		[Inject] public var event:InitMainContextCommandTriggerEvent;
		
		override public function execute():void
		{
			if ( event.type == InitMainContextCommandTriggerEvent.INIT ) 
			{
				this.model.showAds = event.showAds
				this.model.flex = event.flex; 
				
				if ( this.model.flex == false ) 
				{
					/*	airFeatures = new AirFeaturesClass()*/
					/*	airFeatures.disableKeyLock(); */
				}
			}
			if ( event.type == InitMainContextCommandTriggerEvent.INIT2 ) 
			{
				if ( this.model.flex == false ) 
				{
					/*AirFeaturesClass['stage'] = this.contextView.stage*/
					//airFeatures.goIntoFullscreenMode(); 
				}
			}	
			
			if ( event.type == InitMainContextCommandTriggerEvent.CREATE_CLIP_ART_LIBRARY ) 
			{
				this.createClipArtImages(); 
				
			}	
			if ( event.type == InitMainContextCommandTriggerEvent.INIT3_MAKEUP_FLEX_DATA ) 
			{
				//this.createDefaultProduct() ; 
				
				this.createDetailedDefaultProduct();
				//this.createDetailedDefaultProduct_Engrave()
				//this.createDetailedDefaultProduct_Engrave2(false)
				if ( this.model.flex ) 
				{
					
				}
			}
			if ( event.type == InitMainContextCommandTriggerEvent.CREATE_FAKE_CNCSIM_DATA ) 
			{
				//this.createDefaultProduct() ; 
				
				this.createFakeCNCSimData();
				//this.createDetailedDefaultProduct_Engrave()
				//this.createDetailedDefaultProduct_Engrave2(false)
				if ( this.model.flex ) 
				{
					
				}
			}	
			
			if ( event.type == InitMainContextCommandTriggerEvent.EXIT_APP ) 
			{
				if ( this.model.flex == false ) 
				{
				}
			}
			
			
			
			
			
		}
		
		private function createFakeCNCSimData():void
		{
			var march : Boolean = false; 
			if ( 5,march==true) {
				trace(1,'false'); 				
			}
			if ( 5,march==true) {
				trace(1,'false'); 				
			}
			if ( 5,march==false) {
				trace(2,'false'); 
			}
			if ([ 5,march==false]) {
				trace(3,'false'); 
			}
			var dbg : Array =[ [5,march==false]==true,  [5,march==false]==false, Boolean( [5,march==false]) ]
			var ee : MakeVOs
			var names : Array = MakeVOs.makeNames( 10, 'Behavior '); 
			var objs : Array = MakeVOs.makeObjs( names, BehaviorVO ) ; 
			var descs : Array =  MakeVOs.makeNames( 10, 'Description  ');
			MakeVOs.setValOnObjs( objs, descs, 'description' ) ;
			
			var plan : PlanVO = new PlanVO()
			plan.name = 'Plan 1'
			plan.loadBehaviors( objs ) 
			this.model.currentPlan = plan 
			
		}
		
		private function createClipArtImages():void
		{
			/*var names : Array = [] ; 
			for (var i : int = 0 ; i < 150; i++ )
			{
			names.push( 'Title ' + i.toString() ) ; 
			}
			var imgs : Array = MakeVOs.makeObjs( names, ImageVO, 'name' )
			for each ( var img : ImageVO in imgs ) 
			{
			img.url = 'assets/images/img.jpg'; 
			}*/
			
			
			
			var prefix : String = "assets/images/zippoLibrary/clipart/";
			var cprefix : String = "assets/images/zippoLibrary/clipart/color/";
			var backprefix : String = "assets/images/zippoLibrary/clipart/set2/";
			var set3prefix : String = "assets/images/zippoLibrary/clipart/set3/";
			var set4prefix : String = "assets/images/zippoLibrary/clipart/set4/";
			var importImages : Array = [
				/*
				['Four Pointed Star', prefix + '4ptstar-01.png'],
				['Airplane', prefix + 'airplane.png'],
				['US Flag', prefix + 'americanflag-01.png'],
				['Angel', prefix + 'angel.png'],
				['Apple', prefix + 'apple.png'],
				
				
				
				//				['Four Pointed Star' , prefix + '4ptstar.png'],
				['Airplane' , prefix + 'airplane.png'],
				['American Flag' , prefix + 'americanflag.png'],
				['Angel' , prefix + 'angel.png'],
				['Apple' , prefix + 'apple.png'],
				//				['Ballons' , prefix + 'ballons.png'],
				['Baseball' , prefix + 'baseball.png'],
				['Baseball Bats' , prefix + 'baseballbats.png'],
				['Basket Ball' , prefix + 'basketball.png'],
				['Bats' , prefix + 'bats.png'],
				//				['Beer Bottle' , prefix + 'beerbottle.png'],
				['Biohazard' , prefix + 'biohazard.png'],
				['Birthday Cake' , prefix + 'birthdaycake.png'],
				['Black Cat' , prefix + 'blackcat.png'],
				//				['Bulklet' , prefix + 'bullet.png'],
				['Butterfly' , prefix + 'butterfly.png'],
				['Candle' , prefix + 'candle.png'],
				['Carpenter' , prefix + 'carpenter.png'],
				['Checkered Flag' , prefix + 'checkflag.png'],
				//				['Clover' , prefix + 'clover.png'],
				['Club' , prefix + 'club.png'],
				['Cross' , prefix + 'cross.png'],
				['Deer' , prefix + 'deer.png'],
				['Diamond' , prefix + 'diamond.png'],
				['Dice' , prefix + 'dice.png'],
				//				['Directory' , prefix + 'directory.txt'],
				['Doctor' , prefix + 'doctor.png'],
				['Dog Tags' , prefix + 'dogtags.png'],
				['Dove' , prefix + 'dove.png'],
				['Eagle' , prefix + 'eagle.png'],
				['Fireworks' , prefix + 'fireworks.png'],
				['Fisherman' , prefix + 'fisherman.png'],
				['Football' , prefix + 'football.png'],
				['Golfer' , prefix + 'golfer.png'],
				['Graduation Hat' , prefix + 'graduationhat.png'],
				['Guitar' , prefix + 'guitar.png'],
				['Gun' , prefix + 'gun.png'],
				['Heart 1' , prefix + 'heart1.png'],
				['Heart 2' , prefix + 'heart2.png'],
				['Hearts' , prefix + 'hearts.png'],
				['Helicopter' , prefix + 'helicopter.png'],
				['Hockey Sticks' , prefix + 'hockeysticks.png'],
				['Holly Berry' , prefix + 'hollyberry.png'],
				['Horse Shoe' , prefix + 'horseshoe.png'],
				['Hunter' , prefix + 'hunter.png'],
				//				['Jocker' , prefix + 'joker.png'],
				['Lawyer' , prefix + 'lawyer.png'],
				['Liberty Bell' , prefix + 'libertybell.png'],
				['Militia Man' , prefix + 'militiaman.png'],
				['Motorcross' , prefix + 'motorcrossbike.png'],
				['Music Note' , prefix + 'musicnote.png'],
				//				['Navy Ship' , prefix + 'navyship.png'],
				['Paw Prints' , prefix + 'pawprints.png'],
				['Peace' , prefix + 'peace.png'],
				['Piano' , prefix + 'piano.png'],
				['Property Of' , prefix + 'propertyof.png'],
				['Pumpkin' , prefix + 'pumpkin.png'],
				['Race Car' , prefix + 'racecar.png'],
				['Rose' , prefix + 'rose.png'],
				['Skull' , prefix + 'skull.png'],
				['Soccer Ball' , prefix + 'soccerball.png'],
				['Soldier' , prefix + 'soldier.png'],
				['Spade' , prefix + 'spade.png'],
				['Star of David' , prefix + 'starofdavid.png'],
				['Statue of Liberty' , prefix + 'statueofliberty.png'],
				['Truck' , prefix + 'truck.png'],
				['Turkey' , prefix + 'turkey.png'],
				['Wedding Bands' , prefix + 'weddingbands.png'],
				['Wedding Bells' , prefix + 'weddingbells.png'],
				['Wine Glass' , prefix + 'wineglass.png'],
				['Wings' , prefix + 'wings.png'],
				['Witch' , prefix + 'witch.png'],
				//['Xmas Tree' , prefix + 'xmastree.png'],
				['Ying Yang' , prefix + 'yinyang.png'],
				
				//color
				
				['White Border' , cprefix + 'Whiteborder onlavendar.png'],
				//['Aquad Butterfly' , cprefix + 'aquabutterfly.png'],
				['Black Snowflake' , cprefix + 'blacksnowflake.png'],
				['Blue Graduate' , cprefix + 'bluegraduate.png'],
				['Blue Music Note' , cprefix + 'bluemusicnote.png'],
				['Brown Deer' , cprefix + 'browndeer.png'],
				['Brown Hammer' , cprefix + 'brownhammer.png'],
				//['Christmas Candel' , cprefix + 'christmascandel.png'],
				//['Color BBats' , cprefix + 'colorBBbats.png'],
				['I Love You' , cprefix + 'colorIloveyou.png'],
				//['Color Backsetball' , cprefix + 'colorbasketball.png'],
				['Beer Bottle' , cprefix + 'colorbeerbottle.png'],
				['Xmas Tree' , cprefix + 'colorchristmastree.png'],
				['Fire Cracker' , cprefix + 'colorfirecracker.png'],
				['Fireworks' , cprefix + 'colorfireworks.png'],
				['Football' , cprefix + 'colorfootball.png'],
				['Horn of Plenty' , cprefix + 'colorhornoplenty.png'],
				['Liberty Bell' , cprefix + 'colorlibertybell.png'],
				['Paw Prints' , cprefix + 'colorpawprints.png'],
				['Congrats Red' , cprefix + 'congratsred.png'],
				['Gold Oak Cluster' , cprefix + 'goldoakcluster.png'],
				['Turkey' , cprefix + 'goldturkey.png'],
				['Apple' , cprefix + 'greenapple.png'],
				['Holly' , cprefix + 'greenholly.png'],
				['Pine Tree' , cprefix + 'greenpinetree.png'],
				['Green Shamrock' , cprefix + 'greenshamrock.png'],
				['Holly 2' , cprefix + 'moreholleycolor.png'],
				//['Jack \'o Lantern' , cprefix + 'orangejackolatern.png'],
				['Orange Pumpkin' , cprefix + 'orangepumpkin.png'],
				['Snow Flake2' , cprefix + 'othersnowflake.png'],
				['Pink Butterfly' , cprefix + 'pinkbutterfly.png'],
				['Pink Heart' , cprefix + 'pinkheart.png'],
				//['Pink \'n Purple Heart' , cprefix + 'pinknpurpleheart.png'],
				['Rose' , cprefix + 'pinkrose.png'],
				//['Ballons' , cprefix + 'purpleballoons.png'],
				['Butterfly' , cprefix + 'purplebutterfly.png'],
				['Frilly Heart' , cprefix + 'purplefrillyheart.png'],
				['Purple Heart' , cprefix + 'purpleheart.png'],
				['Joker' , cprefix + 'purplejoker.png'],
				['Wedding Bells' , cprefix + 'purpleweddingbells.png'],
				['Red Apple' , cprefix + 'redapple.png'],
				['Bio Hazard' , cprefix + 'redbiohazard.png'],
				['Border' , cprefix + 'redborder.png'],
				['Butterfly' , cprefix + 'redbutterfly.png'],
				['Diamond' , cprefix + 'reddiamond.png'],
				['Dice' , cprefix + 'reddice.png'],
				['Heart' , cprefix + 'redfrillyheart.png'],
				['Graduate' , cprefix + 'redgraduate.png'],
				//['Heart' , cprefix + 'redheart.png'],
				['Red Music Note' , cprefix + 'redmusicnote.png'],
				['Peace' , cprefix + 'redpeacesign.png'],
				['Rose' , cprefix + 'redrose.png'],
				['Star' , cprefix + 'redstar.png'],
				['Shamrock Border' , cprefix + 'shamrockborder.png'],
				['Butterfly' , cprefix + 'whitebutterfly.png'],
				['Congrats' , cprefix + 'whitecongratsonblue.png'],
				['Dice' , cprefix + 'whitedice.png'],
				['Dove' , cprefix + 'whitedove.png'],
				['Graduate' , cprefix + 'whitegraduate.png'],
				//['Ballons' , cprefix + 'whitenredballoons.png'],
				['Heart' , cprefix + 'whitenredheart.png'],
				['Wedding Bells' , cprefix + 'whitenredweddingbells.png'],
				['SnowFlake' , cprefix + 'whitesnowflake.png'],
				['WineGlass' , cprefix + 'wineglasses.png'],
				['YellowRose' , cprefix + 'yellowrose.png'],
				
				['Blue' , backprefix + '001775-RF_Color.png'],
				['50 Yard Line' , backprefix + '002076-RF_Color.png'],
				['Baseball' , backprefix + '002077-RF_Color.png'],
				['Checker Flag' , backprefix + '002082-RF_Color.png'],
				['Speaker' , backprefix + '002663-RF_Color.png'],
				['Ace' , backprefix + '003948-RF_Color.png'],
				['Wanted' , backprefix + '003949-RF_Color.png'],
				['Fractal Card Suit' , backprefix + 'Background005.png'],
				['Trees' , backprefix + 'Background009.png'],
				['Tiger Stripe' , backprefix + 'Background018.png'],
				['Chrome' , backprefix + 'Background042.png'],
				['American Flag' , backprefix + 'Background045.png'],
				['Wood' , backprefix + 'Background048.png'],
				['Leopard' , backprefix + 'Background068.png'],
				['Brick' , backprefix + 'Background095.png'],
				['Wood 2' , backprefix + 'Background103.png'],
				['Hearts + Roses' , backprefix + 'Background112.png'],
				['Fireworks' , backprefix + 'Background122.png'],
				['Tartan' , backprefix + 'Background184.png'],
				['Winter' , backprefix + 'Background197.png'],
				['Lightning' , backprefix + 'Background219.png'],
				['Barbwire' , backprefix + 'barbwire.png'],
				['Card Suit' , backprefix + 'cardsuit.png'],
				['Congratulations' , backprefix + 'congratulations.png'],
				['Frame' , backprefix + 'frame.png'],
				['Scroll' , backprefix + 'scroll.png'],
				['Shamrock' , backprefix + 'shamrock.png'],
				['Bottle' , set3prefix + 'BROWNBOTTLE.png'],
				['Ballons' , set3prefix + 'COLORBALLONS.png'],
				['Ballons 2' , set3prefix + 'COLORBALLONS2.png'],
				['Bats' , set3prefix + 'COLORBATS.png'],
				['Candle' , set3prefix + 'COLORCANDLE.png'],
				['Hearts 2' , set3prefix + 'COLORHEARTS2.png'],
				['Hearts 3' , set3prefix + 'COLORHEARTS3.png'],
				['Holiday Tree' , set3prefix + 'HOLIDAYTREE2.png'],
				['Jack O\' Lantern' , set3prefix + "JACKOLANTERN.png"],
				//['Sheild' , backprefix + 'shield.png']*/
				
			];
			
			var importImagesSet4:Array = [
				['HEART1', set4prefix + 'Heart1.png'],
				['HEART2', set4prefix + 'Heart2.png'],
				['HEART3', set4prefix + 'Heart3.png'],
				['HEART4', set4prefix + 'Heart4.png'],
				['HEART5', set4prefix + 'Heart5.png'],
				['HEART6', set4prefix + 'Heart6.png'],
				['HEART7', set4prefix + 'Heart7.png'],
				['HEART8', set4prefix + 'Heart8.png'],
				['HEART9', set4prefix + 'Heart9.png'],
				['HEART10', set4prefix + 'Heart10.png'],
				['WEDDINGBANDS', set4prefix + 'WeddingBands.png'],
				['GUITAR', set4prefix + 'Guitar.png'],
				['HELICOPTER', set4prefix + 'Helicopter.png'],
				['HOCKEY', set4prefix + 'Hockey.png'],
				['SKIIING', set4prefix + 'skiiing.png'],
				['SOCCERBALL', set4prefix + 'Soccerball.png'],
				['DRAGONFLY', set4prefix + 'DragonFly.png'],
				['BEER', set4prefix + 'Beer.png'],
				['HORSE', set4prefix + 'Horse.png'],
				['DOUBLEDRAGONS', set4prefix + 'DoubleDragons.png'],
				['BALLOONS', set4prefix + 'Balloons.png'],
				['AMERICANFLAG', set4prefix + 'AmericanFlag.png'],
				['PAWPRINTS', set4prefix + 'Pawprints.png'],
				['DOGTAGS', set4prefix + 'DogTags.png'],
				['PEACESIGN', set4prefix + 'PeaceSign.png'],
				['GOLFER', set4prefix + 'Golfer.png'],
				['CROSS', set4prefix + 'Cross.png'],
				['CHECKEREDFLAG', set4prefix + 'CheckeredFlag.png'],
				['BASEBALL', set4prefix + 'Baseball.png'],
				['TRUCK', set4prefix + 'Truck.png'],
				['GUN', set4prefix + 'Gun.png'],
				['SKULL', set4prefix + 'Skull.png'],
				['BIOHAZARD', set4prefix + 'Biohazard.png'],
				['REDSPLASH', set4prefix + 'RedSplash.png'],
				['PROPERTYOF', set4prefix + 'PropertyOf.png'],
				['WINE', set4prefix + 'Wine.png'],
				['ALIEN1', set4prefix + 'Alien1.png'],
				['ALIEN2', set4prefix + 'Alien2.png'],
				['ALIEN3', set4prefix + 'Alien3.png'],
				['ALIEN4', set4prefix + 'Alien4.png'],
				['BASKETWEAVE', set4prefix + 'BasketWeave.png'],
				['POLKADOT', set4prefix + 'PolkaDot.png'],
				['ZEBRA1', set4prefix + 'Zebra1.png'],
				['ZEBRA2', set4prefix + 'Zebra2.png'],
				['PINK1', set4prefix + 'Pink.png'],
				['MUSTACHE', set4prefix + 'Mustache.png'],
				['SQUARE', set4prefix + 'Square.png'],
				['CIRCLE', set4prefix + 'Circle.png'],
				['WANTEDPOSTER', set4prefix + 'WantedPoster.png'],
				['CLOVER', set4prefix + 'Clover.png'],
				['BULLET', set4prefix + 'Bullet.png'],
				['BASKETBALL', set4prefix + 'Basketball.png'],
				['FOOTBALL', set4prefix + 'Football.png'],
				['DIAMONDSTEELPLATE', set4prefix + 'DiamondSteelPlate.png'],
				['SNOWFLAKE', set4prefix + 'Snowflake.png'],
				['FIREWORKS', set4prefix + 'Fireworks.png'],
				['BORDER1', set4prefix + 'Border1.png'],
				['BORDER2', set4prefix + 'Border2.png'],
				['BORDER3', set4prefix + 'Border3.png'],
				['FLAME1', set4prefix + 'Flame1.png'],
				['FLAME2', set4prefix + 'Flame2.png'],
				['BRICKWALL', set4prefix + 'BrickWall.png']
			];
			var i : int = 0 ; 
			var imgs : Array = []; 
			for ( i  = 0 ; i < importImagesSet4.length; i++ )
			{
				var imageNameAndSourceArray : Array = importImagesSet4[i] as Array
				var img  : ImageVO= new ImageVO()
				img.name = imageNameAndSourceArray[0]
				img.url = imageNameAndSourceArray[1];
				//names.push( 'Title ' + i.toString() ) ; 
				imgs.push( img ); 
			}
			
			
			this.model.loadImages( imgs ) ; 
		}
		
		private function createDefaultProduct():void
		{
			var base : StoreItemVO = new StoreItemVO(); 
			base.name = 'Zippo'
			var face : FaceVO = new FaceVO()
			
			face.base_image_url = 'assets/images/imgbase.png'
			base.faces.addItem( face ) 
			this.model.baseItem = base; 
			
			/*var l : Array = [] ; 
			l = MakeVOs.makeObjs(['L1', 'L2'], LessonVO, 'name' )
			var lp : LessonGroupVO = new LessonGroupVO(); 
			lp.lessons = new ArrayList( l ) ; 
			//this.model.loadLessons( l ); 
			
			var firstLesson : LessonVO = lp.lessons.getItemAt( 0 ) as LessonVO
			l = MakeVOs.makeObjs(['Ls1', 'Ls2', 'Ls3'], LessonSetVO, 'name' )
			firstLesson.sets = new ArrayList( l ) ; 
			
			var set : LessonSetVO = firstLesson.sets.getItemAt( 0 ) as LessonSetVO
			l = MakeVOs.makeObjs(['dog', '2', '3','4'], LessonItemVO, 'name' )
			set.items = new ArrayList( l ) ; 					
			
			this.model.currentLessonPlan = lp ; */
		}		
		private function createDetailedDefaultProduct_Engrave():void
		{
			var base : StoreItemVO = new StoreItemVO(); 
			base.name = 'Zippo'
			base.price = 65
			var face : FaceVO = new FaceVO()
			face.name = 'Front Face'; 
			face.base_image_url = 'assets/images/imgbase.png'
			base.faces.addItem( face ) 
			face.image_mask = 'assets/images/imgbase.png'
			face.layersToImport = [];
			
			var colorLayer : ColorLayerVO; 
			var imageLayer: ImageLayerVO
			
			colorLayer = new ColorLayerVO;
			colorLayer.name = 'Color Layer'
			colorLayer.url ='assets/images/imgbase.png'
			//colorLayer.mask = true
			colorLayer.showInList = true;
			colorLayer.prompt_layer = true;
			colorLayer.color = 0x166571;
			colorLayer.locked = true; //all masks should be locked by default 
			face.layersToImport.push(colorLayer);
			
			var textLayer: TextLayerVO = new TextLayerVO;
			textLayer.text = 'Add' 
			textLayer.name = 'Text'
			textLayer.maxChars = 3
			textLayer.location = 'front small'; 
			/*textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
			textLayer.maxFontSize = 35
			*/
			textLayer.width = 50
			textLayer.height =60 
			textLayer.x = 60
			textLayer.y = 120; 
			textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			textLayer.horizStartAlignment = ''
			textLayer.locked = true; 
			//textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			//textLayer.horizStartAlignment = ''
			textLayer.subType = ViridConstants.SUBTYPE_ENGRAVE
			//textLayer.minFontSize = 6
			textLayer.prompt_layer = true; 
			face.layersToImport.push(textLayer);
			
			var fonts : Array = []; 
			var font : FontVO = new FontVO()
			font.name = 'Helvetica' 
			fonts.push(font); 
			font = new FontVO()
			font.name = 'Arial' 
			fonts.push(font); 
			font = new FontVO()
			font.name = 'Times New Roman' 
			font.swf_name = 'TimesFont' 
			fonts.push(font); 
			textLayer.fonts = fonts; 
			
			textLayer = new TextLayerVO;
			textLayer.text = 'Add' 
			textLayer.name = 'Text'
			textLayer.maxChars = 3
			textLayer.fonts = fonts; 
			//textLayer.fontFamily = 'Arial'
			/*textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
			textLayer.maxFontSize = 35
			*/
			textLayer.width = 20
			textLayer.height = 140 
			textLayer.x = 60
			textLayer.y =60; 
			textLayer.locked = true; 
			textLayer.fontSize = 35
			textLayer.location = 'front Large'; 
			textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			textLayer.horizStartAlignment = ''
			textLayer.subType = ViridConstants.SUBTYPE_ENGRAVE
			//textLayer.minFontSize = 6
			textLayer.prompt_layer = true; 
			face.layersToImport.push(textLayer);
			
			
			
			
			
			face = new FaceVO()
			face.name = 'Back Face'; 
			face.base_image_url = 'assets/images/imgbase.png'
			base.faces.addItem( face ) 
			face.layersToImport = [];
			face.image_mask = 'assets/images/imgbase.png'
			
			colorLayer = new ColorLayerVO;
			colorLayer.name = 'Color Layer'
			colorLayer.url ='assets/images/imgbase.png'
			//colorLayer.mask = true
			colorLayer.showInList = true;
			colorLayer.prompt_layer = true;
			colorLayer.color = 0x166571;
			colorLayer.locked = true; //all masks should be locked by default 
			face.layersToImport.push(colorLayer);
			
			textLayer = new TextLayerVO;
			textLayer.text = 'bac' 
			textLayer.name = 'Text'
			textLayer.maxChars = 3
			/*textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
			textLayer.maxFontSize = 35
			*/
			textLayer.width = 50
			textLayer.height =30 
			textLayer.x = 60
			textLayer.y = 120; 
			textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			textLayer.horizStartAlignment = ''
			textLayer.locked = true; 
			//textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			//textLayer.horizStartAlignment = ''
			textLayer.subType = ViridConstants.SUBTYPE_ENGRAVE
			//textLayer.minFontSize = 6
			textLayer.prompt_layer = true; 
			face.layersToImport.push(textLayer);
			textLayer.fonts = fonts; 
			
			textLayer = new TextLayerVO;
			textLayer.text = 'Add' 
			textLayer.name = 'Text'
			textLayer.maxChars = 3
			/*textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
			textLayer.maxFontSize = 35
			*/
			textLayer.width = 100
			textLayer.height = 50 
			textLayer.x = 60
			textLayer.y =60; 
			textLayer.locked = true; 
			textLayer.fontSize = 35
			textLayer.location = 'Back Large'; 
			textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			textLayer.horizStartAlignment = ''
			textLayer.subType = ViridConstants.SUBTYPE_ENGRAVE
			//textLayer.minFontSize = 6
			textLayer.prompt_layer = true; 
			face.layersToImport.push(textLayer);
			
			this.model.baseItem = base; 
		}
		
		
		private function createDetailedDefaultProduct_Engrave2(noLayersOnFace1 :Boolean = false):void
		{
			var base : StoreItemVO = new StoreItemVO(); 
			base.name = '1941 Replica &#8482;'
			base.desc = '<br>&#8226;Brushed Brass<br>&#8226;Case has flat planes with sharper, less rounded edges where the front and back surfaces meet the sides<br>&#8226;Lid and the bottom are joined with a four-barrel hinge<br>&#8226;Inside unit are flatter, with squared edges where they meet the front and back sur'
			base.price = 65
			base.sku = '1023763'; 
			var face : FaceVO = new FaceVO()
			face.layersToImport = []; 
			face.name = 'Front'; 
			face.base_image_url = 'assets/products/1941B-000003-Z_Configure.jpg'
			
			base.faces.addItem( face ) 
			
			//face.image_mask = 'assets/images/imgbase.png'
			
			var colorLayer : ColorLayerVO; 
			var imageLayer: ImageLayerVO
			
			/*
			colorLayer = new ColorLayerVO;
			colorLayer.name = 'Color Layer'
			colorLayer.url ='assets/images/imgbase.png'
			//colorLayer.mask = true
			colorLayer.showInList = true;
			colorLayer.prompt_layer = true;
			colorLayer.color = 0x166571;
			colorLayer.locked = true; //all masks should be locked by default 
			face.layersToImport.push(colorLayer);
			*/
			var textLayer: TextLayerVO = new TextLayerVO;
			textLayer.text = '' 
			textLayer.name = 'Top Front'
			textLayer.maxChars = 3
			textLayer.location = 'front small'; 
			/*textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
			textLayer.maxFontSize = 35
			*/
			textLayer.width = 130
			textLayer.height =40 
			textLayer.x = 45
			textLayer.y = 75; 
			textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			textLayer.horizStartAlignment = ''
			textLayer.locked = true; 
			//textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			//textLayer.horizStartAlignment = ''
			textLayer.subType = ViridConstants.SUBTYPE_ENGRAVE
			//textLayer.minFontSize = 6
			textLayer.prompt_layer = true; 
			face.layersToImport.push(textLayer);
			
			var fonts : Array = []; 
			var font : FontVO = new FontVO()
			font.name = 'Helvetica' 
			fonts.push(font); 
			font = new FontVO()
			font.name = 'Arial' 
			fonts.push(font); 
			font = new FontVO()
			font.name = 'Times New Roman' 
			font.swf_name = 'TimesFont' 
			fonts.push(font); 
			textLayer.fonts = fonts; 
			
			textLayer = new TextLayerVO;
			textLayer.text = '' 
			textLayer.name = 'Text'
			textLayer.maxChars = 3
			textLayer.fonts = fonts; 
			//textLayer.fontFamily = 'Arial'
			/*textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
			textLayer.maxFontSize = 35
			*/
			textLayer.width = 20
			textLayer.height = 140 
			textLayer.x = 60
			textLayer.y =60; 
			textLayer.locked = true; 
			textLayer.fontSize = 35
			textLayer.location = 'front Large'; 
			textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			textLayer.horizStartAlignment = ''
			textLayer.subType = ViridConstants.SUBTYPE_ENGRAVE
			//textLayer.minFontSize = 6
			textLayer.prompt_layer = true; 
			face.layersToImport.push(textLayer);
			
			
			textLayer = new TextLayerVO;
			textLayer.text = 'first' 
			textLayer.name = 'Text'
			//face.importFirstLayerSelection = textLayer
			//textLayer.maxChars = 6
			textLayer.fonts = fonts; 
			//textLayer.fontFamily = 'Arial'
			textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
			textLayer.maxFontSize = 35
			textLayer.minFontSize = 12
			textLayer.width = 120
			textLayer.height = 120
			textLayer.x = 50
			textLayer.y =50; 
			textLayer.locked = true; 
			textLayer.fontSize = 35
			textLayer.location = 'front Large'; 
			textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			textLayer.horizStartAlignment = ''
			textLayer.subType = ViridConstants.SUBTYPE_ENGRAVE
			//textLayer.minFontSize = 6
			textLayer.prompt_layer = true; 
			face.layersToImport.push(textLayer);
			
			
			textLayer = new TextLayerVO;
			textLayer.text = 'ddd '
			
			textLayer.name = 'Text 3'
			//textLayer.maxChars = 3
			textLayer.fonts = fonts; 
			//textLayer.fontFamily = 'Arial'
			
			textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
			textLayer.maxFontSize = 35
			textLayer.minFontSize = 12
			textLayer.maxChars = 20
			
			textLayer.verticalText = true
			
			textLayer.width = 20
			textLayer.height = 140 
			textLayer.x = 60
			textLayer.y =200; 
			textLayer.locked = true; 
			textLayer.fontSize = 35
			textLayer.location = 'front Large2'; 
			textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			textLayer.horizStartAlignment = ''
			textLayer.subType = ViridConstants.SUBTYPE_ENGRAVE
			//textLayer.minFontSize = 6
			textLayer.fonts = fonts; 
			textLayer.prompt_layer = true; 
			face.layersToImport.push(textLayer);
			if ( noLayersOnFace1 ) 
				face.layersToImport = [] ; 
			
			face  = new FaceVO()
			face.layersToImport = []; 
			face.name = 'Back Face'; 
			face.base_image_url = 'assets/images/imgbase.png'
			base.faces.addItem( face ) 
			
			face.image_mask = 'assets/images/imgbase.png'
			
			colorLayer = new ColorLayerVO;
			colorLayer.name = 'Color Layer'
			colorLayer.url ='assets/images/imgbase.png'
			//colorLayer.mask = true
			colorLayer.showInList = true;
			colorLayer.prompt_layer = true;
			colorLayer.color = 0x166571;
			colorLayer.locked = true; //all masks should be locked by default 
			face.layersToImport.push(colorLayer);
			
			textLayer = new TextLayerVO;
			textLayer.text = 'bac' 
			textLayer.name = 'Text'
			textLayer.maxChars = 3
			textLayer.showInList = false			
			/*textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
			textLayer.maxFontSize = 35
			*/ 
			textLayer.width = 50
			textLayer.height =30 
			textLayer.x = 60
			textLayer.y = 120; 
			textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			textLayer.horizStartAlignment = ''
			textLayer.locked = true; 
			//textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			//textLayer.horizStartAlignment = ''
			textLayer.subType = ViridConstants.SUBTYPE_ENGRAVE
			//textLayer.minFontSize = 6
			textLayer.prompt_layer = true; 
			face.layersToImport.push(textLayer);
			textLayer.fonts = fonts; 
			
			textLayer = new TextLayerVO;
			textLayer.text = 'Add' 
			textLayer.name = 'Text'
			textLayer.maxChars = 3
			/*textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
			textLayer.maxFontSize = 35
			*/
			textLayer.width = 100
			textLayer.height = 50 
			textLayer.x = 60
			textLayer.y =60; 
			textLayer.locked = true; 
			textLayer.fontSize = 35
			textLayer.location = 'Back Large'; 
			textLayer.vertStartAlignment = ''; //no necessary if you lock the layer
			textLayer.horizStartAlignment = ''
			textLayer.subType = ViridConstants.SUBTYPE_ENGRAVE
			//textLayer.minFontSize = 6
			textLayer.prompt_layer = true; 
			textLayer.fonts = fonts; 
			face.layersToImport.push(textLayer);
			
			this.model.baseItem = base; 
		}
		
		private function createDetailedDefaultProduct():void
		{
			var base : StoreItemVO = new StoreItemVO(); 
			base.name = 'Zippo'
			base.price = 65
			var face : FaceVO = new FaceVO()
			face.layersToImport = [] ; 
			face.name = 'Front Face'; 
			face.base_image_url = 'assets/images/imgbase.png'
			base.faces.addItem( face ) 
			/*
			imgLayer = new ImageLayerVO(); 
			imgLayer.name = 'Mask Image';
			imgLayer.url = face.base_image_url; 
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
			*/
			
			face.image_mask = 'assets/images/imgbase.png'
			//just have to get it to the mask layer on the model some how ... if you roll your own 
			/*	
			var colorLayer : ColorLayerVO; 
			colorLayer = new ColorLayerVO;
			colorLayer.name = 'Mask2'
			colorLayer.url ='assets/images/imgbase.png'
			//colorLayer.mask = true
			//imageLayer.showInList = false
			colorLayer.locked = true; //all masks should be locked by default 
			face.layersToImport.push(colorLayer);
			*/
			var colorLayer : ColorLayerVO; 
			
			colorLayer = new ColorLayerVO;
			colorLayer.name = 'Color Layer'
			colorLayer.url ='assets/images/imgbase.png'
			//colorLayer.mask = true
			colorLayer.showInList = true;
			colorLayer.prompt_layer = true;
			colorLayer.color = 0x166571;
			colorLayer.locked = true; //all masks should be locked by default 
			face.layersToImport.push(colorLayer);
			
			var textLayer: TextLayerVO = new TextLayerVO;
			textLayer.text = 'Add Text' 
			textLayer.name = 'Text'
			textLayer.maxChars = 25
			textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
			textLayer.maxFontSize = 35
			textLayer.minFontSize = 6
			textLayer.prompt_layer = true; 
			textLayer.nameHidden = 'put something here';  
			face.layersToImport.push(textLayer);
			var imageLayer: ImageLayerVO
			//face.importFirstLayerSelection = textLayer; 
			
			imageLayer = new ImageLayerVO;
			imageLayer.name = 'Upload'
			imageLayer.url ='assets/images/pokemon.png'
			imageLayer.default_url ='assets/images/pokemon.png'
			imageLayer.prompt_layer = true; 
			imageLayer.visible = true; 
			imageLayer.cost = 8.95
			imageLayer.image_source = ViridConstants.IMAGE_SOURCE_UPLOAD
			face.layersToImport.push(imageLayer);
			
			imageLayer = new ImageLayerVO;
			imageLayer.url = ''
			imageLayer.name = 'Clip Art 1'
			imageLayer.visible = false; 
			imageLayer.cost = 14.00
			imageLayer.prompt_layer = true; 
			imageLayer.image_source = ViridConstants.IMAGE_SOURCE_CLIPART	
			face.layersToImport.push(imageLayer);
			
			imageLayer = new ImageLayerVO;
			//imageLayer.url = ''
			imageLayer.name = 'Clip Art 2'
			imageLayer.prompt_layer = true; 
			imageLayer.visible = false; 
			//imageLayer.cost = 14.00
			imageLayer.image_source = ViridConstants.IMAGE_SOURCE_CLIPART					
			face.layersToImport.push(imageLayer);
			
			imageLayer = new ImageLayerVO;
			imageLayer.prompt_layer = true; 		
			imageLayer.name = 'Clip Art 3'
			//imageLayer.cost = 14.00
			imageLayer.image_source = ViridConstants.IMAGE_SOURCE_CLIPART
			imageLayer.url ='assets/images/img.jpg'
			imageLayer.visible = false; 
			face.layersToImport.push(imageLayer);
			
			var collectivePrice : CollectiveLayerPriceVO = new CollectiveLayerPriceVO() ; 
			collectivePrice.price = 9.95; 
			collectivePrice.type = ImageLayerVO.Type; 
			collectivePrice.subtype  = ViridConstants.IMAGE_SOURCE_CLIPART; 
			face.collectiveLayerPrices.push( collectivePrice ) ; 
			/*var l : Array = [] ; 
			l = MakeVOs.makeObjs(['L1', 'L2'], LessonVO, 'name' )
			var lp : LessonGroupVO = new LessonGroupVO(); 
			lp.lessons = new ArrayList( l ) ; 
			//this.model.loadLessons( l ); 
			
			var firstLesson : LessonVO = lp.lessons.getItemAt( 0 ) as LessonVO
			l = MakeVOs.makeObjs(['Ls1', 'Ls2', 'Ls3'], LessonSetVO, 'name' )
			firstLesson.sets = new ArrayList( l ) ; 
			
			var set : LessonSetVO = firstLesson.sets.getItemAt( 0 ) as LessonSetVO
			l = MakeVOs.makeObjs(['dog', '2', '3','4'], LessonItemVO, 'name' )
			set.items = new ArrayList( l ) ; 					
			
			this.model.currentLessonPlan = lp ; */
			this.createBackFace(base); 
			this.model.baseItem = base; 
		}		
		
		
		private function createBackFace(base:StoreItemVO):void
		{
			var face : FaceVO = new FaceVO()
			face.name = 'Back Face'
			//face.base_image_url = 'assets/images/imgbase.png'
			face.base_image_url = 'assets/images/lighter_back_base.png'
			base.faces.addItem( face ) 
			/*
			imgLayer = new ImageLayerVO(); 
			imgLayer.name = 'Mask Image';
			imgLayer.url = face.base_image_url; 
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
			*/
			face.layersToImport = [] ; 
			face.image_mask = 'assets/images/lighter_back_workarea.png'
			face.image_mask_alpha = 0.4
			//just have to get it to the mask layer on the model some how ... if you roll your own 
			/*	
			var colorLayer : ColorLayerVO; 
			colorLayer = new ColorLayerVO;
			colorLayer.name = 'Mask2'
			colorLayer.url ='assets/images/imgbase.png'
			//colorLayer.mask = true
			//imageLayer.showInList = false
			colorLayer.locked = true; //all masks should be locked by default 
			face.layersToImport.push(colorLayer);
			*/
			var colorLayer : ColorLayerVO; 
			
			colorLayer = new ColorLayerVO;
			colorLayer.name = 'Color Layer'
			colorLayer.url ='assets/images/lighter_back_workarea.png'
			//colorLayer.mask = true
			colorLayer.showInList = false
			colorLayer.color = 0x166571;
			colorLayer.locked = true; //all masks should be locked by default 
			face.layersToImport.push(colorLayer);
			
			var textLayer: TextLayerVO = new TextLayerVO;
			textLayer.text = 'Back Text' 
			textLayer.name = 'Text'
			textLayer.maxChars = 25
			textLayer.sizingSettings = TextLayerVO.SIZING_AUTO_SIZE; //'get smaller' 
			textLayer.maxFontSize = 35
			textLayer.minFontSize = 6
			textLayer.prompt_layer = true; 
			textLayer.default_text = 'Back Text'
			face.layersToImport.push(textLayer);
			var imageLayer: ImageLayerVO
			
			
			imageLayer = new ImageLayerVO;
			imageLayer.name = 'Upload'
			imageLayer.url ='assets/images/pokemon.png'
			imageLayer.default_url ='assets/images/pokemon.png'
			imageLayer.prompt_layer = true; 
			imageLayer.visible = false; 
			imageLayer.cost = 8.95
			imageLayer.image_source = ViridConstants.IMAGE_SOURCE_UPLOAD
			face.layersToImport.push(imageLayer);
			
			imageLayer = new ImageLayerVO;
			imageLayer.url = ''
			imageLayer.name = 'Clip Art 1'
			imageLayer.visible = false; 
			imageLayer.cost = 14.00
			imageLayer.prompt_layer = true; 
			imageLayer.image_source = ViridConstants.IMAGE_SOURCE_CLIPART	
			face.layersToImport.push(imageLayer);
			
			imageLayer = new ImageLayerVO;
			//imageLayer.url = ''
			imageLayer.name = 'Clip Art 2'
			imageLayer.prompt_layer = true; 
			imageLayer.visible = false; 
			imageLayer.cost = 14.00
			imageLayer.image_source = ViridConstants.IMAGE_SOURCE_CLIPART					
			face.layersToImport.push(imageLayer);
			
			imageLayer = new ImageLayerVO;
			imageLayer.prompt_layer = true; 		
			imageLayer.name = 'Clip Art 3'
			imageLayer.cost = 14.00
			imageLayer.image_source = ViridConstants.IMAGE_SOURCE_CLIPART
			imageLayer.url ='assets/images/img.jpg'
			imageLayer.visible = false; 
			face.layersToImport.push(imageLayer);
			
			/*var l : Array = [] ; 
			l = MakeVOs.makeObjs(['L1', 'L2'], LessonVO, 'name' )
			var lp : LessonGroupVO = new LessonGroupVO(); 
			lp.lessons = new ArrayList( l ) ; 
			//this.model.loadLessons( l ); 
			
			var firstLesson : LessonVO = lp.lessons.getItemAt( 0 ) as LessonVO
			l = MakeVOs.makeObjs(['Ls1', 'Ls2', 'Ls3'], LessonSetVO, 'name' )
			firstLesson.sets = new ArrayList( l ) ; 
			
			var set : LessonSetVO = firstLesson.sets.getItemAt( 0 ) as LessonSetVO
			l = MakeVOs.makeObjs(['dog', '2', '3','4'], LessonItemVO, 'name' )
			set.items = new ArrayList( l ) ; 					
			
			this.model.currentLessonPlan = lp ; */
			//this.createBackFace(base); 
			//this.model.baseItem = base; 
		}		
		
		
		
	}
}