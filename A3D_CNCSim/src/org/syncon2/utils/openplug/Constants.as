package org.syncon2.utils.openplug
{
	import org.syncon2.utils.file.ILoadConfig;
	import org.syncon2.utils.openplug.IPlatformGlobals;
	import org.syncon2.utils.sound.IPlaySound;

	public class Constants   
	{
		public function Constants()
		{
		}
		
		static public var app :  Object; 
		public static var PlatformGlobals: IPlatformGlobals;
		
		/**
		 * Environment Switches
		 * */
		public static var MVCMode:Boolean;
		public static var flex:Boolean;
		public static var onCpu:Boolean;
		/**
		 * Allow users to go into edit mode if this is true 
		 * */
		public static var personalDevice:Boolean=false;
		
		public static var  fxAlert : Function; 
		
		/**
		 * Special Function for any purpose
		 * */
		public static var  fx1 : Function; 
		
		public static var FileLoader:ILoadConfig;
		/**
		 * specify manually the folder to load ... in debug mode so we know which ... .
		 * */
		public static var loadFolder:String='';
		/**
		 * Interface for playing sounds as ellips doe snto have native support for mx.sound
		 * */	
		static public var PlaySound : IPlaySound; 
		/**
		 * Where to store config files ... ConfigCommand rips from here
		 * */
		public static var ConfigLocation:String;
		public static var showAds:Boolean;
		public static var debug1:Boolean = false;
		
		
	}
}