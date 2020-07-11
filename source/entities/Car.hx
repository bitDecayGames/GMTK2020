package entities;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import lime.utils.AssetBundle;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Car extends FlxSprite {
	private var destinations:Array<FlxPoint>;
	private var target:FlxSprite;
	private var maxSpeed:Float;
	private var maxTurnRadius:Float;
	private var visionRadius:Float;
	private var slowingDistance:Float;
	private var foundTarget:Bool;

	public function new(x:Float, y:Float, destination:FlxPoint = null, maxSpeed:Float = 300, maxTurnRadius:Float = 1, visionRadius:Float = 200,
			slowingDistance:Float = 100) {
		super(x, y, AssetPaths.car0__png);
		origin.y += 30; // per Erik's request to have the sprite rotate from farther back on the car
		this.maxSpeed = maxSpeed;
		this.maxTurnRadius = maxTurnRadius;
		if (destination != null) {
			this.destinations = [destination];
		}
		this.visionRadius = visionRadius;
		this.slowingDistance = slowingDistance;
	}

	public function setTarget(target:FlxSprite):Car {
		this.target = target;
		return this;
	}

	public function setDestination(destination:FlxPoint):Car {
		if (destination != null) {
			this.destinations = [destination];
		} else {
			this.destinations = [];
		}
		return this;
	}

	public function setDestinations(destinations:Array<FlxPoint>):Car {
		this.destinations = destinations;
		return this;
	}

	private function moveTowardsTarget(target:FlxPoint) {
		var position = getPosition().add(width / 2.0, height / 2.0);
		var desiredVelocity = new FlxVector(target.x - position.x, target.y - position.y);
		var steering = desiredVelocity.subtract(velocity.x, velocity.y);
		addSteeringToVelocity(steering.scale(0.5));
		angleToVelocity();
	}

	private function moveTowardsDestination(destination:FlxPoint):Bool {
		var destCopy = new FlxPoint(destination.x, destination.y);
		var position = getPosition().add(width / 2.0, height / 2.0);
		var targetOffset = destCopy.subtract(position.x, position.y);
		var distance = targetOffset.distanceTo(new FlxPoint(0, 0));
		if (distance < slowingDistance * 0.1) {
			velocity.set(0, 0);
			angleToVelocity();
			return true;
		} else {
			var cruisingMaxSpeed = maxSpeed * 0.5;
			var rampedSpeed = cruisingMaxSpeed * (distance / slowingDistance);
			var clippedSpeed = Math.min(rampedSpeed, cruisingMaxSpeed);
			var desiredVelocity = targetOffset.scale(clippedSpeed / distance);
			var steering = desiredVelocity.subtract(velocity.x, velocity.y);
			addSteeringToVelocity(steering);
			angleToVelocity();
			return false;
		}
	}

	private function addSteeringToVelocity(steering:FlxPoint) {
		var vel = new FlxVector(velocity.x, velocity.y);
		var speed = vel.length;
		if (speed == 0) {
			speed = 1;
		}
		var steeringX = steering.x * .1;
		var steeringY = steering.y * .1;
		velocity.add(steeringX, steeringY);
	}

	private function angleToVelocity() {
		if (velocity.x != 0 && velocity.y != 0) {
			angle = velocity.angleBetween(new FlxPoint(0, 1)) - 180;
		}
	}

	private function moveTowardsDestinationByTurning(destination:FlxPoint):Bool {
		var destCopy = new FlxVector(destination.x, destination.y);
		var position = getPosition().add(width / 2.0, height / 2.0);
		var targetOffset = destCopy.subtract(position.x, position.y);
		var targetAngle = FlxPoint.get(0, 1).angleBetween(targetOffset);
		var angleDif = targetAngle - angle;
		if (Math.abs(angleDif) > Math.abs(targetAngle + 360 - angle)) {
			angleDif = targetAngle + 360 - angle;
		} else if (Math.abs(angleDif) > Math.abs(targetAngle - 360 - angle)) {
			angleDif = targetAngle - 360 - angle;
		}
		angle += Math.max(-maxTurnRadius, Math.min(angleDif, maxTurnRadius));
		if (angle > 180) {
			angle -= 360;
		} else if (angle < -180) {
			angle += 360;
		}
		trace(FlxMath.roundDecimal(angle, 2));
		velocityToAngle();
		if (Math.abs(angleDif) < 45) {
			speedUp(1);
		} else {
			speedUp(-3);
		}
		clampToSpeed(maxSpeed * .8);
		return targetOffset.length < slowingDistance * 0.1;
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
			// TODO: FX the car JUST saw the player, so maybe some tire squeels here?
			// TODO: FX you could also maybe play a revving sound since car speeds up
			foundTarget = true;
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (foundTarget && target != null) {
			moveTowardsDestinationByTurning(target.getPosition().add(target.width / 2.0, target.height / 2.0));
		} else if (destinations != null && destinations.length > 0) {
			if (moveTowardsDestinationByTurning(destinations[0])) {
				destinations.shift();
			}
		}
		checkForTargetVisibility();
	}
}

class CarSpawner extends FlxTypedGroup<FlxSprite> {
	public var x:Float;
	public var y:Float;
	public var carPath:Array<FlxPoint>;

	public function new(x:Float, y:Float, carPath:Array<FlxPoint>) {
		super();
		this.x = x;
		this.y = y;
		this.carPath = carPath;
		var debugSprite = new FlxSprite(x, y);
		debugSprite.makeGraphic(20, 20);
		add(debugSprite);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function spawn():Car {
		var car = new Car(x, y);
		var carPathCopy = carPath.map((p) -> p);
		car.setDestinations(carPathCopy);
		add(car);
		return car;
	}
}
