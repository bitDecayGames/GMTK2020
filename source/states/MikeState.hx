package states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import entities.Car;
import flixel.FlxState;

class MikeState extends FlxState {
	private var carA:Car;
	private var carB:Car;

	override public function create() {
		super.create();
		FlxG.debugger.visible = true;

		var x = 100.0;
		var y = 100.0;
		carA = new Car(x, y);
		add(carA);
		// carB = new Car(300, 250);
		// carB.setTarget(carA);
		// add(carB);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		// if (FlxG.keys.justPressed.SPACE) {
		carA.setDestination(FlxG.mouse.getWorldPosition());
		// }
	}
}
