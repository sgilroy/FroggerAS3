package frogger.elements
{
	import flash.geom.Rectangle;
	
	import frogger.Game;
	import frogger.sprites.MovingSprite;
	import frogger.sprites.TierSprite;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class BonusFrog extends MovingSprite
	{
		public var log:TierSprite;
		
		private var _frogStand:Texture;
		private var _frogSide:Texture;
		private var _frog:Player;
		private var _animationCnt:int = 0;
		private var _animationInterval:int;
		private var _xMove:Number = 0;
		
		
		public function BonusFrog(game:Game, x:int, y:int, frog:Player) {
			super(game, x, y);
			
			_frog = frog;
			_frogStand = _game.imageCache.getTexture("frog_bonus_stand");
			_frogSide = _game.imageCache.getTexture("frog_bonus_side");
			
			setSkin(new Image(_frogStand));
			_game.getScreen().addChild(skin);
			body = new Rectangle(0, 0, skin.width*0.5, skin.height * 0.5);
			hide();
			_animationInterval = Math.random() * 30;
		}
		
		override public function reset ():void {
			hide();
			_animationCnt = 0;
		}
		
		override public function update(dt:Number):void {
			
			if (!log) return;
			
			if (skin.visible) {
				if (_frog.hasBonus) {
					//if on frog already, move with frog
					nextX = _frog.nextX;
					nextY = _frog.nextY;
				}  else {
					nextX = log.nextX + _xMove;
					nextY = log.nextY;
					//else, still on log, move with log
					if (_animationCnt > _animationInterval) {
						var random:int = Math.floor(Math.random() * 5);
						switch (random) {
							case 0:
								move();
								break;
							case 1:
								if (skin.texture == _frogSide) {
									skin.texture = _frogStand;
								}
								break;
							case 2:
								move();
								break;
							case 3:
								if (skin.texture == _frogStand) {
									skin.texture = _frogSide;
								}
								break;
							case 4:
								if (skin.scaleX < 0) skin.scaleX = 1;
								if (skin.scaleY < 0) skin.scaleY = 1;
								move();
								break;
						}
						_animationInterval = Math.floor(Math.random() * 50);
						_animationCnt = 0;
					}
					_animationCnt++;
				}
			} else {
				//check if log is out of bounds
				if (log.left < 0) {
					nextX = log.nextX;
					nextY = log.nextY;
					show();
				}
			}
		}
		
		override public function get bounds ():Rectangle {
			if (!skin.visible) return null;
			body.x = skin.x - skin.width*0.2;
			body.y = skin.y - skin.height*0.2;
			return body;
		}
		
		private function move ():void {
			if (nextX - skin.width*0.5 > log.next_left) {
				_xMove = -skin.width*0.5;
				skin.scaleX = -1;
				skin.texture = _frogSide;
			} else if (nextX + skin.width*0.5 < log.next_right) {
				_xMove = skin.width*0.5;
				skin.scaleX = 1;
				skin.texture = _frogSide;
			}	
		}
	}
}