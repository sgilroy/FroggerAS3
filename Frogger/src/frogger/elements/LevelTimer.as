package frogger.elements
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import frogger.Game;
	import frogger.screens.GameScreen;
	import frogger.sprites.GameSprite;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class LevelTimer extends GameSprite
	{
		private var _timeLabel:Image;
		private var _timeBar:Image;
		
		private var _timer:Timer;
		private var _timeWidth:int = 160;
		private var _timeDecrement:Number;
		private var _seconds:int = 0;
		
		public function LevelTimer(game:Game, x:int, y:int)
		{
			super(game, x, y);
			
			_timeLabel = new Image(_game.imageCache.getTexture("label_time"));
			_timeLabel.x = x - _game.screenWidth *0.45;
			_timeLabel.y = y;
			
			//create empty rectangle for the time bar (looks better than a png when resized)
			_timeBar = new Image(Texture.empty(_timeWidth, 10, 0xFF00FF00));
			_timeBar.x = x - _game.screenWidth *0.3;
			_timeBar.y = y + _timeBar.height * 0.2;
			
			_game.getScreen().addChild(_timeLabel);
			_game.getScreen().addChild(_timeBar);
			
			_timeDecrement = _timeWidth*0.004;
			_timer = new Timer(1000, 0);
			_timer.addEventListener(TimerEvent.TIMER, onTickTock, false, 0, true);
		}
		
		public function pauseTimer ():void {
			_timer.stop();
		}
		
		public function startTimer ():void {
			_timer.reset();
			_timer.start();
		}
		
		override public function reset ():void {
			resetLevelTime();
			_timeBar.width = _timeWidth;
			_timeBar.visible = true;
		}
		
		public function resetLevelTime ():void {
			_seconds = 0;
		}
		
		public function getLevelTime ():int {
			return _seconds;
		}
		
		override public function update (dt:Number):void {
			
			if (_game.gameData.gameMode == Game.GAME_STATE_PLAY) {
				if (!_timer.running) {
					_timer.reset();
					_timer.start();
				}
			} else {
				if (_timer.running) _timer.stop();
			}

		}
		
		private function onTickTock (event:TimerEvent):void {
			_seconds++;
			//reduce time bar width
			if (_timeBar.width - _timeDecrement <= 0) {
				GameScreen(_game.getScreen()).gameOver();
				_timeBar.visible = false;
				_timer.stop();
			} else {
				_timeBar.width -= _timeDecrement;
			}
			
		}
	}
}