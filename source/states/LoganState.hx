package states;

import flixel.FlxG;
import collisions.CollisionManager;
import entities.Player;
import flixel.FlxState;
import levels.Loader;
import entities.RainMaker;

class LoganState extends FlxState
{
	override public function create() {
		super.create();

		var rain = new RainMaker(camera, 250);
		add(rain);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
