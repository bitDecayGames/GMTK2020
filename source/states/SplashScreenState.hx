package states;

import config.Configure;
import haxefmod.flixel.FmodFlxUtilities;
import flixel.tweens.misc.VarTween;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;

class SplashScreenState extends FlxState {
	var index = 0;
	var splashImages:Array<FlxSprite> = [];

	var timer = 0.0;
	var splashDuration = 3.0;

	override public function create():Void {
		super.create();

		FmodManager.PlaySoundOneShot(FmodSFX.Mystery);

		// List splash screen image paths here
		loadSplashImages([
			AssetPaths.bitdecaygamesinverted__png,
			AssetPaths.gmtk_splash__png,
		]);

		timer = splashDuration;
		FlxTween.tween(splashImages[0], { alpha: 1 }, 1);

		Configure.initAnalytics();
	}

	private function loadSplashImages(paths:Array<String>) {
		for (p in paths) {
			var splashSprite = new FlxSprite(0, 0, p);
			splashSprite.scale.x = FlxG.width / splashSprite.frameWidth;
			splashSprite.scale.y = FlxG.height / splashSprite.frameHeight;
			splashSprite.updateHitbox();
			add(splashSprite);
			splashSprite.alpha = 0;
			splashImages.push(splashSprite);
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		timer -= elapsed;
		if (timer < 0)
			nextSplash();
	}

	public function nextSplash() {
		var tween:VarTween = FlxTween.tween(splashImages[index], { alpha: 0 }, 0.5);

		index += 1;
		timer = splashDuration;

		if (index < splashImages.length) {
			var splash = splashImages[index];
			tween.then(FlxTween.tween(splash, { alpha: 1 }, 1));
		} else {
			tween.onComplete = (t) -> {
				FmodFlxUtilities.TransitionToState(new MainMenuState());
			};
		}
	}
}
