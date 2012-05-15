package org.syncon2.utils.openplug.ui.comp.settings
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	public class SettingMenuItemVO extends EventDispatcher
	{
		
		static public var CHECK : String = 'check'
		static public var TEXT : String = 'text'
		static public var CUSTOM : String = 'CUSTOM'
		public function get  isCheck() : Boolean { return this.type == CHECK }
		public function get  isText() : Boolean { return this.type == TEXT }
		public function get  isCustom() : Boolean { return this.type == CUSTOM }
		
		static public var UPDATED : String = 'updated_SettingMenuItemVO'
		public function update() : void
		{
			this.dispatchEvent( new Event(UPDATED) ) 
		}
		
		public var fxClick : Function; 
		/**
		 * if set will send to fxString
		 * */
		public var fxClickData : String ;
		
		/**
		 * if set, w ill call fx when data changed, not fxClickData
		 * */
		public var fxClickSendValueWhenChange : Function; 
		
		private var _fxGetValue : Function; 
		
		/**
		 * @private
		 */
		public function set fxGetValue(value:Function):void
		{
			_fxGetValue = value;
		}
		private var _fxGetValueSendInVO : Function; 
		
		/**
		 * @private
		 */
		public function set fxGetValueSendInVO(value:Function):void
		{
			_fxGetValueSendInVO = value;
		}
		
		public var label : String
		public var desc : String 
		public var noAction:Boolean;
		//public var check:Boolean;
		public var more:Boolean;
		public var textSide:String;
		
		[Transient] public var height : Number = 45; 
		
		public var fxGetEnabledSendObj : Function; 
		private var _enabled:Boolean=true;

		public function get enabled():Boolean
		{
			if ( this.fxGetEnabledSendObj != null ) 
				return this.fxGetEnabledSendObj(this.obj)
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		
		public var _textDesc:String;
		public function set textDesc(s : String ): void
		{
			this._textDesc = s; 
		}
		public function get textDesc():String
		{
			if ( this.fxGetTextDesc != null ) 
				return this.fxGetTextDesc(); 
			return this._textDesc; 
		}
		
		
		
		
		public var setValue : Object ; // a string or constant, sent into 
		/***
		 * value ... 
		 * 
		 * */
		private var _value:Object;
		
		public function get value():Object
		{
			if ( this.objField != null && this.obj != null ) 
				return this.obj[this.objField]
			if ( this._fxGetValueSendInVO != null ) 
				return this._fxGetValueSendInVO(this);
			if ( this._fxGetValue != null ) 
				return this._fxGetValue(); //don't think you'll need to send some thing in here ...
			return _value;
		}
		
		public function set value(value:Object):void
		{
			if ( this.objField != null ) 
				this.obj[this.objField] = value
			/*	if ( this.fxClickSendValueWhenChange != null ) 
			this.fxClickSendValueWhenChange(value); 		*/	 
			_value = value;
			this.clicked()
		}
		
		
		//Action
		public var goToScreen : String; 
		public var goToScreenData : Object = null; 
		
		/**
		 * Can define children for when this is clicked .... 
		 * load into another settings screen, 
		 * */
		public var children :SettingMenuConfigVO;// = [] ; 
		public var alwaysRefresh:Boolean;
		public var showValue:Boolean;
		public var parent:SettingMenuConfigVO;
		public var objField:String;
		public var obj:Object;
		/**
		 * sets the text description ... used when item changed
		 * */
		public var fxGetTextDesc: Function;
		private var type:String;
		public var customUiClass:Class;
		public var help:Boolean;
		public var helpText:String;
		
		public function clicked() : void
		{
			var value_ : Object = this.value; 
			if ( this.setValue != null ) 
				value_ = this.setValue; 
			if ( this.fxClickSendValueWhenChange != null ) 
				this.fxClickSendValueWhenChange(value_); 		
			this.parent.clicked(this); 
		}
		;
		
		public function makeCheck():void
		{
			// TODO Auto Generated method stub
			this.type = CHECK
		}
		
		public function makeText():void { this.type = TEXT }
		public function makeCustom():void { this.type = CUSTOM }
		
	}
}