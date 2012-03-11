package frogger.screens
{
	import frogger.Game;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class MenuScreen extends Screen {
		
		public function MenuScreen(game:Game) {
			super(game);
			
		}
		
		override public function createScreen():void {
			if (numChildren == 0) {
				
				//add bg
				var bg:Quad = new Quad (_game.screenWidth, _game.screenHeight, 0xFF666666);
				addChild(bg);
				
				//add logo
				var logo:Image = new Image (_game.imageCache.getTexture("logo"));
				logo.pivotX = logo.width*0.5;
				logo.pivotY = logo.height*0.5;
				logo.x = _game.screenWidth * 0.5;
				logo.y = _game.screenHeight * 0.3;
				addChild(logo);
				
				var label1:Image = new Image (_game.imageCache.getTexture("label_how_to"));
				label1.pivotX = label1.width*0.5;
				label1.pivotY = label1.height*0.5;
				label1.x = _game.screenWidth * 0.5;
				label1.y = _game.screenHeight * 0.45;
				addChild(label1);
				
				var controls:Image = new Image (_game.imageCache.getTexture("control"));
				controls.pivotX = controls.width*0.5;
				controls.pivotY = controls.height*0.5;
				controls.x = _game.screenWidth * 0.5;
				controls.y = _game.screenHeight * 0.6;
				addChild(controls);
				
				var label2:Image = new Image (_game.imageCache.getTexture("label_instructions"));
				label2.pivotX = label2.width*0.5;
				label2.pivotY = label2.height*0.5;
				label2.x = _game.screenWidth * 0.5;
				label2.y = _game.screenHeight * 0.8;
				addChild(label2);
				
				var label3:Image = new Image (_game.imageCache.getTexture("label_tap"));
				label3.pivotX = label3.width*0.5;
				label3.pivotY = label3.height*0.5;
				label3.x = _game.screenWidth * 0.5;
				label3.y = _game.screenHeight * 0.98;
				addChild(label3);
				
				this.flatten();
			}
			
			addEventListener(TouchEvent.TOUCH, onStartTouch);
		}
		
		override public function destroy():void {
			removeEventListener(TouchEvent.TOUCH, onStartTouch);
		}
		
		//listen to mouse click (touch) and switch screen to GameScreen
		private function onStartTouch (event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);
			if (touch && touch.phase == TouchPhase.ENDED) {
				_game.setScreen(GameScreen);
			}
		}
	}
}