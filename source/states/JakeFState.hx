package states;

import hud.HUD;
import flixel.util.FlxColor;
import entities.Car;
import flixel.ui.FlxButton;
import flixel.system.debug.console.Console;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxState;
import levels.Loader;
import entities.Player;
import flixel.math.FlxPoint;

class JakeFState extends FlxState
{
	var rainReference:String;
	var hud:HUD;

	override public function create()
	{
		FmodManager.PlaySong(FmodSongs.MainGame);
		rainReference = FmodManager.PlaySoundWithReference(FmodSFX.Rain);
		FmodManager.RegisterLightning(rainReference);

		var player:Player;

		player = new Player();
		player.screenCenter();

		hud = new HUD(player);

		var x = 500.0;
		var y = 200.0;

		var carA = new Car(x, y, new FlxPoint(0, 0), 1500, 5, 1000);
		carA.setTarget(player);

		var carB = new Car(0, 0, new FlxPoint(1000, 1000), 1500, 5, 1000);
		carB.setTarget(player);

		add(carA);
		add(carB);
		add(player);
		add(hud);

		// The camera. It's real easy. Flixel is nice.
		FlxG.camera.follow(player, TOPDOWN, 1);

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