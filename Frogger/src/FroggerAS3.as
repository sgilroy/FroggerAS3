/**
 * Based on Frogger by Roger Engelbert
 * http://www.rengelbert.com/tutorial.php?id=163&show_all=true
 *
 */
package
{

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.ui.Keyboard;

import frogger.FrogGame;

import starling.core.Starling;
import starling.events.Event;
import starling.events.KeyboardEvent;

[SWF(width="320", height="480", backgroundColor="#000000", frameRate="60")]
public class FroggerAS3 extends Sprite
{

	private var _starling:Starling;

	public function FroggerAS3()
	{
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		addEventListener(flash.events.Event.ADDED_TO_STAGE, onInit, false, 0, true);
		stage.addEventListener(flash.events.Event.RESIZE, resizeHandler);
	}

	private function onInit(event:flash.events.Event):void
	{
		//set up starling
		_starling = new Starling(FrogGame, stage);
		_starling.antiAliasing = 1;
		_starling.start();
		_starling.addEventListener(starling.events.Event.CONTEXT3D_CREATE, context3dCreateHandler);
		_starling.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
	}

	private function context3dCreateHandler(event:starling.events.Event):void
	{
//		stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		resizeViewPort();
	}

	private function resizeHandler(e:flash.events.Event):void
	{
		resizeViewPort();
	}

	private function resizeViewPort():void
	{
		var currentAspectRatio:Number = _starling.viewPort.width / _starling.viewPort.height;
		var viewPortRectangle:Rectangle = new Rectangle();
		viewPortRectangle.width = Math.min(stage.stageWidth, stage.stageHeight * currentAspectRatio);
		viewPortRectangle.height = Math.min(stage.stageHeight, stage.stageWidth / currentAspectRatio);
		viewPortRectangle.x = (stage.stageWidth - viewPortRectangle.width) / 2;
		viewPortRectangle.y = (stage.stageHeight - viewPortRectangle.height) / 2;

		_starling.viewPort = viewPortRectangle;
	}

	private function keyDownHandler(event:KeyboardEvent):void
	{
		if (event.keyCode == Keyboard.F11)
		{
			stage.displayState = (stage.displayState == StageDisplayState.NORMAL) ? StageDisplayState.FULL_SCREEN_INTERACTIVE : StageDisplayState.NORMAL;
		}
	}
}
}
