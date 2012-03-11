package frogger
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import frogger.screens.*;
	
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class FrogGame extends Game
	{
		
		[Embed(source='../assets/frogger.png')]
		private static var SourceImage:Class;
		
		[Embed(source='../assets/frogger.xml', mimeType='application/octet-stream')]
		private static var ImageData:Class;
		
		
		public function FrogGame() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, onInit);
			
		}
		
		private function onInit (event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			
			gameData = new GameData(this);
			imageCache = new TextureAtlas(Texture.fromBitmap(new SourceImage()), new XML(new ImageData() ));
			sounds = new Sounds();
			
			//create start screen
			setScreen(MenuScreen);
			
			this.stage.addEventListener(Event.ENTER_FRAME, onLoop);
		}
		
		private function onLoop (event:EnterFrameEvent):void {
			
			if (gameData.gameMode == Game.GAME_STATE_PAUSE) return;
			
			updateGame(event.passedTime);
		}
		
		override protected function updateGame (dt:Number):void {
			_screen.update(dt);	
		}
			
	}
}