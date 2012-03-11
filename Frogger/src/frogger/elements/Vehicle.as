package frogger.elements
{
	import frogger.Game;
	import frogger.sprites.TierSprite;
	
	import starling.display.Image;
	
	public class Vehicle extends TierSprite
	{
		public static const CAR_1:int = 0;
		public static const CAR_2:int = 1;
		public static const CAR_3:int = 2;
		public static const CAR_4:int = 3;
		public static const CAR_5:int = 4;
		
		public function Vehicle(game:Game, x:int, y:int, type:int)
		{
			super(game, x, y);
			
			switch (type) {
				case Vehicle.CAR_1:
					setSkin(new Image(_game.imageCache.getTexture("car_1")));
					break;
				case Vehicle.CAR_2:
					setSkin(new Image(_game.imageCache.getTexture("car_2")));
					break;
				case Vehicle.CAR_3:
					setSkin(new Image(_game.imageCache.getTexture("car_3")));
					break;
				case Vehicle.CAR_4:
					setSkin(new Image(_game.imageCache.getTexture("car_4")));
					break;
				case Vehicle.CAR_5:
					setSkin(new Image(_game.imageCache.getTexture("car_5")));
					break;
			}
			
			_game.getScreen().addChild(skin);
			
		}
	}
}