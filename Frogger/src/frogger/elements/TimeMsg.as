package frogger.elements
{
	import frogger.Game;
	import frogger.sprites.GameSprite;
	import frogger.sprites.NumberSprite;
	
	import starling.display.Image;
	
	public class TimeMsg extends GameSprite
	{
		
		public var timeLabel:NumberSprite;
		
		public function TimeMsg(game:Game, x:int, y:int)
		{
			super(game, x, y);
			
			setSkin(new Image(_game.imageCache.getTexture("time_box")));
			_game.getScreen().addChild(skin);
			
			//add number sprite to show seconds
			timeLabel = new NumberSprite(_game, x + skin.width *0.1, y, "number_time_");
		}
	}
}