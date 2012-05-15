package org.syncon2.utils.openplug.ui.comp.menu
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	public class BottomMenuItemVO extends EventDispatcher
	{
		
		
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
		public var pic : String 
		public var picSelected : String
		public var noAction:Boolean;
		public var check:Boolean;
		public var more:Boolean;
		public var textSide:String;
		
		[Transient] public var height : Number = 45; 
		public var textDesc:String;
		
		public var setValue : Object ; // a string or constant, sent into 
		/***
		 * value ... 
		 * 
		 * */
		private var _value:Object;
		
		public function get value():Object
		{
			
			if ( this._fxGetValueSendInVO != null ) 
				return this._fxGetValueSendInVO(this);
			if ( this._fxGetValue != null ) 
				return this._fxGetValue(); //don't think you'll need to send some thing in here ...
			return _value;
		}
		
		public function set value(value:Object):void
		{
			if ( this.fxClickSendValueWhenChange != null ) 
				this.fxClickSendValueWhenChange(value); 			 
			_value = value;
		}
		
		
		//Action
		public var goToScreen : String; 
		public var goToScreenData : Object = null; 
		
		public var data :Object; 
		
		/**
		 * Can define children for when this is clicked .... 
		 * load into another settings screen, 
		 * */
		public var children :BottomMenuItemVO;// = [] ; 
		public var alwaysRefresh:Boolean;
		public var showValue:Boolean;
		public var parent:BottomMenuConfigVO;
		
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
		
	}
}