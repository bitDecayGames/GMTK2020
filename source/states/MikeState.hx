package states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import entities.Car;
import flixel.FlxState;

class MikeState extends FlxState {
	private var carA:Car;
	private var carB:Car;
	private var carSpawner:CarSpawner;

	override public function create() {
		super.create();
		FlxG.debugger.visible = true;

		var x = 100.0;
		var y = 100.0;
		carA = new Car(x, y);
		add(carA);

		carSpawner = new CarSpawner(300, 300, [
			FlxPoint.get(100, 100),
			FlxPoint.get(500, 0),
			FlxPoint.get(0, 400),
			FlxPoint.get(500, 400)
		]);
		add(carSpawner);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		carA.setDestination(FlxG.mouse.getWorldPosition());
		if (FlxG.keys.justPressed.SPACE) {
			carSpawner.spawn();
		}
	}
}
