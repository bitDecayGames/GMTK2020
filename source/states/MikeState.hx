package states;

import flixel.math.FlxPoint;
import entities.Car;
import flixel.FlxState;

class MikeState extends FlxState {
	override public function create() {
		super.create();

		var x = 500.0;
		var y = 200.0;
		var carA = new Car(x, y, new FlxPoint(0, 0));
		add(carA);
		var carB = new Car(0, 0, new FlxPoint(1000, 1000));
		carB.setTarget(carA);
		add(carB);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
