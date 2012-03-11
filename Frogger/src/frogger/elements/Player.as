package frogger.elements {

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import frogger.*;
	import frogger.screens.GameScreen;
	import frogger.sprites.*;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	
	
	public class Player extends MovingSprite {
		
		public static const MOVE_TOP:int = 0;
		public static const MOVE_DOWN:int = 1;
		public static const MOVE_LEFT:int = 2;
		public static const MOVE_RIGHT:int = 3;
		
		public var tierSpeed:Number = 0;
		public var dead:Boolean = false;
		
		public var moveLeft:Boolean = false;
		public var moveRight:Boolean = false;
		public var moveUp:Boolean = false;
		public var moveDown:Boolean = false;
		
		public var moveTimer:Timer;
		public var tierIndex:int = 0;
		public var hasBonus:Boolean = false;
		
		private var _frogStand:Texture;
		private var _frogJump:Texture;
		private var _frogSide:Texture;
		private var _frogSideJump:Texture;
		private var _restFrame:Texture;
		private var _deathAnimation:MovieClip; 
		private var _sideStep:int = 22;
		private var _startPoint:Point;
		
		function Player (game:Game, x:int, y:int) {
			
			super(game, x, y);
			
			_startPoint = new Point(x,y);
			
			//store textures for frog
			_frogStand = _game.imageCache.getTexture("frog_stand");
			_frogJump = _game.imageCache.getTexture("frog_jump");
			_frogSide = _game.imageCache.getTexture("frog_side");
			_frogSideJump = _game.imageCache.getTexture("frog_side_jump");
			
			//death animation 
			var dieFrames:Vector.<Texture> = _game.imageCache.getTextures("death_");
			_deathAnimation = new MovieClip(dieFrames, 4);
			_deathAnimation.setFrameDuration(dieFrames.length - 1, 1);
			_deathAnimation.visible = false;
			_deathAnimation.loop = false;
			_deathAnimation.pivotX = _deathAnimation.width*0.5;
			_deathAnimation.pivotY = _deathAnimation.height*0.5;
			_deathAnimation.addEventListener(Event.COMPLETE, onDeathComplete);
			_deathAnimation.stop();
			Starling.juggler.add(_deathAnimation);
			
			
			_restFrame = _frogStand;
			
			moveTimer = new Timer(200, 1);
			moveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFrogRest);
			moveTimer.start();
			
			setSkin(new Image(_frogStand));
			
			_game.getScreen().addChild(skin);
			_game.getScreen().addChild(_deathAnimation);
			
			_deathAnimation.x = skin.x;
			_deathAnimation.y = skin.y;
			
		}
		
		override public function reset ():void {
			x = skin.x = nextX = _startPoint.x;
			y = skin.y = nextY = _startPoint.y;
			hasBonus = false;
			dead = false;
			skin.texture = _frogStand;
			show();
			tierIndex = 0;
			skin.scaleX = skin.scaleY = 1;
		}
		
		public function moveFrogUp ():void {
			if (!moveTimer.running) {
				tierIndex++;
				if (tierIndex >= Tier.TIER_Y.length) tierIndex = Tier.TIER_Y.length - 1;
				nextY = Tier.TIER_Y[tierIndex] + skin.height*0.5;
				moveTimer.reset();
				moveTimer.start();
				showMoveFrame(MovingSprite.UP);
				_game.gameData.addScore(GameData.POINTS_JUMP);
				_game.sounds.play(Sounds.SOUND_JUMP);
				moveUp = false;
			}
		}
		
		public function moveFrogDown ():void {
			if (!moveTimer.running) {
				tierIndex--;
				if (tierIndex < 0) tierIndex = 0;
				nextY = Tier.TIER_Y[tierIndex] + skin.height*0.5;
				moveTimer.reset();
				moveTimer.start();
				showMoveFrame(MovingSprite.DOWN);
				_game.gameData.addScore(GameData.POINTS_JUMP);
				_game.sounds.play(Sounds.SOUND_JUMP);
				moveDown = false;
			}
		}
		
		public function moveFrogLeft ():void {
			if (!moveTimer.running) {
				nextX -= _sideStep;
				moveTimer.reset();
				moveTimer.start();
				showMoveFrame(MovingSprite.LEFT);
				_game.sounds.play(Sounds.SOUND_JUMP);
				moveLeft = false;
			}
		}
		
		public function moveFrogRight ():void {
			if (!moveTimer.running) {
				nextX += _sideStep;
				moveTimer.reset();
				moveTimer.start();
				showMoveFrame(MovingSprite.RIGHT);
				_game.sounds.play(Sounds.SOUND_JUMP);
				moveRight = false;
			}
		}
		
		override public function update (dt:Number):void {
			//play animation if dead
			if (dead) {
				
				return;
			}
			//add tier speed if player is on top of a moving object
			nextX += tierSpeed * dt;
			
			//liten for input
			if (moveLeft) {
				moveFrogLeft();
			} else 
			if (moveRight) {
				moveFrogRight();
			} else 
			if (moveUp) {
				moveFrogUp();
			}else 
			if (moveDown) {
				moveFrogDown();
			}
			
			place();
		}
		
		
		override public function place ():void {
			//limit movement if player is not on water Tiers so frog does not leave the screen
			if (tierIndex < 7) {	
				if (nextX < skin.width * 0.5) 
					nextX = skin.width * 0.5;
				if (nextX > _game.screenWidth - skin.width * 0.5)
					nextX = _game.screenWidth - skin.width * 0.5
			} else {
				//make player go back to start if frog leaves screen on water Tiers
				if (nextX < -skin.width*0.5 || nextX > _game.screenWidth + skin.width*0.5) {
					_game.sounds.play(Sounds.SOUND_OUTOFBOUNDS);
					reset();
				}
					
			}
			super.place();	
		}
				
		public function kill ():void {
			tierSpeed = 0;
			
			_game.gameData.gameMode = Game.GAME_STATE_ANIMATE;
			moveLeft = moveRight = moveUp = moveDown = false;
			skin.visible = false;
			
			_deathAnimation.x = skin.x;
			_deathAnimation.y = skin.y;
			_deathAnimation.visible = true;

			dead = true;
			_deathAnimation.stop();
			_deathAnimation.play();
		}
		
		private function showMoveFrame (dir:int):void {
			switch (dir) {
				case MovingSprite.LEFT:
					skin.scaleX = -1;
					skin.texture = _frogSideJump;
					_restFrame = _frogSide;
					break;
				case MovingSprite.RIGHT:
					skin.scaleX = 1;
					skin.texture = _frogSideJump;
					_restFrame = _frogSide;
					break;
				case MovingSprite.UP:
					skin.scaleY = 1;
					skin.texture = _frogJump;
					_restFrame = _frogStand;
					break;
				case MovingSprite.DOWN:
					skin.scaleY = -1;
					skin.texture = _frogJump;
					_restFrame = _frogStand;
					break;
			}
			
		}
		
		private function onFrogRest (event:TimerEvent):void {
			skin.texture = _restFrame; 
		}

		//to be used with MovieClip
		private function onDeathComplete (event:Event):void {
			_deathAnimation.visible = false;
			
			if (_game.gameData.lives >= 0) {
				setTimeout (
					function ():void {
						reset();
						_game.gameData.gameMode = Game.GAME_STATE_PLAY;
					}, 500
				);
			} else {
				GameScreen(_game.getScreen()).gameOver();
			}
			
				
		}
		
	}
}
