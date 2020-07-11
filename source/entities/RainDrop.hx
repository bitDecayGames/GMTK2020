package entities;

import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

class RainDrop extends FlxSprite {
	private var cam:FlxCamera;
	
	public var done:RainDrop -> Void;

	private var startAltitude:Float;
	private var altitude:Float;
	private var fallRate:Float;
	private var parallaxFactor:Float = 150;

	// hidden stuff to save on allocations
	private var drawOffset = FlxPoint.get();
	private var zeroPoint = FlxPoint.get(0, 0);
	private var center = FlxPoint.get();
	private var altFactor:Float;
	private var posFactor:Float;
	private var tempPos = FlxPoint.get();


	public function new() {
		super(0, 0, AssetPaths.raindrop__png);
	}
	
	public function setCamera(cam:FlxCamera) {
		this.cam = cam;
	}

	override public function update(delta:Float) {
		altitude -= fallRate*delta;

		center.set(camera.x, camera.y)
		.add(camera.width/2, camera.height/2)
		.add(camera.scroll.x, camera.scroll.y);

		altFactor = altitude/startAltitude;
		posFactor = center.distanceTo(getPosition(tempPos)) / (camera.width/2);
		scale.y = posFactor * altFactor;
		
		angle = center.angleBetween(getPosition(FlxPoint.weak()));
		drawOffset.set(0, 1);
		drawOffset.rotate(zeroPoint, angle);
		drawOffset.scale(posFactor * (parallaxFactor * altFactor));

		this.offset.set(drawOffset.x, drawOffset.y);
		
		if (altitude <= 0) {
			done(this);
		}
	}

	override public function destroy() {
		// don't destroy please
	}

	public function fullReset() {
		startAltitude = 30;
		altitude = startAltitude;
		fallRate = 90;
	}
}