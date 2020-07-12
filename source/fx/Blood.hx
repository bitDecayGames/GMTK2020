package fx;

import flixel.util.FlxColor;
import flixel.math.FlxVector;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Blood extends FlxEmitter {

	public function new() {
		super();
		// loadParticles()
		this.lifespan.set(0.2,0.5);
		launchMode = CIRCLE;
		speed.set(10, 100, 0, 0);
		this.makeParticles(2, 2, FlxColor.RED);
	}

	public function blast(angle:Float) {
		this.launchAngle.set(angle - 15, angle + 15);
		this.start();
		trace("emitting now");
	}
}