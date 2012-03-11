package frogger.elements
{
	
	import flash.geom.Point;
	
	import frogger.Game;
	import frogger.sprites.GameSprite;
	
	import starling.display.Image;
	
	public class Controls extends GameSprite
	{
		private var _center:Point = new Point();
		
		public function Controls(game:Game, x:int, y:int)
		{
			super(game, x, y);
			setSkin(new Image(_game.imageCache.getTexture("control")));
			_game.getScreen().addChild(skin);
			
			_center.x = skin.width * 0.5;
			_center.y = skin.height * 0.5;
		}
		
		//the circle is divided into quadrants and each one represents a direction
		public function getDirection (p:Point):int {
			var diffx:Number = p.x - _center.x;
			var diffy:Number = p.y - _center.y;
			
			var rad:Number = Math.atan2(diffy, diffx);
			
			var angle:int = (180 * rad) / Math.PI;
			if (angle < 360) angle += 360;
			if (angle > 360) angle -=  360;
			
			if (angle > 315 || angle < 45) {
				return Player.MOVE_RIGHT;
			} else if (angle >= 45 && angle <= 135) {
				return Player.MOVE_DOWN;
			} else if (angle > 135 && angle < 225) {
				return Player.MOVE_LEFT
			} else {
				return Player.MOVE_TOP;
			}
			//return -1;
		}
	}
}