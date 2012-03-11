package frogger.sprites {

	import flash.geom.Rectangle;
	
	import frogger.*;
	
	public class MovingSprite extends GameSprite {
		
		public static const UP:int = 0;
		public static const DOWN:int = 1;
		public static const LEFT:int = 2;
		public static const RIGHT:int = 3;
		
		
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var nextX:Number;
		public var nextY:Number;
		public var speed:Number;
		
		function MovingSprite (game:Game, x:int, y:int) {
			super(game, x, y);
			nextX = x;
			nextY = y;
		}
		
		public function get next_right ():Number {
			return nextX + skin.width * 0.5;
		}
		public function get next_left ():Number {
			return nextX - skin.width * 0.5;
		}
		public function get next_top ():Number {
			return nextY - skin.height * 0.5;
		}
		public function get next_bottom ():Number {
			return nextY - skin.height * 0.5;
		}
		public function get next_bounds ():Rectangle {
			return new Rectangle(next_left, next_top, skin.width, skin.height);
		}
		
		override public function update (dt:Number):void {
			nextX += speed * dt;
		}
		
		public function place ():void {
			x = nextX;
			y = nextY;
			
			skin.x = x;
			skin.y = y;
		}
		
	}
}