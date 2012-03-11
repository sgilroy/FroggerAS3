package frogger.sprites {

	import flash.geom.Rectangle;
	
	import frogger.*;
	
	import starling.display.Image;
	
	public class GameSprite {
		
		public var active:Boolean = true;
		
		public var x:Number;
		public var y:Number;
		public var skin:Image;
		public var body:Rectangle;
		
		protected var _game:Game;
		
		function GameSprite (game:Game, x:int, y:int) {
			_game = game;
			this.x = x;
			this.y = y;
		}
		
		//move reference point to center of Image
		public function setSkin (skin:Image):void {
			this.skin = skin;
			skin.pivotX = skin.width * 0.5;
			skin.pivotY = skin.height * 0.5;
			skin.x = x;
			skin.y = y;
		}
		
		public function get right ():Number {
			return x + skin.width * 0.5;
		}
		public function get left ():Number {
			return x - skin.width * 0.5;;
		}
		public function get top ():Number {
			return y - skin.height * 0.5;
		}
		public function get bottom ():Number {
			return y + skin.height * 0.5;
		}
		
		public function get bounds ():Rectangle {
			return new Rectangle(left, top, skin.width, skin.height);
		}
			
		public function reset():void {}
		
		public function update (dt:Number):void {}
		
		public function show ():void {
			if (skin) skin.visible = true;
		}
		
		public function hide ():void {
			if (skin) skin.visible = false;
		}
	}
}