package frogger.elements
{
	import flash.geom.Rectangle;
	
	import frogger.Game;
	import frogger.sprites.TierSprite;
	
	import starling.display.Image;
	
	public class Target extends TierSprite
	{
		public static const TARGET:int = 0;
		public static const FLY:int = 1;
		public static const CROC:int = 2;
		public static const BONUS_200:int = 3;
		public static const BONUS_400:int = 4;
		
		public var type:int;
		
		
		public function Target(game:Game, x:int, y:int, type:int = 0)
		{
			super(game, x, y);
			this.type = type; 
			
			switch (type) {
				case Target.TARGET:
					setSkin(new Image( _game.imageCache.getTexture("frog_target")));
					break;
				case Target.FLY:
					setSkin(new Image(_game.imageCache.getTexture("fly")));
					break;
				case Target.CROC:
					setSkin(new Image(_game.imageCache.getTexture("alligator")));
					break;
				case Target.BONUS_200:
					setSkin(new Image(_game.imageCache.getTexture("label_200")));
					break;
				case Target.BONUS_400:
					setSkin(new Image(_game.imageCache.getTexture("label_400")));
					break;
			}
			
			body = new Rectangle(x, y, skin.width, skin.height);
			hide();
			_game.getScreen().addChild(skin);
		}
	}
}