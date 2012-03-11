package frogger.elements
{
	import frogger.Game;
	import frogger.sprites.GameSprite;
	
	import starling.display.Image;
	
	public class Lives extends GameSprite
	{
		private var _lives:Vector.<Image>;
		
		public function Lives(game:Game, x:int, y:int)
		{
			super(game, x, y);
			
			_lives = new Vector.<Image>;
			
			var img:Image;
			for (var i:int = 0; i < _game.gameData.lives; i++) {
				img = new Image (_game.imageCache.getTexture("frog_stand"));
				img.x = x + i * img.width + 5;
				img.y = y;
				_game.getScreen().addChild(img);
				_lives.push(img);
			}
		}
		
		override public function show ():void {
			for (var i:int = 0; i < _lives.length; i++) {
				_lives[i].visible = true;
			}
		}
		
		public function updateLives ():void {
			for (var i:int = 0; i < _lives.length; i++) {
				if (i >= _game.gameData.lives) {
					_lives[i].visible = false;
				}
			}
		}
	}
}