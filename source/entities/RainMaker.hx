package entities;

import collisions.CollisionManager;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.util.FlxPool;

class RainMaker extends FlxTypedSpriteGroup<FlxSprite> {
	private var rainPool:FlxPool<RainDrop>;
	private var splashPool:FlxPool<RainDropSplash>;

	private var cam:FlxCamera;
	private var collisions:CollisionManager;

	private var spawnBuffer:Float = 200;

	private var rate:Int;
	private var pendingDrops:Float = 0;

	private var tempPos = FlxPoint.get();

	public var parallaxFactor = 100;
	public var startAltitude = 200;
	public var fallRate = 500;
	public var roofHeight = 150;

	public function new(cam:FlxCamera, collisions:CollisionManager, rate:Int = 200) {
		super();
		this.cam = cam;
		this.collisions = collisions;

		this.rate = rate;
		rainPool = new FlxPool<RainDrop>(RainDrop);
		rainPool.preAllocate(100);

		splashPool = new FlxPool<RainDropSplash>(RainDropSplash);
		splashPool.preAllocate(100);
	}

	override public function update(delta:Float) {
		pendingDrops += rate * delta;

		var drop:RainDrop;
		while (pendingDrops >= 1) {
			pendingDrops--;
			
			drop = rainPool.get();
			drop.fullReset();
			drop.setCamera(cam);
			drop.parallaxFactor = parallaxFactor;
			drop.startAltitude = startAltitude;
			drop.fallRate = fallRate;
			drop.done = returnDrop;

			drop.x = cam.x + cam.scroll.x + FlxG.random.float(-spawnBuffer, cam.width + spawnBuffer);
			drop.y = cam.y + cam.scroll.y + FlxG.random.float(-spawnBuffer, cam.height + spawnBuffer);

			if (collisions.isRoof(drop.getGroundImpactPoint(tempPos))) {
				drop.splashAltitude = roofHeight;
			} else {
				drop.splashAltitude = 0;
			}

			add(drop);
		}

		super.update(delta);
	}

	private function returnDrop(drop:RainDrop) {
		var splash = splashPool.get();
		drop.getSplashPoint(tempPos);
		splash.fullReset(tempPos.x, tempPos.y);

		var scale = 1 + (drop.splashAltitude/startAltitude);
		splash.scale.set(scale, scale);

		splash.done = returnSplash;
		add(splash);

		rainPool.put(drop);
	}

	private function returnSplash(splash:RainDropSplash) {
		splashPool.put(splash);
	}
}