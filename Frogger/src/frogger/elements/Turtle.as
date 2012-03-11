package frogger.elements {

	import flash.geom.Rectangle;
	
	import frogger.Game;
	import frogger.sprites.TierSprite;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Turtle extends TierSprite
	{
		public static var TEXTURE_1:Texture;
		public static var TEXTURE_2:Texture;
		public static var TEXTURE_3:Texture;
		
		private var _animated:Boolean;
		private var _animationCnt:int = 0;
		
		public function Turtle(game:Game, x:int, y:int, animated:Boolean = false) {
			
			super(game, x, y);
			
			_animated = animated;
			
			if (!Turtle.TEXTURE_1) {
				Turtle.TEXTURE_1 = _game.imageCache.getTexture("turtle_1");
				Turtle.TEXTURE_2 = _game.imageCache.getTexture("turtle_2");
				Turtle.TEXTURE_3 = _game.imageCache.getTexture("turtle_3");
			}
			
			setSkin(new Image(Turtle.TEXTURE_1));
			body = new Rectangle(0, 0, skin.width*0.8, skin.height * 0.8);
			_game.getScreen().addChild(skin);
		}
		
		override public function update(dt:Number):void {
			
			super.update(dt);
			
			if (_animated) {
				if (_animationCnt == 80) {
					skin.texture = Turtle.TEXTURE_2;
				} else if (_animationCnt == 105) {
					skin.texture = Turtle.TEXTURE_3;
				} else if (_animationCnt == 130) {
					hide();
					skin.texture = Turtle.TEXTURE_2;
				} else if (_animationCnt == 155) {					
					show();
				} else if (_animationCnt == 185) {
					skin.texture = Turtle.TEXTURE_1;
					_animationCnt = 0;
				}
				_animationCnt++;
			}
			
		}
		
		override public function get bounds ():Rectangle {
			if (!skin.visible || skin.texture == Turtle.TEXTURE_3) return null;
			body.x = skin.x - skin.width*0.2;
			body.y = skin.y - skin.height*0.2;
			return body;
		}
		
	}
}