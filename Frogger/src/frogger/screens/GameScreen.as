package frogger.screens
{

import flash.geom.Point;
import flash.utils.Dictionary;
import flash.utils.setTimeout;

import frogger.*;
import frogger.elements.*;
import frogger.sprites.GameSprite;
import frogger.sprites.NumberSprite;

import org.tuio.ITuioListener;
import org.tuio.TuioBlob;
import org.tuio.TuioCursor;
import org.tuio.TuioObject;

import starling.display.Image;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class GameScreen extends Screen implements ITuioListener
	{	
		
		private var _bg:GameSprite;
		private var _player:Player;
		private var _bonusFrog:BonusFrog;
		private var _controls:Controls;
		private var _tiers:Vector.<Tier>;
		private var _timer:LevelTimer;
		private var _gameOverMsg:GameSprite;
		private var _newLevelMsg:GameSprite;
		private var _levelTimeMsg:TimeMsg;
		private var _score:NumberSprite;
		private var _level:NumberSprite;
		private var _lives:Lives;
		private var _ghostFrogs:Dictionary = new Dictionary();
		private var _ghostFrogsCache:Vector.<GhostFrog> = new Vector.<GhostFrog>();
		
		public function GameScreen(game:Game)
		{
			super(game);
			_tiers = new Vector.<Tier>;
		}

		override public function createScreen():void
		{
			if (numChildren == 0) {
			
				super.createScreen();
				
				//add bg
				_bg = new GameSprite(_game, 0, 0);
				_bg.skin = new Image(_game.imageCache.getTexture("bg"));
				addChild(_bg.skin);
				
				//add tiers (cars, trees, crocodiles, turtles...)
				for (var i:int = 0; i < 12; i++) {
					_tiers.push(new Tier(_game, i));
				}
				_tiers.push(new FinalTier(_game, 12));
				
				//add grass
				var grass:GameSprite = new GameSprite(_game, _game.screenWidth * 0.5, _game.screenHeight * 0.12);
				grass.setSkin(new Image(_game.imageCache.getTexture("grass")));
				addChild(grass.skin);
				
				//add frog
				_player = new Player(_game, _game.screenWidth * 0.5, _game.screenHeight * 0.89);
				_dynamicElements.push(_player);
				
				//add bonus frog 
				_bonusFrog = new BonusFrog (_game,-100, -100, _player);
				_bonusFrog.log = _tiers[8].getElement(0);
				_dynamicElements.push(_bonusFrog);
				
				//add game timer
				_timer = new LevelTimer(_game, _game.screenWidth * 0.5, _game.screenHeight * 0.95);
				
				//add score, level, lives
				_score = new NumberSprite (_game, _game.screenWidth * 0.2, _game.screenHeight * 0.04, "number_score_");
				_level = new NumberSprite (_game, _game.screenWidth * 0.03, _game.screenHeight * 0.04, "number_level_");
				_lives = new Lives (_game, _game.screenWidth * 0.68, _game.screenHeight * 0.02);
				
				//add controls
				if (_game.useControls)
					_controls = new Controls (_game, _game.screenWidth * 0.82, _game.screenHeight * 0.85);
				
				//add game labels (game over, new level, game timer)
				_gameOverMsg = new GameSprite(_game, _game.screenWidth * 0.5, _game.screenHeight * 0.53);
				_gameOverMsg.setSkin(new Image(_game.imageCache.getTexture("game_over_box")));
				_gameOverMsg.hide();
				_newLevelMsg = new GameSprite(_game, _game.screenWidth * 0.5, _game.screenHeight * 0.53);
				_newLevelMsg.setSkin(new Image(_game.imageCache.getTexture("new_level_box")));
				_newLevelMsg.hide();
				addChild(_gameOverMsg.skin);
				addChild(_newLevelMsg.skin);
				_levelTimeMsg = new TimeMsg(_game, _game.screenWidth * 0.5, _game.screenHeight * 0.53);
				_levelTimeMsg.hide();
				//**** TO SHOW SECONDS IN THE MESSAGE ****
				//_levelTimeMsg.timeLabel.showValue(155);
				
			} else {
				_timer.reset();
				_player.reset();
				_bonusFrog.reset();
				_score.reset();
				_level.reset();
				_game.gameData.reset();
				_lives.show();
				for (i = 0; i < _tiers.length; i++) {
					_tiers[i].reset();
				}
				for each (var ghostFrog:GhostFrog in _ghostFrogs)
				{
					var ghostFrogId:String = ghostFrog.id;
					delete _ghostFrogs[ghostFrogId];
					_ghostFrogsCache.push(ghostFrog);
					ghostFrog.reset();
				}
			}
			
			_score.showValue(0);
			_level.showValue(1);
			
			//add main input events
			if (_controls)
				_controls.skin.addEventListener(TouchEvent.TOUCH, onControlTouch);
			_game.stage.addEventListener(TouchEvent.TOUCH, onStageTouch);
			_game.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_game.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			_game.gameData.gameMode = Game.GAME_STATE_PLAY;
			_timer.startTimer();
		}

		private function onStageTouch(event:TouchEvent):void
		{
			controlGhosts(event);
		}

		override public function update (dt:Number):void{
			
			//update frog and bonus frog
			var i:int;
			 for (i = 0; i < _dynamicElements.length; i++) {
				 _dynamicElements[i].update(dt);
				 _dynamicElements[i].place();
			 }
			 
			 //update all tiers
			 for (i = 0; i < _tiers.length; i++) {
				 _tiers[i].update(dt);
			 }
			
			 if (_player.skin.visible) {
				 //check collision of frog and tier sprites
				 if (_tiers[_player.tierIndex].checkCollision(_player)) {
					 //if tiers with vehicles, and colliding with vehicle
					 if (_player.tierIndex < 6) {
						 _game.sounds.play(Sounds.SOUND_HIT);
						 //if not colliding with anything in the water tiers, drown frog
					 } else {
						 _game.sounds.play(Sounds.SOUND_SPLASH);
					 }
					 //kill player
					 _player.kill();
					 stopGhostFrogControl(_player);
					 _game.gameData.lives--;
					 _lives.updateLives();
				 }
				 //check collision of frog and bonus frog
				 //if bonus frog is visible and not on frog
				 if (_bonusFrog.skin.visible) {
					 if (_bonusFrog.bounds.intersects(_player.bounds)) {
						 _player.hasBonus = true; 
					 }
				 }
			 } else {
				 if (_player.hasBonus) {
					 _bonusFrog.hide();
					 _player.hasBonus = false;
				 }
			 }
			 
			 
			 _timer.update(dt);
		}

		private function stopGhostFrogControl(player:Player):void
		{
			for each (var ghostFrog:GhostFrog in _ghostFrogs)
			{
				ghostFrog.stopPlayerControl();
			}
		}
		
		//kill events
		override public function destroy ():void {
			if (_controls)
				_controls.skin.removeEventListener(TouchEvent.TOUCH, onControlTouch);
			_game.stage.removeEventListener(TouchEvent.TOUCH, onStageTouch);
			_game.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_game.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function updateScore ():void {
			_score.showValue(_game.gameData.score);
		}
		
		public function updateLevel ():void {
			_level.showValue(_game.gameData.level);
		}
		
		public function gameOver ():void {
			_gameOverMsg.show();
			_game.gameData.gameMode = Game.GAME_STATE_PAUSE;
			this.addEventListener(TouchEvent.TOUCH, onRestartGame);
		}
		
		//when player has reached one of the 5 targets
		public function targetReached ():void {
			stopGhostFrogControl(_player);

			//show time for this target
			_levelTimeMsg.timeLabel.showValue(_timer.getLevelTime());
			_levelTimeMsg.show();
			_levelTimeMsg.timeLabel.show();
			setTimeout ( function ():void {
				_levelTimeMsg.hide();
				_levelTimeMsg.timeLabel.hide();
			}, 3000
			);
			_timer.resetLevelTime();
			_timer.startTimer();
		}
		
		//start new level
		public function newLevel ():void {
			
			_game.gameData.gameMode = Game.GAME_STATE_PAUSE;
			//increase the speeds in the tiers
			_game.gameData.tierSpeed1 += 0.1;
			_game.gameData.tierSpeed2 += 0.2;
			_game.gameData.addLevel();
			
			for (var i:int  = 0; i < _tiers.length; i++) {
				_tiers[i].refresh();
			}
			
			_timer.reset();
			_game.gameData.gameMode = Game.GAME_STATE_PLAY;
		}
		
		//process touches 
		private function onControlTouch (event:TouchEvent):void {
			event.stopImmediatePropagation();
			if (_game.gameData.gameMode != Game.GAME_STATE_PLAY || !_player.skin.visible) return;

			var touch:Touch = event.getTouch(_controls.skin);
			if (touch && touch.phase == TouchPhase.BEGAN) {
				if (!_player.moveTimer.running) {
					var pos:Point = touch.getLocation(_controls.skin);
					switch (_controls.getDirection(pos)) {
						case Player.MOVE_TOP:
							_player.moveFrogUp();
							break;
						case Player.MOVE_DOWN:
							_player.moveFrogDown();
							break;
						case Player.MOVE_LEFT:
							_player.moveFrogLeft();
							break;
						case Player.MOVE_RIGHT:
							_player.moveFrogRight();
							break;
					}
					_player.moveTimer.reset();
					_player.moveTimer.start();
				}
				
			}
		}

		private function controlGhosts(event:TouchEvent):void
		{
			for each(var touch:Touch in event.touches)
			{
				var ghostFrogId:String = "touch" + touch.id;
				if (touch.phase == TouchPhase.BEGAN)
				{
					createGhostFrog(ghostFrogId, touch.globalX, touch.globalY);
				}
				else if (touch.phase == TouchPhase.MOVED || touch.phase == TouchPhase.STATIONARY)
				{
					updateGhostFrog(ghostFrogId, touch.globalX, touch.globalY);
				}
				else if (touch.phase == TouchPhase.ENDED)
				{
					destroyGhostFrog(ghostFrogId);
				}
			}
		}

		private function createGhostFrog(ghostFrogId:String, globalX:Number, globalY:Number):GhostFrog
		{
			var ghostFrog:GhostFrog;
			if (_ghostFrogsCache.length > 0)
			{
				ghostFrog = _ghostFrogsCache.pop();
				ghostFrog.id = ghostFrogId;
				ghostFrog.x = globalX;
				ghostFrog.y = globalY;
				ghostFrog.place();
				ghostFrog.skin.visible = true;
			}
			else
			{
				ghostFrog = new GhostFrog(_game, globalX, globalY);
				ghostFrog.id = ghostFrogId;
				_dynamicElements.push(ghostFrog);
			}
			_ghostFrogs[ghostFrogId] = ghostFrog;
			ghostFrog.updatePlayerControl(_player);
			return ghostFrog;
		}

		private function updateGhostFrog(ghostFrogId:String, globalX:Number, globalY:Number):GhostFrog
		{
			var ghostFrog:GhostFrog = _ghostFrogs[ghostFrogId] as GhostFrog;
			if (ghostFrog)
			{
				ghostFrog.x = globalX;
				ghostFrog.y = globalY;
				ghostFrog.updatePlayerControl(_player);
			}
			return ghostFrog;
		}

		private function destroyGhostFrog(ghostFrogId:String):GhostFrog
		{
			var ghostFrog:GhostFrog = _ghostFrogs[ghostFrogId] as GhostFrog;
			if (ghostFrog)
			{
				// instead of removing from dynamicElements, we recycle ghosts in a cache
				ghostFrog.reset();
				delete _ghostFrogs[ghostFrogId];
				_ghostFrogsCache.push(ghostFrog);
			}
			return ghostFrog;
		}
		
		private function onKeyDown (event:KeyboardEvent):void {
			switch (event.keyCode) {
				case 38:
					//UP KEY is down
					_player.moveUp = false;
					break;
				case 39:
					//RIGHT KEY is down
					_player.moveRight = false;
					break;
				case 37:
					//LEFT Key is down
					_player.moveLeft = false;
					break;
				case 40:
					//DOWN KEY is down
					_player.moveDown = false;
					break;
			}
		}
		
		
		private function onKeyUp (event:KeyboardEvent):void {
			if (_game.gameData.gameMode != Game.GAME_STATE_PLAY || !_player.skin.visible) return;
			
			switch (event.keyCode) {
				case 38:
					//UP KEY is up
					_player.moveUp = true;
					break;
				case 39:
					//RIGHT KEY is up
					_player.moveRight = true;
					break;
				case 37:
					//LEFT Key is up
					_player.moveLeft = true;
					break;
				case 40:
					//DOWN KEY is up
					_player.moveDown = true;
					break;
			}
		}
		
		//after game over, if player clicks the stage we switch to Menu Screen
		private function onRestartGame (event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);
			if (touch && touch.phase == TouchPhase.ENDED) {
				restartGame();
			}
		}

	private function restartGame():void
	{
		this.removeEventListener(TouchEvent.TOUCH, onRestartGame);
		_gameOverMsg.hide();
		_game.setScreen(MenuScreen);
	}

		public function addTuioObject(tuioObject:TuioObject):void
		{
		}

		public function updateTuioObject(tuioObject:TuioObject):void
		{
		}

		public function removeTuioObject(tuioObject:TuioObject):void
		{
		}

		public function addTuioCursor(tuioCursor:TuioCursor):void
		{
			if (_game.gameData.gameMode == Game.GAME_STATE_PAUSE && _player.dead)
			{
				restartGame();
			}
			else if (stage)
				createGhostFrog("tuio" + tuioCursor.sessionID, tuioCursor.x * stage.stageWidth, tuioCursor.y * stage.stageHeight);
		}

		public function updateTuioCursor(tuioCursor:TuioCursor):void
		{
			if (stage)
			{
				var ghostFrogId:String = "tuio" + tuioCursor.sessionID;

				var ghostFrog:GhostFrog = _ghostFrogs[ghostFrogId] as GhostFrog;
				if (!ghostFrog)
				{
					createGhostFrog(ghostFrogId, tuioCursor.x * stage.stageWidth,
													tuioCursor.y * stage.stageHeight);
				}

				updateGhostFrog(ghostFrogId, tuioCursor.x * stage.stageWidth,
								tuioCursor.y * stage.stageHeight);
			}
		}

		public function removeTuioCursor(tuioCursor:TuioCursor):void
		{
			destroyGhostFrog("tuio" + tuioCursor.sessionID);
		}

		public function addTuioBlob(tuioBlob:TuioBlob):void
		{
		}

		public function updateTuioBlob(tuioBlob:TuioBlob):void
		{
		}

		public function removeTuioBlob(tuioBlob:TuioBlob):void
		{
		}

		public function newFrame(id:uint):void
		{
		}
	}
}