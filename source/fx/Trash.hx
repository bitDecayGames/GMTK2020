package fx;

import flixel.util.FlxColor;
import flixel.math.FlxVector;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Trash extends FlxEmitter {

	public function new() {
		super();
		loadParticles(AssetPaths.trashPaticle__png, true);
		
		this.lifespan.set(0.2,0.5);
		launchMode = CIRCLE;
		speed.set(20, 200, 0, 0);
	}

	public function blast(angle:Float) {
		this.launchAngle.set(randomAngle(), randomAngle());

		this.angle.set(randomAngle(), randomAngle(), randomAngle(), randomAngle());
		this.start(true, 0, 0);
	}

	private function randomAngle() {
		return Math.random() * 180;
	}
}