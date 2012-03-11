package frogger.sprites
{
	import frogger.Game;
	
	public class TierSprite extends MovingSprite
	{
		public var distance:Number; 
		
		public function TierSprite(game:Game, x:int, y:int)
		{
			super(game, x, y);
		}
	}
}