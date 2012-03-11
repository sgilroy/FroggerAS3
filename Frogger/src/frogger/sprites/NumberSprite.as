package frogger.sprites
{
	import frogger.Game;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class NumberSprite extends GameSprite
	{
		public var value:int = 0;
		protected var _textures:Vector.<Texture>;
		protected var _numbers:Vector.<Image>;
		
		public function NumberSprite(game:Game, x:int, y:int, nameRoot:String) {
			
			super(game, x, y);
			
			_textures = new Vector.<Texture>;
			_numbers = new Vector.<Image>;
			
			var i:int;
			
			for (i = 0; i < 10; i++) {
				_textures.push(_game.imageCache.getTexture(nameRoot+i));
			}
			
			var empty:Texture = Texture.empty(_textures[0].width, _textures[0].height, 0);
			y -= empty.height * 0.5;
			
			
			var img:Image;
			for (i = 0; i < 8; i++) {
				img = new Image(empty);
				img.x = x + i * (empty.width + 2);
				img.y = y;
				_numbers.push(img);
				_game.getScreen().addChild(img);
			}
		}
		
		public function showValue (value:uint):void {
			var string:String = ""+value;
			var len:int = string.length;
			if (len > 8) return;
			for (var i:int = 0; i < len; i++) {
				_numbers[i].texture = _textures[int(string.charAt(i))];
			}
		}
		
		override public function reset ():void {
			var empty:Texture = Texture.empty(_textures[0].width, _textures[0].height, 0);
			var img:Image;
			for (var i:int = 0; i < _numbers.length; i++) {
				_numbers[i].texture = empty;
			}
		}
		
		override public function show ():void {
			for (var i:int = 0; i < _numbers.length; i++) {
				_numbers[i].visible = true;
			}
		}
		
		override public function hide ():void {
			for (var i:int = 0; i < _numbers.length; i++) {
				_numbers[i].visible = false;
			}
		}
	}
}