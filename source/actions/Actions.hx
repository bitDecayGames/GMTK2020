package actions;

import flixel.input.FlxInput.FlxInputState;
import flixel.input.mouse.FlxMouseButton.FlxMouseButtonID;
import flixel.input.keyboard.FlxKey;
import flixel.input.actions.FlxAction.FlxActionDigital;

class Actions {

	public var up = new FlxActionDigital();
	public var down = new FlxActionDigital();
	public var left = new FlxActionDigital();
	public var right = new FlxActionDigital();
	public var dive = new FlxActionDigital();
	public var run = new FlxActionDigital();

	public function new() {
		up.addKey(FlxKey.W, PRESSED);
		up.addKey(FlxKey.UP, PRESSED);
		
		down.addKey(FlxKey.S, PRESSED);
		down.addKey(FlxKey.DOWN, PRESSED);
		
		left.addKey(FlxKey.A, PRESSED);
		left.addKey(FlxKey.LEFT, PRESSED);
		
		right.addKey(FlxKey.D, PRESSED);
		right.addKey(FlxKey.RIGHT, PRESSED);

		dive.addKey(FlxKey.SPACE, JUST_PRESSED);
		dive.addKey(FlxKey.Z, JUST_PRESSED);

		run.addKey(FlxKey.SHIFT, PRESSED);
	}
}