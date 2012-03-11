package frogger
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import frogger.screens.Screen;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	
	public class Game extends Sprite
	{
		public static const GAME_STATE_PLAY:int = 0;
		public static const GAME_STATE_PAUSE:int = 1;
		public static const GAME_STATE_ANIMATE:int = 2;
		
		public var gameData:GameData;
		public var imageCache:TextureAtlas;
		public var sounds:Sounds;
		public var viewPort:Rectangle;
		
		protected  var _screen:Screen;
		protected var _screens:Dictionary;
		
		public function Game()
		{
			super();
			_screens = new Dictionary();
			viewPort = Starling.current.viewPort;
		}
		
		public function getScreen ():Screen {
			return _screen;
		}
			
		public function setScreen (value:Class):void {
			
			var screen:Screen;
			if (_screens[getQualifiedClassName(value)] == null) {
				screen = new value (this);
				_screens[getQualifiedClassName(value)] = screen;
			} else {
				screen = _screens[getQualifiedClassName(value)];
			}
			
			if (_screen) {
				//clear current screen
				removeChild(_screen);
				_screen.destroy();
			}
			
			_screen = screen;
			_screen.createScreen();
			addChild(_screen);
			
		}
		
		public function get screenWidth ():int {
			return viewPort.width;	
		}
		
		public function get screenHeight ():int {
			return viewPort.height;	
		}
		
		protected function updateGame (dt:Number):void {}
	}
}