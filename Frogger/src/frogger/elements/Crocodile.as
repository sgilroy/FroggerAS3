package frogger.elements
{
	
	import flash.geom.Rectangle;
	
	import frogger.Game;
	import frogger.sprites.TierSprite;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Crocodile extends TierSprite
	{
		
		public static var TEXTURE_1:Texture;
		public static var TEXTURE_2:Texture;
		
		private var _animationCnt:int = 0;
		
		public function Crocodile(game:Game, x:int, y:int)
		{
			super(game, x, y);
			
			if (!Crocodile.TEXTURE_1) {
				Crocodile.TEXTURE_1 = _game.imageCache.getTexture("croc_1");
				Crocodile.TEXTURE_2 = _game.imageCache.getTexture("croc_2");
			}
			
			setSkin(new Image(Crocodile.TEXTURE_1));
			_game.getScreen().addChild(skin);
			
			body = new Rectangle(0, 0, skin.width, skin.height);
		}
		
		override public function update (dt:Number):void {
			super.update(dt);
			
			if (_animationCnt == 60) {
				skin.texture = Crocodile.TEXTURE_2;
				body.width = skin.width*0.4;
			} else if (_animationCnt == 160) {
				skin.texture = Crocodile.TEXTURE_1;
				body.width = skin.width;
				_animationCnt = 1;
			}
			_animationCnt++;
		}
		
		override public function get bounds ():Rectangle {
			body.x = skin.x - body.width*0.5;
			body.y = skin.y - body.height*0.5;
			return body;
		}
	}
}