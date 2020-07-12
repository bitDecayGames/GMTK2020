package states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import entities.Car;
import flixel.FlxState;
import flixel.group.FlxGroup;
import shaders.LightShader;
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
import levels.Level;
import flixel.math.FlxPoint;

class MikeState extends FlxState {
	var boiGroup:FlxGroup;
	var triggerGroup:FlxGroup;

	var checkpointManager:CheckpointManager;
	var objectiveManager:ObjectiveManager;
	var shader = new LightShader();
	var filters:Array<BitmapFilter> = [];
	var hud:HUD;
	var level:Level;

	override public function create() {
		super.create();

		FlxG.debugger.drawDebug = true;
		level = Loader.loadLevel(AssetPaths.city__ogmo, AssetPaths.CityTest__json);
		add(level.walls);
		add(level.background);
		for (spawner in level.carSpawners) {
			add(spawner);
		}

		var player:Player;
		player = level.player;
		add(player);
		player.screenCenter();

		objectiveManager = level.objectiveManager;

		hud = new HUD(player);
		add(hud);

		for (o in objectiveManager.getObjectives()) {
			add(o);
		}

		FlxG.camera.follow(player, TOPDOWN, 1);
		FlxG.camera.zoom = 0.15;

		FlxG.worldBounds.set(0, 0, 2000, 2000);
		var collisions = new CollisionManager(this);
		collisions.setLevel(level);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.justPressed.SPACE) {
			level.spawnCar();
		}
	}
}
