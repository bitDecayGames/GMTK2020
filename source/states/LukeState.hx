package states;

import entities.Car;
import hud.HUD;
import objectives.ObjectiveManager;
import entities.Player;
import collisions.CollisionManager;
import flixel.FlxSprite;
import trigger.Trigger;
import com.bitdecay.textpop.TextPop;
import trigger.Boi;
import checkpoint.CheckpointManager;
import flixel.group.FlxGroup;
import flixel.FlxG;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import shaders.LightShader;
import flixel.FlxState;
import levels.Loader;
import flixel.math.FlxPoint;

class LukeState extends FlxState
{
	var boiGroup: FlxGroup;
	var triggerGroup: FlxGroup;

	var checkpointManager: CheckpointManager;
	var objectiveManager: ObjectiveManager;
	var shader = new LightShader(); 
	var filters:Array<BitmapFilter> = [];
	var hud:HUD;

	
	override public function create()
	{
		super.create();

		FlxG.debugger.drawDebug = true;
		var level = Loader.loadLevel(AssetPaths.city__ogmo, AssetPaths.CityTest__json);
		add(level.walls);
		add(level.background);
		
		
		var player:Player;
		player = level.player;
		add(player);
		player.screenCenter();

		objectiveManager = level.objectiveManager;

		hud = new HUD(player);
		add(hud);

		for(o in objectiveManager.getObjectives())
			add(o);

		for(hydrant in level.hydrants)
			add(hydrant);

		var collisions = new CollisionManager(this);
		collisions.setLevel(level);
		
		var x = 500.0;
		var y = 200.0;
		var carA = new Car(x, y, new FlxPoint(0, 0), 1500, 5, 1000);
		carA.setTarget(player);
		var carB = new Car(0, 0, new FlxPoint(1000, 1000), 1500, 5, 1000);
		carB.setTarget(player);

		add(carA);
		add(carB);
		level.cars.push(carA);
		level.cars.push(carB);
		// The camera. It's real easy. Flixel is nice.
		FlxG.camera.follow(player, TOPDOWN, 1);
		FlxG.camera.zoom = 0.5;
		//needed to correctly create collision data for things off camera
		FlxG.worldBounds.set(0,0,2000,2000);
	}
	
}
