package entities;

import flixel.FlxSprite;

class RainDropSplash extends FlxSprite {
	public var done:(RainDropSplash) -> Void;

	public function new(x:Float, y:Float) {
		// super(x, y);
		super(x, y);
		loadGraphic(AssetPaths.drips__png, true, 3, 5);

		animation.add("do", [0, 1, 2, 3, 4], 30, false);
		animation.play("do");
		animation.finishCallback = (name) -> {
			if (name == "do") {
				done(this);
			}
		};
	}

	override public function destroy() {
		// don't destroy please
	}

	public function fullReset(x:Float, y:Float) {
		setPosition(x, y);
		animation.play("do");
	}
}