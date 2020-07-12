package states;

import hud.NotebookHUD;
import levels.Level;
import collisions.CollisionManager;
import flixel.math.FlxRect;
import entities.RainMaker;
import openfl.filters.BitmapFilter;
import objectives.ObjectiveManager;
import checkpoint.CheckpointManager;
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
import shaders.LightShader;

class PlayState extends FlxState
{
	var rainReference:String;

	var notebookHUD:NotebookHUD;
	var hud:HUD;

	var boiGroup: FlxGroup;
	var triggerGroup: FlxGroup;

	var checkpointManager: CheckpointManager;
	var objectiveManager: ObjectiveManager;
	var shader = new LightShader(); 
	var filters:Array<BitmapFilter> = [];
	var level:Level;

	override public function create()
	{
		FmodManager.PlaySong(FmodSongs.MainGame);
		rainReference = FmodManager.PlaySoundWithReference(FmodSFX.Rain);
		FmodManager.RegisterLightning(rainReference);

		// FlxG.debugger.drawDebug = true;
		level = Loader.loadLevel(AssetPaths.city__ogmo, AssetPaths.CityTest__json);
		add(level.walls);
		add(level.background);
				
		var player:Player;
		player = level.player;
		player.setState(this);
		add(player);
		player.screenCenter();

		hud = new HUD(player);
		add(hud);

		objectiveManager = level.objectiveManager;

		notebookHUD = new NotebookHUD(player);
		for (o in level.objectiveManager.getObjectives()) {
			notebookHUD.addObjective(o);
			add(o);
		}
		add(notebookHUD);

		for(hydrant in level.hydrants)
			add(hydrant);
		
		for (spawner in level.carSpawners) {
			add(spawner);
		}

		var collisions = new CollisionManager(this);
		collisions.setLevel(level);

		var rain = new RainMaker(camera, collisions, 250);
		add(rain);

		// The camera. It's real easy. Flixel is nice.
		FlxG.camera.follow(player, TOPDOWN, 1);
		// FlxG.camera.zoom = 0.15;
		var deadzone = new FlxPoint(100, 50);
		FlxG.camera.deadzone = new FlxRect(FlxG.camera.width/2 - deadzone.x/2, FlxG.camera.height/2 - deadzone.y/2, deadzone.x, deadzone.y);
		//needed to correctly create collision data for things off camera
		FlxG.worldBounds.set(0,0,2000,2000);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FmodManager.HasLightningStruck(rainReference)) {
            FlxG.camera.flash(FlxColor.WHITE, 0.5);
		}

		if (FlxG.keys.justPressed.N) {
			level.spawnCar();
		}

		super.update(elapsed);
	}
}
