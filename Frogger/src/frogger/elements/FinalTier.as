package frogger.elements
{
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import frogger.Game;
	import frogger.GameData;
	import frogger.Sounds;
	import frogger.screens.GameScreen;
	import frogger.sprites.TierSprite;
	
	public class FinalTier extends Tier
	{
		private var _targets:Vector.<Target>;
		private var _flies:Vector.<Target>;
		private var _crocs:Vector.<Target>;
		private var _bonus200:Vector.<Target>;
		private var _bonus400:Vector.<Target>;
		private var _bonusCnt:int;
		private var _targetsReached:int = 0;
		
		public function FinalTier(game:Game, index:int)
		{
			super(game, index);
		}
		
		override public function checkCollision(player:Player):Boolean {
			
			var sprite:TierSprite;
			var collision:Boolean = false;
			var collidingWith:TierSprite;
			var player_rec:Rectangle = player.bounds;
			player.tierSpeed = 0;
			
			for (var i:int = 0; i < _targets.length; i++ ) {
				sprite = _targets[i];
				if (sprite.bounds == null) continue;
				
				//check intersects
				if (sprite.bounds.intersection(player_rec).width > player.skin.width*0.3) {
					collision = true;
					collidingWith = sprite;
					break;
				}
			}
			
			
			if (collision) {
				//if this target has been reached already...
				if (_targets[i].skin.visible) {
					//send player back to beginning
					player.reset();
					return false;
				} else {
					//check if croc head is in the slot
					if (_crocs[i].skin.visible) {
						//kill player!!!
						return true;
					} else {
						
						var bonus:int = 0;
						//check if there are flies in this slot
						if (_flies[i].skin.visible) {
							_flies[i].hide()
							bonus += GameData.POINTS_FLY;
						}
						if (player.hasBonus) bonus += GameData.POINTS_BONUS;
						
						//show bonus points!!!
						if (bonus > 0) {
							if (bonus > GameData.POINTS_BONUS) {
								_bonus400[i].show();
							} else {
								_bonus200[i].show();
							}
							_game.gameData.addScore (bonus);
							
							//show target reached icon after displaying bonus for some time
							setTimeout(function ():void {
								_bonus400[i].hide();
								_bonus200[i].hide();
								_targets[i].show();
							}, 500);
							
						} else {
							_targets[i].show();
						}
						
						_targetsReached++;
						_game.sounds.play(Sounds.SOUND_PICKUP);
						
						
						setTimeout(function ():void {
							GameScreen(_game.getScreen()).targetReached();
							if (_targetsReached == 5)  {
								_game.sounds.play(Sounds.SOUND_TARGET);
								//start new level
								GameScreen(_game.getScreen()).newLevel();
								hide();
							}
							player.reset();
							
						}, 1000);
						
						
						//add points for reaching a target
						_game.gameData.addScore (GameData.POINTS_TARGET);
						player.hide();
						
					}
					return false;
				}
			}
			
			
			return true;
		}
		
		override public function update(dt:Number):void {
			
			//show fly or croc head
			
			for (var i:int = 0; i < _crocs.length; i++) {
				if (_crocs[i].skin.visible) {
					if (_targets[i].skin.visible) {
						_crocs[i].skin.visible = false;	
					} else {
						if (_crocs[i].skin.x < _crocs[i].x) {
							_crocs[i].skin.x += 0.4;
						}
					}
				}
			}
			
			if (_bonusCnt > 50) {
				_bonusCnt = 0;
				if (Math.random() > 0.6) {
					//pick an index
					var index:int = Math.floor(Math.random() * _targets.length);
					if (!_targets[index].skin.visible && 
						!_flies[index].skin.visible && !_crocs[index].skin.visible) {
						if (Math.random() > 0.6) {
							_crocs[index].skin.x -= _crocs[index].skin.width;
							_crocs[index].show();
						} else {
							_flies[index].show();
						}
						setTimeout ( function ():void {
							_crocs[index].hide();
							_flies[index].hide();
						}, 4000
						);
					}
				}
				
			}
			_bonusCnt++;
		}
		
		
		override public function reset ():void {
			
			_targetsReached = 0;

			hide();
			
			_bonusCnt = 0;
		}
		
		override public function hide():void {
			for (var i:int = 0; i < _targets.length; i++) {
				_targets[i].hide();
				_flies[i].hide();
				_crocs[i].hide();
				_bonus200[i].hide();
				_bonus400[i].hide();
				
			}
		}
		
		override protected function createElements ():void {
			
			_targets = new Vector.<Target>;
			_flies = new Vector.<Target>;
			_crocs = new Vector.<Target>;
			_bonus200 = new Vector.<Target>;
			_bonus400 = new Vector.<Target>;
			
			var sprite:Target;
			
			var element_x:Array = [
				_game.screenWidth*0.07,
				_game.screenWidth*0.29,
				_game.screenWidth*0.5,
				_game.screenWidth*0.715,
				_game.screenWidth*0.93
			];
			
			for (var i:int = 0; i < element_x.length; i++) {
				
				
				sprite = new Target(_game, element_x[i], TIER_ELEMENT_Y[_index], 1);
				_flies.push(sprite);	
				
				sprite = new Target(_game, element_x[i], TIER_ELEMENT_Y[_index], 2);
				_crocs.push(sprite);	
				
				sprite = new Target(_game, element_x[i], TIER_ELEMENT_Y[_index], 0);
				_targets.push(sprite);	
				
				
				sprite = new Target(_game, element_x[i], TIER_ELEMENT_Y[_index], 3);
				_bonus200.push(sprite);	
				
				sprite = new Target(_game, element_x[i], TIER_ELEMENT_Y[_index], 4);
				_bonus400.push(sprite);
				
				
			}
		}		
	}
}