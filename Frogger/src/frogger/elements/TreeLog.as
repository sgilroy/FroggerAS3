package frogger.elements
{
	import flash.geom.Rectangle;
	
	import frogger.Game;
	import frogger.sprites.TierSprite;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class TreeLog extends TierSprite
	{
		
		public static const TREELOG_SMALL:int = 0;
		public static const TREELOG_MEDIUM:int = 1;
		public static const TREELOG_LARGE:int = 2;
		
		public static var TEXTURE_1:Texture;
		public static var TEXTURE_2:Texture;
		public static var TEXTURE_3:Texture;
		
		
		public function TreeLog(game:Game, x:int, y:int, type:int = 0)
		{
			super(game, x, y);
			
			if (!TreeLog.TEXTURE_1) {
				TreeLog.TEXTURE_1 = _game.imageCache.getTexture("log_small");
				TreeLog.TEXTURE_2 = _game.imageCache.getTexture("log_medium");
				TreeLog.TEXTURE_3 = _game.imageCache.getTexture("log_large");
			}
			
			switch (type) {
				case 0:
					setSkin(new Image(TreeLog.TEXTURE_1));
					break;
				case 1:
					setSkin(new Image(TreeLog.TEXTURE_2));
					break;
				case 2:
					setSkin(new Image(TreeLog.TEXTURE_3));
					break;
			}
			body = new Rectangle(0, 0, skin.width*0.9, skin.height);
			_game.getScreen().addChild(skin);
		}
		
		override public function get bounds ():Rectangle {
			body.x = skin.x - body.width*0.5;
			body.y = skin.y - body.height*0.5;
			return body;
		}
		
	}
}