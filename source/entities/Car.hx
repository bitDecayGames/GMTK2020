package entities;

import fx.Blood;
import fx.CarJunk;
import flixel.FlxBasic;
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
	private var naturalDeath:Bool = false;
	private var player:Player;
	private var engineReference:String;

	public var foundTarget:Bool;

	public function new(_player:Player, x:Float, y:Float, destination:FlxPoint = null, maxSpeed:Float = 300, maxTurnRadius:Float = 1,
			visionRadius:Float = 500, slowingDistance:Float = 100) {
		super(x, y, AssetPaths.car0__png);
		width *= .8;
		height = width;
		origin.x = width / 2.0;
		origin.y = height / 2.0;
		this.maxSpeed = maxSpeed;
		this.maxTurnRadius = maxTurnRadius;
		if (destination != null) {
			this.destinations = [destination];
		}
		this.visionRadius = visionRadius;
		this.slowingDistance = slowingDistance;
		player = _player;

		engineReference = FmodManager.PlaySoundWithReference(FmodSFX.EngineIdle);
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

	public function snapAngleTowardsDestination() {
		if (destinations != null && destinations.length > 0) {
			var destination = destinations[0];
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
			angle = angleDif;
			if (angle > 180) {
				angle -= 360;
			} else if (angle < -180) {
				angle += 360;
			}
			velocityToAngle();
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
		velocityToAngle();
		if (Math.abs(angleDif) < 45) {
			if (foundTarget) {
				speedUp(2);
			} else {
				speedUp(1);
			}
		} else {
			// TODO: FX car is hitting the breaks hard here (every frame though...)
			// TODO: FX if the car.foundTarget, then it is actively chasing the player
			speedUp(-3);
		}
		clampToSpeed(!foundTarget ? maxSpeed * .3 : maxSpeed);
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
		var position = getPosition();
		var targetPos:FlxPoint = target != null ? target.getPosition().add(target.width / 2.0, target.height / 2.0) : null;
		if (!foundTarget
			&& target != null
			&& position.distanceTo(targetPos) < visionRadius
			&& Math.abs(FlxPoint.get(0, 1).angleBetween(FlxPoint.get(targetPos.x - position.x, targetPos.y - position.y)) - angle) < 45) {
			// TODO: FX the car JUST saw the player, so maybe some tire squeels here?
			// TODO: FX you could also maybe play a revving sound since car speeds up
			FmodManager.PlaySoundOneShot(FmodSFX.EngineRev);
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
				if (destinations.length == 0) {
					naturalDeath = true;
					kill();
				}
			}
		}

		var myLocation = new FlxPoint(x, y);
		var playerLocation = new FlxPoint(player.x, player.y);

		var distanceFromPlayer:Float = myLocation.distanceTo(playerLocation);
		var carEngineRange = 500;
		if (distanceFromPlayer < carEngineRange) {
			FmodManager.SetEventParameterOnSound(engineReference, "CloseToPlayer", 1 - distanceFromPlayer / carEngineRange);
		}

		checkForTargetVisibility();
	}

	override function kill() {
		super.kill();
		if (!naturalDeath) {
			// TODO: FX car explosion

			var myLocation = new FlxPoint(x, y);
			var playerLocation = new FlxPoint(player.x, player.y);

			if (myLocation.distanceTo(playerLocation) < 300) {
				FmodManager.PlaySoundOneShot(FmodSFX.CarImpact);
			}

			FmodManager.StopSoundImmediately(engineReference);

			var middle = getMidpoint();
			var bloodEmitter = new Blood();
			bloodEmitter.setPosition(middle.x, middle.y);
			FlxG.state.add(bloodEmitter);
			bloodEmitter.blast(angle - 90);

			var junkEmitter = new CarJunk();
			junkEmitter.setPosition(middle.x, middle.y);
			FlxG.state.add(junkEmitter);
			junkEmitter.blast(angle - 90);

			var deadCar = new DeadCar(x, y, angle, bloodEmitter, junkEmitter);
			deadCar.width = width;
			deadCar.height = height;
			deadCar.origin.set(origin.x, origin.y);
			FlxG.state.add(deadCar);
		}
	}

	override function destroy() {
		super.destroy();
		FmodManager.StopSoundImmediately(engineReference);
	}
}

class DeadCar extends FlxSprite {
	private var bloodEmitter:Blood;
	private var junkEmitter:CarJunk;

	public function new(x:Float, y:Float, angle:Float, bloodEmitter:Blood, junkEmitter:CarJunk) {
		super(x, y, AssetPaths.car1__png);
		this.angle = angle;
		health = 3; // 3 seconds to live
		this.bloodEmitter = bloodEmitter;
		this.junkEmitter = junkEmitter;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		hurt(elapsed);
		alpha = health / 3.0;
	}

	override function kill() {
		super.kill();
		bloodEmitter.kill();
		junkEmitter.kill();
	}
}

class CarSpawner extends FlxTypedGroup<FlxSprite> {
	public var x:Float;
	public var y:Float;
	public var carPath:Array<FlxPoint>;
	public var player:Player;

	public function new(x:Float, y:Float, carPath:Array<FlxPoint>, _player:Player) {
		super();
		this.x = x;
		this.y = y;
		this.carPath = carPath;
		player = _player;
		// remove this debug sprite
		// var debugSprite = new FlxSprite(x, y);
		// debugSprite.makeGraphic(20, 20);
		// add(debugSprite);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function spawn():Car {
		var car = new Car(player, x, y);
		var carPathCopy = carPath.map((p) -> p);
		car.setDestinations(carPathCopy);
		car.snapAngleTowardsDestination();
		add(car);

		return car;
	}
}
