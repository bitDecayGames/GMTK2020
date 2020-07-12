package states;

import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.ui.FlxSpriteButton;
import flixel.ui.FlxButton;
import flixel.FlxG;
import collisions.CollisionManager;
import entities.Player;
import entities.NotebookHUD;
import flixel.FlxState;
import levels.Loader;
import entities.RainMaker;

class LoganState extends FlxState
{
	private var notebookHUD:NotebookHUD;

	var rainReference:String;

	override public function create() {
		super.create();

		FmodManager.PlaySong(FmodSongs.MainGame);
		rainReference = FmodManager.PlaySoundWithReference(FmodSFX.Rain);
		FmodManager.RegisterLightning(rainReference);

		var level = Loader.loadLevel(AssetPaths.city__ogmo, AssetPaths.CityTest__json);
		trace(level.background.x);
		trace(level.background.y);
		add(level.walls);
		add(level.background);
		
		var player:Player;
		player = level.player;
		add(player);
		player.screenCenter();

		var collisions = new CollisionManager(this);
		collisions.setLevel(level);
		
		var rain = new RainMaker(camera, collisions, 250);
		add(rain);

		FlxG.camera.follow(player, TOPDOWN, 1);
		FlxG.camera.pixelPerfectRender = true;
		
		notebookHUD = new NotebookHUD();
		add(notebookHUD);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FmodManager.HasLightningStruck(rainReference)) {
			FlxG.camera.flash(FlxColor.WHITE, 0.5);
		}
	}
}
