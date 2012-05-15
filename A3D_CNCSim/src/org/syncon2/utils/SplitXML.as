package   org.syncon2.utils
{
	[RemoteClass]
	public class SplitXML  
	{
		public var hiSpeedMode : Boolean = true; 
		public var fontSize : Number = NaN; 
		public var storeVerses : Boolean = true; 
		public var reverseText:Boolean;
		
		/**
		 * Want to break up an xml file and limit it's content only to specific pieces ... 
		 * find extact content size ... 
		 * go through again and break it, 
		 * make sure to close tags .... 
		 * this won' work for this like lists 
		 * */
		static public function Test() : void
		{
			var text	: String ='<TEXTFORMAT LEADING="2"><P ALIGN="LEFT"><FONT FACE="myFontFamily" SIZE="57" COLOR="#FFFFFF" LETTERSPACING="0" KERNING="0">setset</FONT></P></TEXTFORMAT><TEXTFORMAT LEADING="2"><P ALIGN="LEFT"><FONT FACE="myFontFamily" SIZE="57" COLOR="#FFFFFF" LETTERSPACING="0" KERNING="0">setset</FONT></P></TEXTFORMAT><TEXTFORMAT LEADING="2"><P ALIGN="LEFT"><FONT FACE="myFontFamily" SIZE="57" COLOR="#FFFFFF" LETTERSPACING="0" KERNING="0"> boo <B>f</B> +mu? boo <B>f</B> +mu? boo <B>f</B> +mu? boo <B>f</B> +mu? boo <B>f</B> +mu? boo </FONT></P></TEXTFORMAT>'	
			text	 ='<TEXTFORMAT LEADING="2"><p>asdf<p>55</p><p>6</p>s</p><P ALIGN="LEFT"><FONT FACE="myFontFamily" SIZE="57" COLOR="#FFFFFF" LETTERSPACING="0" KERNING="0">setset</FONT></P></TEXTFORMAT>'	
			
			var xml : XML = new XML(text); 
			var p : SplitXML = new SplitXML()
			p.load( xml , 3)
				
			text = '<div class="esv"><h2>John 1 <object type="application/x-shockwave-flash"  data="http://www.esvapi.orgassets/play.swf?myUrl=hw%2F43001001-43001051" width="40" height="12" class="audio"><param name="movie" value="http://www.esvapi.orgassets/play.swf?myUrl=hw%2F43001001-43001051" /><param name="wmode" value="transparent" /></object></h2><div class="esv-text"><h3 id="p43001001.01-1">The Word Became Flesh</h3><p class="chapter-first" id="p43001001.05-1"><span class="chapter-num" id="v43001001-1">1:1&nbsp;</span>In the beginning was the Word, and the Word was with God, and the Word was God. <span class="verse-num" id="v43001002-1">2&nbsp;</span>He was in the beginning with God. <span class="verse-num" id="v43001003-1">3&nbsp;</span>All things were made through him, and without him was not any thing made that was made. <span class="verse-num" id="v43001004-1">4&nbsp;</span>In him was life,<span class="footnote">&nbsp;<a href="#f1" id="b1" title="Or \'was not any thing made. That which has been made was life in him\'">[1]</a></span> and the life was the light of men. <span class="verse-num" id="v43001005-1">5&nbsp;</span>The light shines in the darkness, and the darkness has not overcome it.</p> <p id="p43001006.01-1"><span class="verse-num" id="v43001006-1">6&nbsp;</span>There was a man sent from God, whose name was John. <span class="verse-num" id="v43001007-1">7&nbsp;</span>He came as a witness, to bear witness about the light, that all might believe through him. <span class="verse-num" id="v43001008-1">8&nbsp;</span>He was not the light, but came to bear witness about the light.</p> <p id="p43001009.01-1"><span class="verse-num" id="v43001009-1">9&nbsp;</span>The true light, which enlightens everyone, was coming into the world. <span class="verse-num" id="v43001010-1">10&nbsp;</span>He was in the world, and the world was made through him, yet the world did not know him. <span class="verse-num" id="v43001011-1">11&nbsp;</span>He came to his own,<span class="footnote">&nbsp;<a href="#f2" id="b2" title="Greek \'to his own things\'; that is, to his own domain, or to his own people">[2]</a></span> and his own people<span class="footnote">&nbsp;<a href="#f3" id="b3" title="\'People\' is implied in Greek">[3]</a></span> did not receive him. <span class="verse-num" id="v43001012-1">12&nbsp;</span>But to all who did receive him, who believed in his name, he gave the right to become children of God, <span class="verse-num" id="v43001013-1">13&nbsp;</span>who were born, not of blood nor of the will of the flesh nor of the will of man, but of God.</p> <p id="p43001014.01-1"><span class="verse-num" id="v43001014-1">14&nbsp;</span>And the Word became flesh and dwelt among us, and we have seen his glory, glory as of the only Son from the Father, full of grace and truth. <span class="verse-num" id="v43001015-1">15&nbsp;</span>(John bore witness about him, and cried out, &#8220;This was he of whom I said, &#8216;He who comes after me ranks before me, because he was before me.&#8217;&#8221;) <span class="verse-num" id="v43001016-1">16&nbsp;</span>And from his fullness we have all received, grace upon grace. <span class="verse-num" id="v43001017-1">17&nbsp;</span>For the law was given through Moses; grace and truth came through Jesus Christ. <span class="verse-num" id="v43001018-1">18&nbsp;</span>No one has ever seen God; the only God,<span class="footnote">&nbsp;<a href="#f4" id="b4" title="Or \'the only One, who is God\'; some manuscripts \'the only Son\'">[4]</a></span> who is at the Father\'s side,<span class="footnote">&nbsp;<a href="#f5" id="b5" title="Greek \'in the bosom of the Father\'">[5]</a></span> he has made him known.</p> <h3 id="p43001019.01-1">The Testimony of John the Baptist</h3><p id="p43001019.07-1"><span class="verse-num" id="v43001019-1">19&nbsp;</span>And this is the testimony of John, when the Jews sent priests and Levites from Jerusalem to ask him, &#8220;Who are you?&#8221; <span class="verse-num" id="v43001020-1">20&nbsp;</span>He confessed, and did not deny, but confessed, &#8220;I am not the Christ.&#8221; <span class="verse-num" id="v43001021-1">21&nbsp;</span>And they asked him, &#8220;What then? Are you Elijah?&#8221; He said, &#8220;I am not.&#8221; &#8220;Are you the Prophet?&#8221; And he answered, &#8220;No.&#8221; <span class="verse-num" id="v43001022-1">22&nbsp;</span>So they said to him, &#8220;Who are you? We need to give an answer to those who sent us. What do you say about yourself?&#8221; <span class="verse-num" id="v43001023-1">23&nbsp;</span>He said, &#8220;I am the voice of one crying out in the wilderness, &#8216;Make straight<span class="footnote">&nbsp;<a href="#f6" id="b6" title="Or \'crying out, \'In the wilderness make straight\'">[6]</a></span> the way of the Lord,&#8217; as the prophet Isaiah said.&#8221;</p> <p id="p43001024.01-1"><span class="verse-num" id="v43001024-1">24&nbsp;</span>(Now they had been sent from the Pharisees.) <span class="verse-num" id="v43001025-1">25&nbsp;</span>They asked him, &#8220;Then why are you baptizing, if you are neither the Christ, nor Elijah, nor the Prophet?&#8221; <span class="verse-num" id="v43001026-1">26&nbsp;</span>John answered them, &#8220;I baptize with water, but among you stands one you do not know, <span class="verse-num" id="v43001027-1">27&nbsp;</span>even he who comes after me, the strap of whose sandal I am not worthy to untie.&#8221; <span class="verse-num" id="v43001028-1">28&nbsp;</span>These things took place in Bethany across the Jordan, where John was baptizing.</p> <h3 id="p43001029.01-1">Behold, the Lamb of God</h3><p id="p43001029.06-1"><span class="verse-num" id="v43001029-1">29&nbsp;</span>The next day he saw Jesus coming toward him, and said, &#8220;Behold, the Lamb of God, who takes away the sin of the world! <span class="verse-num" id="v43001030-1">30&nbsp;</span>This is he of whom I said, &#8216;After me comes a man who ranks before me, because he was before me.&#8217; <span class="verse-num" id="v43001031-1">31&nbsp;</span>I myself did not know him, but for this purpose I came baptizing with water, that he might be revealed to Israel.&#8221; <span class="verse-num" id="v43001032-1">32&nbsp;</span>And John bore witness: &#8220;I saw the Spirit descend from heaven like a dove, and it remained on him. <span class="verse-num" id="v43001033-1">33&nbsp;</span>I myself did not know him, but he who sent me to baptize with water said to me, &#8216;He on whom you see the Spirit descend and remain, this is he who baptizes with the Holy Spirit.&#8217; <span class="verse-num" id="v43001034-1">34&nbsp;</span>And I have seen and have borne witness that this is the Son of God.&#8221;</p> <h3 id="p43001035.01-1">Jesus Calls the First Disciples</h3><p id="p43001035.06-1"><span class="verse-num" id="v43001035-1">35&nbsp;</span>The next day again John was standing with two of his disciples, <span class="verse-num" id="v43001036-1">36&nbsp;</span>and he looked at Jesus as he walked by and said, &#8220;Behold, the Lamb of God!&#8221; <span class="verse-num" id="v43001037-1">37&nbsp;</span>The two disciples heard him say this, and they followed Jesus. <span class="verse-num" id="v43001038-1">38&nbsp;</span>Jesus turned and saw them following and said to them, <span class="woc">&#8220;What are you seeking?&#8221;</span> And they said to him, &#8220;Rabbi&#8221; (which means Teacher), &#8220;where are you staying?&#8221; <span class="verse-num" id="v43001039-1">39&nbsp;</span>He said to them, <span class="woc">&#8220;Come and you will see.&#8221;</span> So they came and saw where he was staying, and they stayed with him that day, for it was about the tenth hour.<span class="footnote">&nbsp;<a href="#f7" id="b7" title="That is, about 4 P.M.">[7]</a></span> <span class="verse-num" id="v43001040-1">40&nbsp;</span>One of the two who heard John speak and followed Jesus<span class="footnote">&nbsp;<a href="#f8" id="b8" title="Greek \'him\'">[8]</a></span> was Andrew, Simon Peter\'s brother. <span class="verse-num" id="v43001041-1">41&nbsp;</span>He first found his own brother Simon and said to him, &#8220;We have found the Messiah&#8221; (which means Christ). <span class="verse-num" id="v43001042-1">42&nbsp;</span>He brought him to Jesus. Jesus looked at him and said, <span class="woc">&#8220;So you are Simon the son of John? You shall be called Cephas&#8221;</span> (which means Peter<span class="footnote">&nbsp;<a href="#f9" id="b9" title="\'Cephas\' and \'Peter\' are from the word for \'rock\' in Aramaic and Greek, respectively">[9]</a></span>).</p> <h3 id="p43001043.01-1">Jesus Calls Philip and Nathanael</h3><p id="p43001043.06-1"><span class="verse-num" id="v43001043-1">43&nbsp;</span>The next day Jesus decided to go to Galilee. He found Philip and said to him, <span class="woc">&#8220;Follow me.&#8221;</span> <span class="verse-num" id="v43001044-1">44&nbsp;</span>Now Philip was from Bethsaida, the city of Andrew and Peter. <span class="verse-num" id="v43001045-1">45&nbsp;</span>Philip found Nathanael and said to him, &#8220;We have found him of whom Moses in the Law and also the prophets wrote, Jesus of Nazareth, the son of Joseph.&#8221; <span class="verse-num" id="v43001046-1">46&nbsp;</span>Nathanael said to him, &#8220;Can anything good come out of Nazareth?&#8221; Philip said to him, &#8220;Come and see.&#8221; <span class="verse-num" id="v43001047-1">47&nbsp;</span>Jesus saw Nathanael coming toward him and said of him, <span class="woc">&#8220;Behold, an Israelite indeed, in whom there is no deceit!&#8221;</span> <span class="verse-num" id="v43001048-1">48&nbsp;</span>Nathanael said to him, &#8220;How do you know me?&#8221; Jesus answered him, <span class="woc">&#8220;Before Philip called you, when you were under the fig tree, I saw you.&#8221;</span> <span class="verse-num" id="v43001049-1">49&nbsp;</span>Nathanael answered him, &#8220;Rabbi, you are the Son of God! You are the King of Israel!&#8221; <span class="verse-num" id="v43001050-1">50&nbsp;</span>Jesus answered him, <span class="woc">&#8220;Because I said to you, &#8216;I saw you under the fig tree,&#8217; do you believe? You will see greater things than these.&#8221;</span> <span class="verse-num" id="v43001051-1">51&nbsp;</span>And he said to him, <span class="woc">&#8220;Truly, truly, I say to you,<span class="footnote">&nbsp;<a href="#f10" id="b10" title="The Greek for \'you\' is plural; twice in this verse">[10]</a></span> you will see heaven opened, and the angels of God ascending and descending on the Son of Man.&#8221;</span>  (<a href="http://www.esv.org" class="copyright">ESV</a>)</p></div><div class="footnotes"><h3>Footnotes</h3><p><span class="footnote"><a href="#b1" id="f1">[1]</a></span> <span class="footnote-ref">1:4</span> Or <em>was not any thing made. That which has been made was life in him</em><br /><span class="footnote"><a href="#b2" id="f2">[2]</a></span> <span class="footnote-ref">1:11</span> Greek <em>to his own things</em>; that is, to his own domain, or to his own people<br /><span class="footnote"><a href="#b3" id="f3">[3]</a></span> <span class="footnote-ref">1:11</span> <em>People</em> is implied in Greek<br /><span class="footnote"><a href="#b4" id="f4">[4]</a></span> <span class="footnote-ref">1:18</span> Or <em>the only One, who is God</em>; some manuscripts <em>the only Son</em><br /><span class="footnote"><a href="#b5" id="f5">[5]</a></span> <span class="footnote-ref">1:18</span> Greek <em>in the bosom of the Father</em><br /><span class="footnote"><a href="#b6" id="f6">[6]</a></span> <span class="footnote-ref">1:23</span> Or <em>crying out, &#8216;In the wilderness make straight</em><br /><span class="footnote"><a href="#b7" id="f7">[7]</a></span> <span class="footnote-ref">1:39</span> That is, about <span class="small-caps">4 p.m.</span><br /><span class="footnote"><a href="#b8" id="f8">[8]</a></span> <span class="footnote-ref">1:40</span> Greek <em>him</em><br /><span class="footnote"><a href="#b9" id="f9">[9]</a></span> <span class="footnote-ref">1:42</span> <em>Cephas</em> and <em>Peter</em> are from the word for <em>rock</em> in Aramaic and Greek, respectively<br /><span class="footnote"><a href="#b10" id="f10">[10]</a></span> <span class="footnote-ref">1:51</span> The Greek for <em>you</em> is plural; twice in this verse</p></div></div>'
			  xml  = new XML(text); 
			 p = new SplitXML()
			p.load( xml , 3)
			
			return;
		}
		
		public   function load(xml:XML, pagesReq : int ):void
		{
			var arr : Array = []; 
			var tagTree : Array = [] ; 
			var size : int = this.countXmlSzie(xml)
			var sizePerPage : int = Math.ceil(size/pagesReq)
			var x : Object = xml.descendants()
			this.tagTree = [  ] 
			this.pages  = [] ; 
			currentPageTextOnlyString = '' 
			currentPageFullContents = ''; 
			this.countXmlSzie2(xml,   sizePerPage ) 
			if ( this.currentPageTextOnlyString.length > 0 ) 
				this.addPage(); 
			trace(  xml.toXMLString() ) 
			trace(); 
			for each  ( var page :   Object in this.pages  )
			{
				trace( new XML(page.xml).toXMLString() )
			}
			return;
			//return  arr;
		}
		public var currentPageTextOnlyString : String = '' 
		public var currentPageFullContents : String  = ''; 
		public var pages:Array =[];
		
		private var tagTree : Array = [] ; 
		private var mode_NoSplittingStrings:Boolean=true;
		/**
		 * 
		 * how to add to ti ... when to add element to current ....
		 * */
		private function countXmlSzie2(xml:XML, 
									   sizePerPage:int ):void
		{
			this.currentPageFullContents += this.generateStartTag( xml ) ; 
			this.tagTree.push(xml); 
			var x : Object =[ xml.elements(), xml.children() ]
			//	tagTree = [ xml ]
			var t : Boolean = true; 
			for each (var i:XML in xml.children() )
			{
				var dbg : Array = [i.nodeKind(), i.valueOf()] ;
				//trace('test', dbg.join(', ') ); 
				//trace( i.nodeKind() ) ; 
				if ( i.hasSimpleContent() && i.nodeKind() == 'text'  )
				{
					trace( i.nodeKind(), i)// , i.valueOf() , i.toString()) ; 
					var str : String = i.toString() 
					//currentPageTextOnlyString += str
					
					
					var times : int = testCurrentPage(  str,sizePerPage )
					/*	if ( noSplitNeeded ) 
					{
					addToPage( currentPageTextOnlyString, currentPageFullContents, str,  sizePerPage ); 
					}
					else
					{
					var more : Boolean = true; 
					do  
					{*/
					/*for ( var ix : int = 0 ; ix < times ; ix++ ) 
					{
						str  = addToPageSplit(  str,sizePerPage)
						//more = pageSplit[3]
					}*/
					
					do 
					{
						str  = addToPageSplit(  str,sizePerPage)
					}
					while( str != null && str != '' ) 
					
					/*		}
					while ( more == true ) */
				}						
				
				//size +=str.length
				if ( i.hasSimpleContent() && i.nodeKind() == 'element'  )
				{
					//trace( i.nodeKind() ) ; 
					//trace( i.nodeKind(), i, i.valueOf() ) ; 
					str = i.toString() 
					//size +=str.length
					
				} 
				if (  i.nodeKind() == 'element'  )
				{
					//tagTree.push( xml ) ; 
					this.countXmlSzie2(i, sizePerPage ) 
					//trace( i.nodeKind() ) ; 
					str = i.toString() 
					//size +=str.length
				}
			} 
			
			
			
			this.currentPageFullContents += this.generateClosingTag( xml ) ;  
			this.tagTree.pop(); 
			
		}
		
		private function addPage():void
		{
			this.closeXMLTags(); 
			this.pages.push( { text: this.currentPageTextOnlyString , xml: this.currentPageFullContents } )
			this.currentPageFullContents = this.currentPageTextOnlyString = ''; 
			this.startXMLTags();
		}
		
		/**
		 * clip to end of page ...
		 * 
		 * add str to current page
		 * 
		 * if it doesn't fit, split and return new input 
		 * 
		 * if page is full add start and closing tags, add to pages array 
		 * 
		 * return was is left of string  
		 * */
		private function addToPageSplit(  str:String, sizePerPage:int): String
		{
			var combined : String =  this.currentPageTextOnlyString + str
			var sliceAmount : int = combined.length % sizePerPage
			var times :  Number = combined.length / sizePerPage 
			if ( times <= 1  ) 
			{
				//not adding another page ... 
				var addString : String = str ; 
			}
			else
			{
				var maxICanAdd : int = sizePerPage -  this.currentPageTextOnlyString.length
				addString = str.slice( 0, maxICanAdd ) ;
				var stringRemainder  : String = str.slice(maxICanAdd, str.length  ) ; 
				//rather than split stirngs, break at spaces
				//don't stop calling this until trh string has been chomped ... 
				var words :  Array = str.split( ' ' ) ;
				addString = ''; 
				
				stringRemainder = ''; 
				for   ( var i : int =0; i < words.length; i++  )
				{
					var newWord :  String = words[i]
					if ( addString != '' ) addString += ' '; 
					addString+= newWord
					if ( addString.length +this.currentPageTextOnlyString.length > sizePerPage)
					{
						i = words.length
						continue; 
					}
					
				}
				stringRemainder =  str.slice(addString.length, str.length  ) ;
				//if  ( this.currentPageTextOnlyString  != '' ) addString  = ' ' + addString
			}
			
			this.currentPageTextOnlyString += addString
			this.currentPageFullContents += addString //add tags elsewhere 
			
			if ( this.currentPageTextOnlyString.length == sizePerPage ) 
			{
				this.addPage()
			}
			if ( this.currentPageTextOnlyString.length > sizePerPage ) 
			{
				if ( mode_NoSplittingStrings == false ) 
					throw 'no';
				else
					this.addPage()
			}
			
			return  stringRemainder 
		}
		
		private function closeXMLTags():void
		{
			var rev : Array = this.tagTree.concat().reverse()
			for each (var i:XML in rev   )
			{
				this.currentPageFullContents += this.generateClosingTag(i ) 
			}
		}
		
		private function generateClosingTag(i:XML):String
		{
			var end : String =  '</'+i.localName()+ '>'
			return end;
		}
		
		private function startXMLTags():void
		{
			var rev : Array = this.tagTree; //.concat().reverse()
			for each (var i:XML in rev   )
			{
				this.currentPageFullContents += this.generateStartTag(i);
			}
		}
		
		private function generateStartTag(i:XML):String
		{
			var p : XML = new XML('<'+i.localName()+ '/>');
			this.copy_attributes(  i, p ) ; 
			var str : String = p.toXMLString()
			str = str.slice(0, str.length-2)
			str += '>'
			return str;
		}
		
		private function copy_attributes(x1:XML, x2:XML):XML
		{
			for each (var i:XML in x1.attributes()) {
				x2.@[i.name().localName] = i;
			}
			return x2;
		}
		
		/*		private function addToPage(currentPageTextOnlyString:String, currentPageFullContents:String, str:String, sizePerPage:int):void
		{
		// TODO Auto Generated method stub
		
		}*/
		/**
		 * returns if page is fine ahd has space
		 * get value of new string and see fi larger than page 
		 * */
		private function testCurrentPage(  str:String, pageSizeRequested : int):int
		{
			var combined : String =  this.currentPageTextOnlyString + str
			if ( combined.length < pageSizeRequested  ) 
			{
				return 1; 
			}
			var times : int = 0 ; 
			var start : int =  this.currentPageTextOnlyString.length 
			
			for ( var i : int = start; i < combined.length;  i = i+pageSizeRequested )
			{
				times++
				//i+=
			}
			times
			return times;
		}
		
		private function countXmlSzie(xml:XML):int
		{
			var size : int = 0 ; 
			for each (var i:XML in xml.descendants() )
			{
				if ( i.hasSimpleContent() && i.nodeKind() == 'text'  )
				{
					//trace( i.nodeKind() ) ; 
					var str : String = i.toString() 
					size +=str.length
				}
			} 
			return size;
		}
		
		/*	private function countXmlSzie2(xml:XML):int
		{
		var size : int = 0 ; 
		for each (var i:XML in xml.descendants() )
		{
		if ( i.hasSimpleContent() )
		{
		var str : String = i.toString() 
		size +=str.length
		}
		} 
		return size;
		}*/
	}
}