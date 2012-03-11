package frogger.elements
{
	import flash.geom.Rectangle;
	
	import frogger.Game;
	import frogger.sprites.GameSprite;
	import frogger.sprites.TierSprite;
	
	public class Tier extends GameSprite {
		
		public static const TIER_TYPE_GROUND:int = 0;
		public static const TIER_TYPE_WATER:int = 1;
		public static const TIER_TYPE_GRASS:int = 2;
		
		//the y values the frog can be at
		public static const TIER_Y:Array = [418,388,357,328,300,272,244,216,182,149,117,84,52];
		//the y values for the elements in each tier
		public static const TIER_ELEMENT_Y:Array = [0,396,367,339,310,281,0,228,194,161,129,95,65];
		
		//which tier is GROUND, or WATER or GRASS
		public static const TIER_TYPES:Array = [0,0,0,0,0,0,0,1,1,1,1,1,2];
		
		//the speeds of each Tier
		public static const TIER_SPEEDS:Array = [0,-20,25,-20,40,-25,0,-30,20,40,-25,20,0];
		
		public var type:int;
		public var speed:Number;
		
		protected var _elements:Vector.<TierSprite>;
		protected var _index:int = 0;
		
		public function Tier(game:Game, index:int) {
			
			super (game, 0, Tier.TIER_Y[index]);
			_game = game;
			_index = index;
			
			this.type = Tier.TIER_TYPES[index];
			this.speed = Tier.TIER_SPEEDS[index];
			
			_elements = new Vector.<TierSprite>;
			
			skin = null;
			
			createElements();
		}
		
		//at the start of each new level, speeds will be updated
		public function refresh ():void {
			if (_index % 2 != 0) {
				this.speed = Tier.TIER_SPEEDS[_index] * _game.gameData.tierSpeed1;
			} else {
				this.speed = Tier.TIER_SPEEDS[_index] * _game.gameData.tierSpeed2;	
			}
		}
		
		public function checkCollision (player:Player):Boolean {
			
			var sprite:TierSprite;
			var collision:Boolean = false;
			var collidingWith:TierSprite;
			var player_rec:Rectangle = player.bounds;
			player.tierSpeed = 0;
			
			for (var i:int = 0; i < _elements.length; i++ ) {
				sprite = _elements[i];
				if (sprite.bounds == null) continue;
				
				//check intersects
				if (sprite.bounds.intersection(player_rec).width > player.skin.width*0.3) {
					collision = true;
					collidingWith = sprite;
					break;
				}
			}
			
			//if on a tier with vehicles... 
			if (type == Tier.TIER_TYPE_GROUND) {
				//if collision, kill player
				if (collision) return true;
			//if on a tier with logs and turtles...
			} else if (type == Tier.TIER_TYPE_WATER) {
				//if no collision drown player
				if (!collision) return true;
				//else, if collision, transfer tier speed to frog 
				player.tierSpeed = speed; 
			} else if (type == Tier.TIER_TYPE_GRASS) {
				//return
			}
			
			return false;
		}
		
		public function getElement (index:int):TierSprite {
			if (_elements.length <= index) return null;
			return _elements[index];
		}
		
		override public function update (dt:Number):void {
			
			var len:int = _elements.length;
			var i:int;
			var sprite:TierSprite;
			switch (_index) {
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 7:
				case 8:
				case 9:
				case 10:
				case 11:
					//move sprites and wrap them on screen
					var nextSprite:TierSprite;
					for (i = 0; i < len; i++) {
						sprite = _elements[i];
						sprite.speed = speed;
						sprite.update(dt);
						
						if (speed < 0) {
							if (sprite.next_right <= 0) {
								if (i != 0) {
									nextSprite = _elements[i-1];
								} else {
									nextSprite = _elements[_elements.length-1];
								}
								sprite.nextX = nextSprite.nextX + sprite.distance;
							}
						} else {
							if (sprite.next_left >= _game.screenWidth) {
								if (i != _elements.length - 1) {
									nextSprite = _elements[i+1];
								} else {
									nextSprite = _elements[0];
								}
								sprite.nextX = nextSprite.nextX - sprite.distance;
							}
						}
						sprite.place();
					}
					break;
			}
		}
		
		protected function createElements ():void {
			
			var element_x:Array = getElementsX();
			var element_type:Array = [];
			var i:int;
			var sprite:TierSprite;
			
			switch (_index) {
				
				//VEHICLES!!!!
				case 1:
					for (i = 0; i < element_x.length; i++) {
						sprite = new Vehicle(_game, element_x[i], TIER_ELEMENT_Y[_index], Vehicle.CAR_1);
						_elements.push(sprite);	
					}
				break;
				
				case 2:
					for (i = 0; i < element_x.length; i++) {
						sprite = new Vehicle(_game, element_x[i], TIER_ELEMENT_Y[_index], Vehicle.CAR_3);
						_elements.push(sprite);	
					}
					
				break;
				case 3:
					for (i = 0; i < element_x.length; i++) {
						sprite = new Vehicle(_game, element_x[i], TIER_ELEMENT_Y[_index], Vehicle.CAR_4);
						_elements.push(sprite);	
					}
					
					
				break;
				case 4:
					for (i = 0; i < element_x.length; i++) {
						sprite = new Vehicle(_game, element_x[i], TIER_ELEMENT_Y[_index], Vehicle.CAR_2);
						_elements.push(sprite);	
					}
					
				break;
				case 5:
					for (i = 0; i < element_x.length; i++) {
						sprite = new Vehicle(_game, element_x[i], TIER_ELEMENT_Y[_index], Vehicle.CAR_5);
						_elements.push(sprite);	
					}
				break;
				
				
				//LOGS AND TURTLES!!!!
				case 7:
					element_type = [false, false, false, true, true, true, false, false, false];
					
					for (i = 0; i < element_x.length; i++) {
						sprite = new Turtle(_game, element_x[i], TIER_ELEMENT_Y[_index], element_type[i]);
						_elements.push(sprite);	
					}
					
				break;
				case 8:
					for (i = 0; i < element_x.length; i++) {
						sprite = new TreeLog(_game, element_x[i], TIER_ELEMENT_Y[_index], TreeLog.TREELOG_SMALL);
						_elements.push(sprite);	
					}
				break;
				case 9:
					for (i = 0; i < element_x.length; i++) {
						sprite = new TreeLog(_game, element_x[i], TIER_ELEMENT_Y[_index], TreeLog.TREELOG_LARGE);
						_elements.push(sprite);	
					}
				break;
				case 10:
					element_type = [true, true, false, false, true, true, false, false];
					for (i = 0; i < element_x.length; i++) {
						sprite = new Turtle(_game, element_x[i], TIER_ELEMENT_Y[_index], element_type[i]);
						_elements.push(sprite);	
					}
				break;
				case 11:
					for (i = 0; i < element_x.length; i++) {
						if (i == 1) {
							sprite = new Crocodile(_game, element_x[i], TIER_ELEMENT_Y[_index]);	
						} else {
							sprite = new TreeLog(_game, element_x[i], TIER_ELEMENT_Y[_index], TreeLog.TREELOG_MEDIUM);
						}
						_elements.push(sprite);	
					}
				break;
			}
			
			speed = Tier.TIER_SPEEDS[_index];
			
			//calculate distance between sprites (for smoother screen wrapping)
			for (i = 0; i < _elements.length; i++) {
				//if moving to the left
				if (Tier.TIER_SPEEDS[_index] < 0) {
					//if not the first element, distance is between this element and previous element
					if (i != 0) {
						_elements[i].distance = _elements[i].x - _elements[i-1].x;
					//else, distance is between this one and the last element
					} else {
						_elements[i].distance = _elements[i].x + (_game.screenWidth - _elements[_elements.length-1].x) + sprite.skin.width;
					}
				//if moving to the right
				} else if (Tier.TIER_SPEEDS[_index] > 0) {
					//if not the last element, distance is between next element and this element
					if (i != _elements.length-1) {
						_elements[i].distance = _elements[i + 1].x - _elements[i].x;
					} else {
						_elements[i].distance = (_game.screenWidth - _elements[i].x) + _elements[0].x + sprite.skin.width;
					}
				}
			}
		}
		
		//move elements back to original X position
		override public function reset():void {
			var element_x:Array = getElementsX();
			for (var i:int = 0; i < _elements.length; i++) {
				_elements[i].x = element_x[i];
				_elements[i].nextX = element_x[i];
				_elements[i].skin.x = element_x[i];
			}
		}
		
		protected function getElementsX ():Array {
			var element_x:Array = [];
			
			switch (_index) {
				
				//VEHICLES!!!!
				case 1:
					element_x = [
						_game.screenWidth*0.1,
						_game.screenWidth*0.4,
						_game.screenWidth*0.6,
						_game.screenWidth*0.9
					];
					break;
				
				case 2:
					element_x = [
						_game.screenWidth*0.2,
						_game.screenWidth*0.45,
						_game.screenWidth*0.7
					];
					break;
				case 3:
					element_x = [
						_game.screenWidth*0.3,						
						_game.screenWidth*0.6,
						_game.screenWidth*0.9
					];
					break;
				case 4:
					element_x = [
						_game.screenWidth*0.5,						
						_game.screenWidth*0.35
					];
					break;
				case 5:
					element_x = [
						_game.screenWidth*0.2,						
						_game.screenWidth*0.5,
						_game.screenWidth*0.8
					];
					break;
				//LOGS AND TURTLES!!!!
				case 7:
					element_x = [
						_game.screenWidth*0.1,						
						_game.screenWidth*0.18,
						_game.screenWidth*0.26,
						
						_game.screenWidth*0.45,						
						_game.screenWidth*0.53,
						_game.screenWidth*0.61,
						
						_game.screenWidth*0.8,						
						_game.screenWidth*0.88,
						_game.screenWidth*0.96
					];
					break;
				case 8:
					
					element_x = [
						_game.screenWidth*0.2,						
						_game.screenWidth*0.5,
						_game.screenWidth*0.8,
					];
					break;
				case 9:
					element_x = [
						_game.screenWidth*0.2,						
						_game.screenWidth*0.8,
					];
					break;
				case 10:
					element_x = [
						
						_game.screenWidth*0.05,						
						_game.screenWidth*0.13,
						
						_game.screenWidth*0.35,						
						_game.screenWidth*0.43,
						
						_game.screenWidth*0.62,						
						_game.screenWidth*0.70,
						
						_game.screenWidth*0.90,						
						_game.screenWidth*0.98,
						
					];
					break;
				case 11:
					element_x = [
						_game.screenWidth*0.15,
						_game.screenWidth*0.5,
						_game.screenWidth*0.85,
					];
					break;
			}
			return element_x;
		}
		
	}
}