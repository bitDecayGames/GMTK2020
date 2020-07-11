package entities;

import flixel.math.FlxMath;
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
	private var slowingDistance:Float;
	private var foundTarget:Bool;

	public function new(x:Float, y:Float, destination:FlxPoint = null, maxSpeed:Float = 10, maxTurnRadius:Float = 1, visionRadius:Float = 200,
			slowingDistance:Float = 100) {
		super(x, y, AssetPaths.car0__png);
		this.maxSpeed = maxSpeed;
		this.maxTurnRadius = maxTurnRadius;
		this.destination = destination;
		this.visionRadius = visionRadius;
		this.slowingDistance = slowingDistance;
	}

	public function setTarget(target:FlxSprite) {
		this.target = target;
	}

	public function setDestination(destination:FlxPoint) {
		this.destination = destination;
	}

	private function moveTowardsTarget(target:FlxPoint) {
		var position = getPosition().add(width / 2.0, height / 2.0);
		var desiredVelocity = new FlxVector(target.x - position.x, target.y - position.y).normalize().scale(maxSpeed);
		var steering = desiredVelocity.subtract(velocity.x, velocity.y);
		var steeringNormalized = new FlxVector(steering.x, steering.y).normalize();
		velocity.add(steeringNormalized.x * maxTurnRadius, steeringNormalized.y * maxTurnRadius);
	}

	private function moveTowardsDestination(destination:FlxPoint) {
		var position = getPosition().add(width / 2.0, height / 2.0);
		var targetOffset = destination.subtract(position.x, position.y);
		var distance = targetOffset.distanceTo(new FlxPoint(0, 0));
		if (distance < slowingDistance * 0.1) {
			velocity.set(0, 0);
		} else {
			var cruisingMaxSpeed = maxSpeed * 0.8;
			var rampedSpeed = cruisingMaxSpeed * (distance / slowingDistance);
			var clippedSpeed = Math.min(rampedSpeed, cruisingMaxSpeed);
			var desiredVelocity = targetOffset.scale(clippedSpeed / distance);
			var steering = desiredVelocity.subtract(velocity.x, velocity.y);
			var steeringNormalized = new FlxVector(steering.x, steering.y).normalize();
			var steeringDirection = velocity.angleBetween(steeringNormalized);
			var normalizedVelocity = new FlxVector(velocity.x, velocity.y).normalize();
			normalizedVelocity.scale(Math.min(steering.distanceTo(new FlxPoint(0, 0)), maxTurnRadius));
			if (steeringDirection < 0) {
				velocity.add(-normalizedVelocity.y, normalizedVelocity.x);
			} else if (steeringDirection > 0) {
				velocity.add(normalizedVelocity.y, -normalizedVelocity.x);
			} else {
				velocity.add(normalizedVelocity.x, normalizedVelocity.y);
			}
		}
	}

	private function moveTowardsDestinationByTurning(destination:FlxPoint) {
		var position = getPosition().add(width / 2.0, height / 2.0);
		var targetOffset = destination.subtract(position.x, position.y);
		var targetAngle = velocity.angleBetween(targetOffset);
		var angleDif = targetAngle - angle;
		angle += Math.min(angleDif, maxTurnRadius);
		velocityToAngle();
		speedUp(1);
		clampToSpeed(maxSpeed * .8);
	}

	private function velocityToAngle() {
		var zero = new FlxPoint(0, 0);
		var vel = new FlxPoint(0, -velocity.distanceTo(zero));
		vel.rotate(zero, angle);
		velocity.set(vel.x, vel.y);
	}

	private function speedUp(amount:Float) {
		var zero = new FlxPoint(0, 0);
		var up = new FlxPoint(0, -1);
		up.rotate(zero, angle);
		up.scale(amount);
		velocity.add(up.x, up.y);
	}

	private function clampToSpeed(maxSpeed:Float) {
		var vel = new FlxVector(velocity.x, velocity.y);
		var curSpeed = vel.length;
		vel.normalize();
		vel.scale(Math.min(maxSpeed, curSpeed));
		velocity.set(vel.x, vel.y);
	}

	private function pointToString(point:FlxPoint):String {
		return "(" + FlxMath.roundDecimal(point.x, 2) + ", " + FlxMath.roundDecimal(point.y, 2) + ")";
	}

	private function checkForTargetVisibility() {
		if (!foundTarget
			&& target != null
			&& getPosition().distanceTo(target.getPosition().add(target.width / 2.0, target.height / 2.0)) < visionRadius) {
			foundTarget = true;
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (foundTarget && target != null) {
			moveTowardsTarget(target.getPosition().add(target.width / 2.0, target.height / 2.0));
		} else if (destination != null) {
			moveTowardsDestinationByTurning(destination);
		}
		checkForTargetVisibility();
	}
}
