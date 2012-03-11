package frogger {
	
	import frogger.screens.GameScreen;
	
	public class GameData {
		
		public static const POINTS_JUMP:int = 10;
		public static const POINTS_TARGET:int = 100;
		public static const POINTS_FLY:int = 100;
		public static const POINTS_BONUS:int = 200;
		
		public var score:int = 0;
		public var level:int = 1;
		public var lives:int = 3;
		public var gameMode:int;
		public var tierSpeed1:Number = 1;
		public var tierSpeed2:Number = 1;
		
		public var game:Game;
		
		function GameData (game:Game) {
			this.game = game;
			gameMode = Game.GAME_STATE_PAUSE;
		}
		
		public function addScore (value:int):void {
			score += value;
			GameScreen(game.getScreen()).updateScore();
		}
		
		public function addLevel ():void {
			level++;
			GameScreen(game.getScreen()).updateLevel();
		}
		
		public function reset ():void {
			score = 0;
			lives = 3;
			level = 1;
			tierSpeed1 = 1;
			tierSpeed2 = 1;
			GameScreen(game.getScreen()).updateScore();
			GameScreen(game.getScreen()).updateLevel();
		}
		
		
	}
}
