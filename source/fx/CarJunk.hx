package fx;

import flixel.util.FlxColor;
import flixel.math.FlxVector;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class CarJunk extends FlxEmitter {

	public function new() {
		super();
		loadParticles(AssetPaths.carParts__png, true);
		
		this.lifespan.set(0.2,0.5);
		launchMode = CIRCLE;
		speed.set(20, 200, 0, 0);
	}

	public function blast(angle:Float) {
		this.launchAngle.set(angle - 15, angle + 15);

		angle += 90;

		this.angle.set(angle - 15, angle - 15, angle + 15, angle + 15);
		this.start(true, 0, 5);
		trace("emitting now");
	}
}