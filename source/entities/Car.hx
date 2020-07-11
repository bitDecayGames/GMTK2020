package entities;

import flixel.math.FlxVector;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import lime.utils.AssetBundle;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Car extends FlxSprite {
	private var destination:FlxPoint;
	private var target:FlxSprite;
	private var maxSpeed:Float;
	private var maxTurnRadius:Float;
	private var visionRadius:Float;
	private var foundTarget:Bool;

	public function new(x:Float, y:Float, destination:FlxPoint, maxSpeed:Float = 1000, maxTurnRadius:Float = 1, visionRadius:Float = 100) {
		super(x, y, AssetPaths.car0__png);
		this.maxSpeed = maxSpeed;
		this.maxTurnRadius = maxTurnRadius;
		this.destination = destination;
		this.visionRadius = visionRadius;
	}

	public function setTarget(target:FlxSprite) {
		this.target = target;
	}

	private function moveTowardsTarget(target:FlxPoint) {
		var position = getPosition();
		var desiredVelocity = new FlxVector(target.x - position.x, target.y - position.y).normalize().scale(maxSpeed);
		var steering = desiredVelocity.subtract(velocity.x, velocity.y);
		var steeringNormalized = new FlxVector(steering.x, steering.y).normalize();
		velocity.add(steeringNormalized.x * maxTurnRadius, steeringNormalized.y * maxTurnRadius);
	}

	private function moveTowardsDestination(destination:FlxPoint) {
		var slowingDistance = 100.0;
		var position = getPosition();
		var targetOffset = destination.subtract(position.x, position.y);
		var distance = targetOffset.distanceTo(new FlxPoint(0, 0));
		var rampedSpeed = maxSpeed * (distance / slowingDistance);
		var clippedSpeed = Math.min(rampedSpeed, maxSpeed);
		var desiredVelocity = targetOffset.scale(clippedSpeed / distance);
		var steering = desiredVelocity.subtract(velocity.x, velocity.y);
		var steeringNormalized = new FlxVector(steering.x, steering.y).normalize();
		velocity.add(steeringNormalized.x * maxTurnRadius, steeringNormalized.y * maxTurnRadius);
	}

	private function rotateToVelocity() {
		this.angle = this.velocity.angleBetween(new FlxPoint(0, 1));
	}

	private function checkForTargetVisibility() {
		if (target != null && getPosition().distanceTo(target.getPosition()) < visionRadius) {
			foundTarget = true;
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (foundTarget && target != null) {
			moveTowardsTarget(target.getPosition());
		} else {
			moveTowardsDestination(destination);
			checkForTargetVisibility();
		}
		rotateToVelocity();
	}
}
