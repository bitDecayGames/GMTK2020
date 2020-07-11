package entities;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.util.FlxPool;

class RainMaker extends FlxTypedSpriteGroup<RainDrop> {
	private var rainPool:FlxPool<RainDrop>;
	private var cam:FlxCamera;

	private var rate:Int;

	public function new(cam:FlxCamera, rate:Int = 30) {
		super();
		this.cam = cam;
		this.rate = rate;
		rainPool = new FlxPool<RainDrop>(RainDrop);
		rainPool.preAllocate(200);
	}

	override public function update(delta:Float) {
		var drop:RainDrop;
		for (i in 0...rate) {
			drop = rainPool.get();
			drop.fullReset();
			drop.setCamera(cam);
			drop.done = returnDrop;
			drop.x = cam.x + cam.scroll.x + FlxG.random.float(0, cam.width);
			drop.y = cam.y + cam.scroll.y + FlxG.random.float(0, cam.height);
			add(drop);
		}

		super.update(delta);
	}

	var count = 0;
	private function returnDrop(drop:RainDrop) {
		rainPool.put(drop);
	}
}