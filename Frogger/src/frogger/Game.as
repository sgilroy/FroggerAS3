package frogger
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import frogger.screens.Screen;

import org.tuio.ITuioListener;

import org.tuio.TuioClient;
import org.tuio.connectors.UDPConnector;
import org.tuio.osc.IOSCConnector;

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
			initializeTuioClient();
		}
		
		public function getScreen ():Screen {
			return _screen;
		}
			
		public function setScreen (value:Class):void
		{

			var screen:Screen;
			if (_screens[getQualifiedClassName(value)] == null)
			{
				screen = new value(this);
				_screens[getQualifiedClassName(value)] = screen;
			} else
			{
				screen = _screens[getQualifiedClassName(value)];
			}

			if (_screen)
			{
				//clear current screen
				var tuioListener:ITuioListener = _screen as ITuioListener;
				if (tuioListener && _tuioClient)
					_tuioClient.removeListener(tuioListener);
				removeChild(_screen);
				_screen.destroy();
			}

			_screen = screen;
			_screen.createScreen();
			addChild(_screen);

			tuioListener = _screen as ITuioListener;
			if (tuioListener && _tuioClient)
				_tuioClient.addListener(tuioListener);
		}
		
		public function get screenWidth ():int {
			return FroggerAS3.UNSCALED_WIDTH;
		}
		
		public function get screenHeight ():int {
			return FroggerAS3.UNSCALED_HEIGHT;
		}
		
		protected function updateGame (dt:Number):void {}

		public var _connector:IOSCConnector;
		private var _tuioClient:TuioClient;

		public function initializeTuioClient(host:String = "127.0.0.1", port:int = 3333):void
		{
			if (_tuioClient)
			{
//				_tuioClient.removeListener(TuioManager.init(_stage));
//				_tuioClient.removeListener(this);
				_tuioClient = null;
			}

			if (_connector)
			{
				_connector.close();
				_connector = null;
			}

			try
			{
				_connector = new UDPConnector(host, port);
			} catch (e:Error)
			{
				// TODO: log or otherwise show error
				trace(e.toString());
			}

			if (_connector)
			{
				_tuioClient = new TuioClient(_connector);
//				_tuioClient.addListener(TuioManager.init(_stage));
//				_tuioClient.addListener(this);
			}
		}

		public function get useControls():Boolean
		{
			return _connector == null;
		}
	}
}