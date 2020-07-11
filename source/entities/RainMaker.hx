package entities;

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

	private var spawnBuffer:Float = 200;

	private var rate:Int;
	private var pendingDrops:Float = 0;

	private var tempPos = FlxPoint.get();

	public function new(cam:FlxCamera, rate:Int = 200) {
		super();
		this.cam = cam;
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
			drop.parallaxFactor = 100;
			drop.startAltitude = 200;
			drop.fallRate = 500;

			drop.fullReset();
			drop.setCamera(cam);
			drop.done = returnDrop;
			drop.x = cam.x + cam.scroll.x + FlxG.random.float(-spawnBuffer, cam.width + spawnBuffer);
			drop.y = cam.y + cam.scroll.y + FlxG.random.float(-spawnBuffer, cam.height + spawnBuffer);
			add(drop);
		}

		super.update(delta);
	}

	private function returnDrop(drop:RainDrop) {
		var splash = splashPool.get();
		drop.getGraphicMidpoint(tempPos);
		splash.fullReset(tempPos.x, tempPos.y);
		splash.done = returnSplash;
		add(splash);

		rainPool.put(drop);
	}

	private function returnSplash(splash:RainDropSplash) {
		splashPool.put(splash);
	}
}