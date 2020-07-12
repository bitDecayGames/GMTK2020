package states;

import flixel.FlxG;
import flixel.FlxState;
import entities.Player;
import flixel.util.FlxColor;

class TannerState extends FlxState
{

	var rainReference:String;

	override public function create()
	{
		FmodManager.PlaySong(FmodSongs.MainGame);
		rainReference = FmodManager.PlaySoundWithReference(FmodSFX.Rain);
		FmodManager.RegisterLightning(rainReference);

		var player:Player;

		player = new Player();
		add(player);
		player.screenCenter();

		// The camera. It's real easy. Flixel is nice.
		// FlxG.camera.follow(player, TOPDOWN, 1);

		// var x = 500.0;
		// var y = 200.0;
		// var carA = new Car(x, y, new FlxPoint(0, 0), 1500, 50, 1000);
		// add(carA);
		// carA.setTarget(player);
		// var carB = new Car(0, 0, new FlxPoint(1000, 1000), 1500, 50, 1000);
		// add(carB);
		// carB.setTarget(player);

		super.create();
	}

	override public function update(elapsed:Float)
	{
        if (FmodManager.HasLightningStruck(rainReference)) {
            FlxG.camera.flash(FlxColor.WHITE, 0.5);
		}
		
		super.update(elapsed);
	}
}