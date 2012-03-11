package frogger.screens
{
	import frogger.Game;
	import frogger.sprites.MovingSprite;
	
	import starling.display.Sprite;
	
	public class Screen extends Sprite
	{
		
		protected var _game:Game;
		protected var _dynamicElements:Vector.<MovingSprite>;
		
		public function Screen(game:Game)
		{
			_game = game;
		}
		
		public function createScreen():void
		{
			_dynamicElements = new Vector.<MovingSprite>;
		}
		
		public function destroy ():void {
			_dynamicElements = null;
		}
		
		public function update(dt:Number):void{}
	}
}