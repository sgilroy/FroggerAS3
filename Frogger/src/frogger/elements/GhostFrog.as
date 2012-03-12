package frogger.elements
{

import flash.geom.Point;

import frogger.Game;
import frogger.sprites.GameSprite;
import frogger.sprites.MovingSprite;

import starling.display.Image;

public class GhostFrog extends MovingSprite
{
	private var _animationTimer:Number = 0;
	private const closeToPlayerDeltaSq:int = 5 * 5;
	private var _player:Player;
	private const moveDetectionDelta:Number = 10;
	private var _id:String;
	
	public function GhostFrog(game:Game, x:int, y:int)
	{
		super(game, x, y);
		speed = 0;
		
		setSkin(new Image(_game.imageCache.getTexture("bullseye")));
		skin.alpha = 0.5;
		skin.scaleX = 2;
		skin.scaleY = 2;

		_game.getScreen().addChild(skin);
	}

	override public function update (dt:Number):void
	{
		_animationTimer += dt;
		if (_player)
			skin.scaleX = 0.5;
		else
			skin.scaleX = Math.sin(_animationTimer * getAnimationPulseSpeed()) * 0.25 + 1;
		skin.scaleY = skin.scaleX;

		movePlayer();
	}

	private function movePlayer():void
	{
		if (_player)
		{
			var direction:Point = new Point(x - _player.x, y - _player.y);

			if (Math.abs(direction.x) > _player.skin.width / 2 || Math.abs(direction.y) > _player.skin.height / 2)
			{
				if (!_player.moveTimer.running)
				{
					if (Math.abs(direction.x) > Math.abs(direction.y))
					{
						if (direction.x > 0)
						{
							_player.moveFrogRight();
						}
						else
						{
							_player.moveFrogLeft();
						}
					}
					else
					{
						if (direction.y > 0)
						{
							_player.moveFrogDown();
						}
						else
						{
							_player.moveFrogUp();
						}
					}

					_player.moveTimer.reset();
					_player.moveTimer.start();
				}
				else
				{
					// show the ghost
				}
			}
		}
	}

	private function getAnimationPulseSpeed():Number
	{
		return _player ? 10 : 5;
	}

	override public function place():void
	{
		skin.x = x;
		skin.y = y;
	}

	public function stopPlayerControl():void
	{
		_player = null;
	}

	public function updatePlayerControl(player:Player):void
	{
		if (_player)
		{
		}
		else
		{
			var deltaX:int = player.x - x;
			var deltaY:int = player.y - y;
			if (deltaX * deltaX + deltaY * deltaY < closeToPlayerDeltaSq)
			{
				_player = player;
			}
		}

//		movePlayer();
	}

	override public function reset ():void {
		hide();
		_animationTimer = 0;
		_player = null;
	}

	public function get id():String
	{
		return _id;
	}

	public function set id(value:String):void
	{
		_id = value;
	}
}
}
