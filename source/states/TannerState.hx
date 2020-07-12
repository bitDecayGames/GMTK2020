package states;

import collisions.CollisionManager;
import openfl.filters.BitmapFilter;
import objectives.ObjectiveManager;
import checkpoint.CheckpointManager;
import flixel.group.FlxGroup;
import levels.Loader;
import flixel.FlxG;
import flixel.FlxState;
import entities.Player;
import flixel.util.FlxColor;
import shaders.LightShader;

class TannerState extends FlxState
{
	var rainReference:String;
	
	var boiGroup: FlxGroup;
	var triggerGroup: FlxGroup;

	var checkpointManager: CheckpointManager;
	var objectiveManager: ObjectiveManager;
	var shader = new LightShader(); 
	var filters:Array<BitmapFilter> = [];

	override public function create()
	{
		FmodManager.PlaySong(FmodSongs.MainGame);
		rainReference = FmodManager.PlaySoundWithReference(FmodSFX.Rain);
		FmodManager.RegisterLightning(rainReference);

		FlxG.debugger.drawDebug = true;
		var level = Loader.loadLevel(AssetPaths.city__ogmo, AssetPaths.CityTest__json);
		add(level.walls);
		add(level.background);
		
		var player:Player;
		player = level.player;
		add(player);
		player.screenCenter();

		objectiveManager = level.objectiveManager;

		for(o in objectiveManager.getObjectives())
			add(o);

		var collisions = new CollisionManager(this);
		collisions.setLevel(level);

		// var x = 500.0;
		// var y = 200.0;
		// var carA = new Car(x, y, new FlxPoint(0, 0), 1500, 50, 1000);
		// add(carA);
		// carA.setTarget(player);
		// var carB = new Car(0, 0, new FlxPoint(1000, 1000), 1500, 50, 1000);
		// add(carB);
		// carB.setTarget(player);

		FlxG.camera.follow(player, TOPDOWN, 10.1);
		//needed to correctly create collision data for things off camera
		FlxG.worldBounds.set(0,0,2000,2000);

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