package fx;

import flixel.util.FlxColor;
import flixel.math.FlxVector;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Hydrant extends FlxEmitter {

	public function new() {
		super();
		loadParticles(AssetPaths.Hydrant__png, true);
		
		this.lifespan.set(0.2,0.5);
		launchMode = CIRCLE;
		speed.set(20, 200, 0, 0);
	}

	public function blast(angle:Float) {
		this.launchAngle.set(angle - 15, angle + 15);

		angle += 90;

		this.angle.set(angle - 15, angle - 15, angle + 75, angle + 75);
		this.start(true, 0, 1);
		trace("Hydrant emitting now");
	}
}