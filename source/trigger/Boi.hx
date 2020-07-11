package trigger;

import flixel.FlxSprite;

import flixel.input.keyboard.FlxKey;
import flixel.input.actions.FlxAction.FlxActionDigital;

class Boi extends FlxSprite
{
	var up = new FlxActionDigital();
	var down = new FlxActionDigital();
	var left = new FlxActionDigital();
	var right = new FlxActionDigital();

	public function new()
	{
		super();

		up.addKey(FlxKey.W, PRESSED);
		up.addKey(FlxKey.UP, PRESSED);
		
		down.addKey(FlxKey.S, PRESSED);
		down.addKey(FlxKey.DOWN, PRESSED);
		
		left.addKey(FlxKey.A, PRESSED);
		left.addKey(FlxKey.LEFT, PRESSED);
		
		right.addKey(FlxKey.D, PRESSED);
		right.addKey(FlxKey.RIGHT, PRESSED);

		super.loadGraphic("assets/images/car/car0.png", true, 60, 130);
	}

	override public function update(delta:Float):Void {
		super.update(delta);

		var speed = 80;

		var dx = 0;
		if (left.check()) {
			dx = -1;
		}
		if (right.check()) {
			dx = 1;
		}

		var dy = 0;
		if (up.check()) {
			dy = -1;
		}
		if (down.check()) {
			dy = 1;
		}

		velocity.set(dx * speed, dy * speed);
	}
}